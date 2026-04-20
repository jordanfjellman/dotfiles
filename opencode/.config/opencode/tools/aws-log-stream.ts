import { tool } from "@opencode-ai/plugin";
import { readFileSync } from "fs";
import { homedir } from "os";
import path from "path";

function getAwsProfile(): string {
  const secretPath = path.join(homedir(), ".secrets", "aws-profile-name");
  try {
    return readFileSync(secretPath, "utf-8").trim();
  } catch {
    throw new Error(
      `Could not read AWS profile from ${secretPath}. Create this file with your AWS profile name.`
    );
  }
}

function toEpochMs(iso: string): number {
  const ms = new Date(iso).getTime();
  if (isNaN(ms)) throw new Error(`Invalid date: ${iso}`);
  return ms;
}

export default tool({
  description: [
    "Read events from a specific AWS CloudWatch log stream.",
    "Use this when you know the exact log group and log stream name",
    "(e.g. from a previous filter-log-events result).",
    "Returns events in chronological order from the specified stream.",
  ].join(" "),
  args: {
    logGroupName: tool.schema
      .string()
      .describe(
        "Full CloudWatch log group name (e.g. /aws/lambda/my-func)"
      ),
    logStreamName: tool.schema
      .string()
      .describe(
        "Log stream name within the log group (e.g. 2024/01/15/[$LATEST]abc123)"
      ),
    startTime: tool.schema
      .string()
      .optional()
      .describe(
        "Start time as ISO 8601 string. Defaults to 1 hour ago."
      ),
    endTime: tool.schema
      .string()
      .optional()
      .describe("End time as ISO 8601 string. Defaults to now."),
    limit: tool.schema
      .number()
      .optional()
      .describe("Max events to return (1-500, default 100)"),
  },
  async execute(args) {
    const profile = getAwsProfile();
    const now = Date.now();
    const oneHourAgo = now - 60 * 60 * 1000;

    const startMs = args.startTime ? toEpochMs(args.startTime) : oneHourAgo;
    const endMs = args.endTime ? toEpochMs(args.endTime) : now;
    const limit = Math.min(Math.max(args.limit ?? 100, 1), 500);

    const cmdArgs = [
      "logs",
      "get-log-events",
      "--profile",
      profile,
      "--region",
      "us-east-1",
      "--log-group-name",
      args.logGroupName,
      "--log-stream-name",
      args.logStreamName,
      "--start-time",
      String(startMs),
      "--end-time",
      String(endMs),
      "--limit",
      String(limit),
      "--start-from-head",
      "--output",
      "json",
    ];

    try {
      const proc = Bun.spawn(["aws", ...cmdArgs], {
        stdout: "pipe",
        stderr: "pipe",
      });
      const [stdout, stderr] = await Promise.all([
        new Response(proc.stdout).text(),
        new Response(proc.stderr).text(),
      ]);
      const exitCode = await proc.exited;

      if (exitCode !== 0) {
        throw new Error(stderr.trim());
      }

      const parsed = JSON.parse(stdout);
      const events = (parsed.events ?? []).map(
        (e: { timestamp: number; message: string }) => ({
          timestamp: new Date(e.timestamp).toISOString(),
          message: e.message.trimEnd(),
        })
      );

      if (events.length === 0) {
        return `No events found in stream "${args.logStreamName}" for the given time range.`;
      }

      return JSON.stringify(events, null, 2);
    } catch (e: any) {
      throw new Error(`aws logs get-log-events failed: ${e.message}`);
    }
  },
});
