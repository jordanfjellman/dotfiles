#!/bin/sh
# notify.sh — Claude Code hook for notifications and session events.
#
# Called by Claude Code hooks (Notification, Stop, StopFailure) with JSON on stdin.
# Three layers of intelligence:
#   1. Queries fjellyspaces daemon for workspace context (description, state)
#   2. Invokes claude --bare -p --model haiku to summarize the situation
#   3. Presents an interactive macOS dialog with action buttons
#
# Inside a fjellyspaces container: signals daemon via fj-signal (daemon handles
# host-side notifications). AI summarization and dialog are host-only.
#
# Stdin JSON fields used:
#   hook_event_name   — "Notification", "Stop", "StopFailure"
#   notification_type — "idle_prompt", "permission_prompt" (Notification only)
#   session_id        — session identifier
#   transcript_path   — path to JSONL transcript file
#   tool_name         — tool being requested (permission_prompt only)
#   tool_input        — tool arguments (permission_prompt only)

set -u

AI_MODEL="haiku"
AI_TIMEOUT=10
DIALOG_TIMEOUT=120

# ─── 1. Read and parse stdin JSON ────────────────────────────────────────────

INPUT="$(cat)"

HOOK_EVENT="$(printf '%s' "$INPUT" | jq -r '.hook_event_name // ""' 2>/dev/null)"
NOTIFICATION_TYPE="$(printf '%s' "$INPUT" | jq -r '.notification_type // ""' 2>/dev/null)"
SESSION_ID="$(printf '%s' "$INPUT" | jq -r '.session_id // ""' 2>/dev/null)"
TRANSCRIPT_PATH="$(printf '%s' "$INPUT" | jq -r '.transcript_path // ""' 2>/dev/null)"
TOOL_NAME="$(printf '%s' "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null)"
TOOL_INPUT="$(printf '%s' "$INPUT" | jq -c '.tool_input // {}' 2>/dev/null)"

# ─── 2. Map event to fallback message ────────────────────────────────────────

case "$HOOK_EVENT" in
    Notification)
        case "$NOTIFICATION_TYPE" in
            idle_prompt)       FALLBACK_MESSAGE="Needs your attention" ;;
            permission_prompt) FALLBACK_MESSAGE="Needs permission approval" ;;
            *)                 FALLBACK_MESSAGE="Notification" ;;
        esac
        ;;
    Stop)
        FALLBACK_MESSAGE="Task completed"
        ;;
    StopFailure)
        FALLBACK_MESSAGE="Session error"
        ;;
    *)
        FALLBACK_MESSAGE="Event: ${HOOK_EVENT}"
        ;;
esac

# ─── 3. Determine notification sound ─────────────────────────────────────────

case "$HOOK_EVENT" in
    StopFailure)
        SOUND='sound name "Basso"'
        ;;
    Notification)
        if [ "$NOTIFICATION_TYPE" = "permission_prompt" ]; then
            SOUND='sound name "Ping"'
        else
            SOUND=""
        fi
        ;;
    *)
        SOUND=""
        ;;
esac

# ─── 4. Query daemon for workspace context ───────────────────────────────────

WORKSPACE_NAME="${FJ_WORKSPACE_NAME:-}"
WORKSPACE_CONTEXT=""

query_daemon_context() {
    local socket="$1"
    local name="$2"

    if [ ! -S "$socket" ] || [ -z "$name" ]; then
        return 1
    fi

    local response
    response="$(curl -sf --unix-socket "$socket" \
        "http://localhost/query?workspace=${name}" 2>/dev/null)" || return 1

    local description
    description="$(printf '%s' "$response" | jq -r '.description // ""' 2>/dev/null)"

    if [ -n "$description" ]; then
        printf "Workspace '%s': %s" "$name" "$description"
    else
        printf "Workspace '%s'" "$name"
    fi
}

if [ -n "$WORKSPACE_NAME" ]; then
    WORKSPACE_CONTEXT="$(query_daemon_context "/run/fj/fj.sock" "$WORKSPACE_NAME" 2>/dev/null)" ||
    WORKSPACE_CONTEXT="$(query_daemon_context "${HOME}/.local/share/fjellyspaces/fj.sock" "$WORKSPACE_NAME" 2>/dev/null)" ||
    WORKSPACE_CONTEXT="Workspace '${WORKSPACE_NAME}'"
fi

# ─── 5. Inside container: signal daemon and exit ─────────────────────────────

if [ -n "${FJ_WORKSPACE_NAME:-}" ]; then
    fj-signal idle 2>/dev/null || true
    exit 0
fi

# ─── 6. AI summarization (host only) ─────────────────────────────────────────
#
# Uses claude --bare -p --model haiku for a cheap, fast 1-2 sentence summary.
# Falls back to the static FALLBACK_MESSAGE on any failure.

AI_SUMMARY=""

