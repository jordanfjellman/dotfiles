export const NotificationPlugin = async ({ client, $ }) => {
  // Check if we're running inside a fjellyspaces container.
  // FJ_WORKSPACE_NAME is set by fj when creating the container.
  const isFjellyspaces = process.env.FJ_WORKSPACE_NAME !== undefined;
  const workspaceName = process.env.FJ_WORKSPACE_NAME ?? "unknown";

  const AI_MODEL = "github-copilot/gpt-5-mini";
  const AI_TIMEOUT_MILLISECONDS = 10_000;
  const DIALOG_TIMEOUT_SECONDS = 120;

  // ─── Workspace context helper ───────────────────────────────────────────
  // Queries the fjellyspaces daemon for workspace description and state.
  // Tries the container socket first, then the host socket.

  const getWorkspaceContext = async () => {
    if (!isFjellyspaces) return null;

    const sockets = [
      "/run/fj/fj.sock",
      `${process.env.HOME}/.local/share/fjellyspaces/fj.sock`,
    ];

    for (const socket of sockets) {
      try {
        const result =
          await $`curl -sf --unix-socket ${socket} http://localhost/query?workspace=${workspaceName}`
            .quiet()
            .nothrow();

        if (result.exitCode === 0 && result.stdout.trim()) {
          const data = JSON.parse(result.stdout.trim());
          const description = data.description || "";
          if (description) {
            return `Workspace '${workspaceName}': ${description}`;
          }
          return `Workspace '${workspaceName}'`;
        }
      } catch {
        // Try next socket
      }
    }

    return `Workspace '${workspaceName}'`;
  };

  // ─── AI summarization helper ────────────────────────────────────────────
  // Uses opencode run --continue --fork to access the current session's
  // transcript and produce a concise summary. The --fork flag creates a
  // branch so we don't pollute the running session.

  const summarizeWithAI = async (prompt) => {
    try {
      const result = await $`opencode run -m ${AI_MODEL} --continue --fork --format json ${prompt}`
        .quiet()
        .nothrow()
        .timeout(AI_TIMEOUT_MILLISECONDS);

      if (result.exitCode !== 0 || !result.stdout.trim()) return null;

      // --format json outputs newline-delimited JSON events.
      // Find the last "text" event which contains the model's response.
      const lines = result.stdout.trim().split("\n");
      let summary = "";
      for (const line of lines) {
        try {
          const event = JSON.parse(line);
          if (event.type === "text" && event.part?.text) {
            summary += event.part.text;
          }
        } catch {
          // Skip malformed lines
        }
      }

      return summary.trim() || null;
    } catch {
      return null;
    }
  };

  // ─── Detect terminal app ────────────────────────────────────────────────

  const detectTerminal = async () => {
    const terminals = [
      "Ghostty",
      "iTerm2",
      "iTerm",
      "Alacritty",
      "kitty",
      "WezTerm",
      "Hyper",
      "Terminal",
    ];
    for (const app of terminals) {
      const result = await $`pgrep -xq ${app}`.quiet().nothrow();
      if (result.exitCode === 0) return app;
    }
    return "Terminal";
  };

  // ─── Check if terminal is focused ───────────────────────────────────────

  const isTerminalFocused = async () => {
    try {
      const result =
        await $`osascript -e ${'tell application "System Events" to get name of first application process whose frontmost is true'}`
          .quiet()
          .nothrow();

      if (result.exitCode !== 0 || !result.stdout.trim()) return false;

      const frontmostApp = result.stdout.trim();
      const terminals = [
        "Ghostty",
        "iTerm2",
        "iTerm",
        "Alacritty",
        "kitty",
        "WezTerm",
        "Hyper",
        "Terminal",
      ];

      return terminals.includes(frontmostApp);
    } catch {
      return false;
    }
  };

  // ─── Get tmux session name ──────────────────────────────────────────────

  const getTmuxSession = async () => {
    // Check if we're running inside tmux
    if (!process.env.TMUX) return null;

    try {
      const result = await $`tmux display-message -p '#S'`.quiet().nothrow();
      if (result.exitCode === 0 && result.stdout.trim()) {
        return result.stdout.trim();
      }
    } catch {
      // Not in tmux or command failed
    }

    return null;
  };

  // ─── Interactive dialog helper ──────────────────────────────────────────
  // Presents a macOS display dialog with buttons and returns the user's choice.
  // Falls back to a plain display notification if the dialog fails.

  const showDialog = async (title, body, buttons, defaultButton, sound) => {
    const escapedBody = body.replace(/"/g, '\\"').replace(/\n/g, "\\n");
    const buttonList = buttons.map((b) => `"${b}"`).join(", ");
    const soundClause = sound ? ` ${sound}` : "";

    const script = `
set dialogResult to display dialog "${escapedBody}" with title "${title}" buttons {${buttonList}} default button "${defaultButton}"${soundClause} giving up after ${DIALOG_TIMEOUT_SECONDS}
if gave up of dialogResult then
    return "TIMEOUT"
else
    return button returned of dialogResult
end if`;

    try {
      const result = await $`osascript -e ${script}`.quiet().nothrow();
      if (result.exitCode === 0 && result.stdout.trim()) {
        return result.stdout.trim();
      }
    } catch {
      // Dialog failed -- fall back to plain notification
    }

    // Fallback: fire-and-forget notification
    const notifSound = sound ? ` ${sound}` : "";
    await $`osascript -e ${"display notification \"" + escapedBody + "\" with title \"" + title + "\"" + notifSound}`
      .quiet()
      .nothrow();

    return null;
  };

  // ─── Handle dialog choice ──────────────────────────────────────────────

  const handleDialogChoice = async (choice) => {
    if (choice === "Focus Terminal") {
      const terminal = await detectTerminal();
      await $`osascript -e ${`tell application "${terminal}" to activate`}`
        .quiet()
        .nothrow();
    }
    // "Dismiss", "OK", "TIMEOUT", null — no action
  };

  // ─── Event-specific notification logic ──────────────────────────────────

  const notifyWithContext = async (eventType, fallbackMessage, sound, aiPrompt) => {
    if (isFjellyspaces) {
      // Inside container: signal the daemon, which handles host notifications.
      await $`fj-signal idle`.quiet().nothrow();
      return;
    }

    // Skip notification if terminal is already focused
    if (await isTerminalFocused()) {
      return;
    }

    // Host: get workspace context, tmux session, AI summary, and show dialog.
    const context = await getWorkspaceContext();
    const tmuxSession = await getTmuxSession();
    let summary = null;

    if (aiPrompt) {
      summary = await summarizeWithAI(aiPrompt);
    }

    const message = summary || fallbackMessage;

    // Build notification body with all available context
    let body = "";
    if (tmuxSession) {
      body += `Session: ${tmuxSession}\n`;
    }
    if (context) {
      body += `${context}\n`;
    }
    if (body) {
      body += `\n${message}`;
    } else {
      body = message;
    }

    // Choose buttons based on event type.
    let buttons;
    let defaultButton;

    if (eventType === "stop") {
      buttons = ["OK"];
      defaultButton = "OK";
    } else {
      buttons = ["Dismiss", "Focus Terminal"];
      defaultButton = "Focus Terminal";
    }

    const choice = await showDialog(
      "opencode",
      body,
      buttons,
      defaultButton,
      sound,
    );
    await handleDialogChoice(choice);
  };

  return {
    // Signal the fjellyspaces daemon on tool use boundaries.
    "tool.execute.before": async () => {
      if (isFjellyspaces) {
        await $`fj-signal busy`.quiet().nothrow();
      }
    },
    "tool.execute.after": async () => {
      if (isFjellyspaces) {
        await $`fj-signal idle`.quiet().nothrow();
      }
    },

    event: async ({ event }) => {
      // Only notify for primary (root) sessions, not subagent sessions
      if (
        event.type === "session.idle" ||
        event.type === "session.error" ||
        event.type === "permission.asked"
      ) {
        const sessionID = event.properties?.sessionID;
        if (sessionID) {
          try {
            const result = await client.session.get({ sessionID });
            if (result.data?.parentID) {
              return;
            }
          } catch {
            // If lookup fails, fall through and notify anyway
          }
        }
      }

      if (event.type === "session.idle") {
        await notifyWithContext(
          "idle",
          "Needs your attention",
          undefined,
          "Looking at the conversation history, summarize in 1-2 sentences what was accomplished and what needs human attention now. Be direct and concise.",
        );
      }

      if (event.type === "permission.asked") {
        await notifyWithContext(
          "permission",
          "Needs permission approval",
          'sound name "Ping"',
          "A permission prompt is showing. Looking at the conversation history, summarize in 1 sentence what action needs approval and whether it could be destructive. Be direct and concise.",
        );
      }

      if (event.type === "session.error") {
        await notifyWithContext(
          "error",
          "Session error",
          'sound name "Basso"',
          "The session encountered an error. Looking at the conversation history, summarize in 1 sentence what went wrong and suggest next steps. Be direct and concise.",
        );
      }
    },
  };
};
