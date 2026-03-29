#!/bin/sh
# evaluate-permission.sh — Claude Code PermissionRequest hook.
#
# Synchronous hook that evaluates tool calls against a static allowlist.
# Auto-approves safe, read-only operations. Everything else falls through
# to the normal permission dialog (which triggers the Notification hook).
#
# Stdin: JSON with tool_name, tool_input (from Claude Code hook contract)
# Stdout: JSON decision if auto-approved, empty otherwise
# Exit 0 always (non-zero would block Claude Code with an error)

set -u

INPUT="$(cat)"

TOOL_NAME="$(printf '%s' "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null)"
TOOL_COMMAND="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null)"

# ─── Read-only tools: always safe ─────────────────────────────────────────────

case "$TOOL_NAME" in
    Read|Glob|Grep|Search|WebFetch|WebSearch)
        printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
        exit 0
        ;;
esac

# ─── Bash commands: match against allowlist ───────────────────────────────────

if [ "$TOOL_NAME" = "Bash" ] && [ -n "$TOOL_COMMAND" ]; then
    # Extract the base command (first word before any flags/arguments).
    BASE_CMD="$(printf '%s' "$TOOL_COMMAND" | awk '{print $1}')"

    # Commands that are always safe (read-only or build/test).
    case "$BASE_CMD" in
        # Read-only inspection
        ls|cat|head|tail|wc|find|which|file|stat|du|df|env|printenv|echo|printf|date|pwd|whoami|hostname|uname)
            printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
            exit 0
            ;;
        # Git read-only
        git)
            GIT_SUBCMD="$(printf '%s' "$TOOL_COMMAND" | awk '{print $2}')"
            case "$GIT_SUBCMD" in
                status|diff|log|show|branch|tag|remote|stash|blame|shortlog|describe|rev-parse|rev-list|ls-files|ls-tree|config)
                    printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
                    exit 0
                    ;;
            esac
            ;;
        # Rust build/test
        cargo)
            CARGO_SUBCMD="$(printf '%s' "$TOOL_COMMAND" | awk '{print $2}')"
            case "$CARGO_SUBCMD" in
                test|build|check|clippy|fmt|doc|bench|tree|metadata)
                    printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
                    exit 0
                    ;;
            esac
            ;;
        # Node build/test
        npm|npx|yarn|pnpm)
            NODE_SUBCMD="$(printf '%s' "$TOOL_COMMAND" | awk '{print $2}')"
            case "$NODE_SUBCMD" in
                test|build|lint|check|run|list|ls|info|view|outdated|audit)
                    printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
                    exit 0
                    ;;
            esac
            ;;
        # Python
        python|python3|pytest|ruff|mypy|black|isort|flake8|pylint)
            printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
            exit 0
            ;;
        # Search tools
        rg|ripgrep|grep|egrep|fgrep|ag|fd|fzf|jq|yq|sed|awk|sort|uniq|tr|cut|tee|xargs)
            printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
            exit 0
            ;;
        # Make (usually safe — worst case rebuilds)
        make)
            printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
            exit 0
            ;;
        # Docker read-only
        docker)
            DOCKER_SUBCMD="$(printf '%s' "$TOOL_COMMAND" | awk '{print $2}')"
            case "$DOCKER_SUBCMD" in
                ps|images|inspect|logs|top|stats|info|version|network)
                    printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
                    exit 0
                    ;;
            esac
            ;;
        # GitHub CLI read-only
        gh)
            GH_SUBCMD="$(printf '%s' "$TOOL_COMMAND" | awk '{print $2}')"
            case "$GH_SUBCMD" in
                pr|issue|repo|api|search|status|run)
                    printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
                    exit 0
                    ;;
            esac
            ;;
        # curl (read-only network requests)
        curl|wget)
            printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
            exit 0
            ;;
    esac
fi

# ─── Not in allowlist: fall through to normal permission dialog ───────────────

exit 0
