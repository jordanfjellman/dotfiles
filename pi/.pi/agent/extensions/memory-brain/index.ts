/**
 * memory-brain — record which agent-memory notes this session reads and writes.
 *
 * Emits one access event per vault-touching tool call into the access log that
 * `memory-brain serve` tails. Path resolution and the event schema live in the
 * `memory-brain` CLI, not here, so the pi and Claude Code writers can never
 * drift apart. Fire-and-forget: a failed recorder must not disturb a tool call.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { spawn } from "node:child_process";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";

const RECORDER = [
  path.join(os.homedir(), ".local", "bin", "memory-brain"),
  path.join(os.homedir(), "code", "personal", "dotfiles", "memory-brain", ".local", "bin", "memory-brain"),
].find((p) => fs.existsSync(p));

const RECORDED_TOOLS = new Set(["read", "edit", "write", "bash"]);

export default function (pi: ExtensionAPI) {
  if (!RECORDER) return;

  pi.on("tool_execution_end", async (event, ctx) => {
    if (!RECORDED_TOOLS.has(event.toolName)) return;

    const payload = JSON.stringify({
      sessionId: ctx.sessionManager?.getSessionId?.() ?? null,
      cwd: process.cwd(),
      toolName: event.toolName,
      args: event.args,
      model: ctx.getModel?.()?.id ?? null,
      actor: "main",
    });

    try {
      const child = spawn(RECORDER, ["record", "--harness", "pi"], {
        stdio: ["pipe", "ignore", "ignore"],
        detached: true,
      });
      child.on("error", () => {});
      child.stdin.on("error", () => {});
      child.stdin.end(payload);
      child.unref();
    } catch {
      // Observability is never worth failing a tool call over.
    }
  });
}