summarize_with_ai() {
    local prompt="$1"

    # Bail if claude CLI is not available.
    if ! command -v claude >/dev/null 2>&1; then
        return 1
    fi

    local result
    result="$(timeout "$AI_TIMEOUT" claude --bare -p --model "$AI_MODEL" \
        --no-session-persistence --max-turns 1 \
        "$prompt" 2>/dev/null)" || return 1

    if [ -n "$result" ]; then
        printf '%s' "$result"
        return 0
    fi
    return 1
}

case "$HOOK_EVENT" in
    Notification)
        if [ "$NOTIFICATION_TYPE" = "permission_prompt" ] && [ -n "$TOOL_NAME" ]; then
            # Permission prompt: we know exactly what tool is being requested.
            TOOL_DESC="Tool: ${TOOL_NAME}"
            if [ "$TOOL_NAME" = "Bash" ]; then
                BASH_CMD="$(printf '%s' "$TOOL_INPUT" | jq -r '.command // ""' 2>/dev/null)"
                if [ -n "$BASH_CMD" ]; then
                    TOOL_DESC="Command: ${BASH_CMD}"
                fi
            fi
            AI_SUMMARY="$(summarize_with_ai \
                "A Claude Code session needs permission to run the following. ${TOOL_DESC}. In 1-2 sentences, explain what this does and whether it could be destructive or have side effects. Be direct and concise." \
                2>/dev/null)" || true
        elif [ "$NOTIFICATION_TYPE" = "idle_prompt" ] && [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
            # Idle prompt with transcript: summarize what happened.
            LAST_LINES="$(tail -20 "$TRANSCRIPT_PATH" 2>/dev/null)"
            if [ -n "$LAST_LINES" ]; then
                AI_SUMMARY="$(printf '%s' "$LAST_LINES" | summarize_with_ai \
                    "Here are the last entries from a Claude Code session transcript (piped to stdin). Summarize in 1-2 sentences: what was accomplished and what needs human attention now. Be direct and concise." \
                    2>/dev/null)" || true
            fi
        fi
        ;;
    Stop)
        if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
            LAST_LINES="$(tail -20 "$TRANSCRIPT_PATH" 2>/dev/null)"
            if [ -n "$LAST_LINES" ]; then
                AI_SUMMARY="$(printf '%s' "$LAST_LINES" | summarize_with_ai \
                    "Here are the last entries from a completed Claude Code session transcript (piped to stdin). Summarize in 1-2 sentences: what was accomplished and the current state. Be direct and concise." \
                    2>/dev/null)" || true
            fi
        fi
        ;;
    StopFailure)
        AI_SUMMARY="$(summarize_with_ai \
            "A Claude Code session ended with an error. Session ID: ${SESSION_ID}. Summarize what likely happened and suggest next steps in 1-2 sentences. Be direct and concise." \
            2>/dev/null)" || true
        ;;
esac

# Use AI summary if available, otherwise fall back to static message.
if [ -n "$AI_SUMMARY" ]; then
    MESSAGE="$AI_SUMMARY"
else
    MESSAGE="$FALLBACK_MESSAGE"
fi

# ─── 7. Detect terminal application ──────────────────────────────────────────

detect_terminal() {
    for app in "Ghostty" "iTerm2" "iTerm" "Alacritty" "kitty" "WezTerm" "Hyper" "Terminal"; do
        if pgrep -xq "$app" 2>/dev/null; then
            printf '%s' "$app"
            return 0
        fi
    done
    # macOS Terminal.app shows as "Terminal" in process list
    printf 'Terminal'
}

TERMINAL_APP="$(detect_terminal)"

# ─── 8. Interactive dialog (host only) ───────────────────────────────────────

# Build the dialog text.
if [ -n "$WORKSPACE_CONTEXT" ]; then
    DIALOG_TEXT="${WORKSPACE_CONTEXT}

${MESSAGE}"
else
    DIALOG_TEXT="$MESSAGE"
fi

# Escape double quotes for AppleScript.
DIALOG_TEXT="$(printf '%s' "$DIALOG_TEXT" | sed 's/"/\\"/g')"

# Choose buttons based on event type.
case "$HOOK_EVENT" in
    Stop)
        BUTTONS='buttons {"OK"} default button "OK"'
        ;;
    *)
        BUTTONS='buttons {"Dismiss", "Focus Terminal"} default button "Focus Terminal"'
        ;;
esac

# Try display dialog first (interactive, returns choice).
CHOICE="$(osascript -e "
set dialogResult to display dialog \"${DIALOG_TEXT}\" with title \"Claude Code\" ${BUTTONS} ${SOUND} giving up after ${DIALOG_TIMEOUT}
if gave up of dialogResult then
    return \"TIMEOUT\"
else
    return button returned of dialogResult
end if
" 2>/dev/null)" || CHOICE=""

# Handle the user's choice.
case "$CHOICE" in
    "Focus Terminal")
        osascript -e "tell application \"${TERMINAL_APP}\" to activate" 2>/dev/null || true
        ;;
    "TIMEOUT"|"Dismiss"|"OK"|"")
        # No action needed.
        ;;
esac
