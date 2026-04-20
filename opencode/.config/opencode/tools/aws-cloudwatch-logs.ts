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
    "Search and filter AWS CloudWatch log events across any log group.",
    "Use this to investigate errors, search for request IDs, or tail recent activity.",
    "Accepts CloudWatch filter patterns (e.g. \"ERROR\", \"{ $.level = \\\"error\\\" }\").",
    "Returns log events with timestamps, log stream names, and messages.",
    "AWS credentials are never exposed — the profile is read from ~/.secrets/aws-profile-name.",
  ].join(" "),
  args: {
    logGroupName: tool.schema
      .string()
      .describe(
        "Full CloudWatch log group name (e.g. /aws/lambda/my-func or /custom/my-app)"
      ),
    startTime: tool.schema
      .string()
      .optional()
      .describe(
        "Start time as ISO 8601 string (e.g. 2024-01-15T10:00:00Z). Defaults to 1 hour ago."
      ),
    endTime: tool.schema
      .string()
      .optional()
      .describe(
        "End time as ISO 8601 string (e.g. 2024-01-15T11:00:00Z). Defaults to now."
      ),
    filterPattern: tool.schema
      .string()
      .optional()
      .describe(
        'CloudWatch Logs filter pattern (e.g. "ERROR", "{ $.statusCode = 500 }")'
      ),
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
      "filter-log-events",
      "--profile",
      profile,
      "--region",
      "us-east-1",
      "--log-group-name",
      args.logGroupName,
      "--start-time",
      String(startMs),
      "--end-time",
      String(endMs),
      "--limit",
      String(limit),
      "--output",
      "json",
    ];

    if (args.filterPattern) {
      cmdArgs.push("--filter-pattern", args.filterPattern);
    }

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
        (e: { timestamp: number; logStreamName: string; message: string }) => ({
          timestamp: new Date(e.timestamp).toISOString(),
          logStream: e.logStreamName,
          message: e.message.trimEnd(),
        })
      );

      if (events.length === 0) {
        return `No log events found in ${args.logGroupName} for the given time range and filter.`;
      }

      return JSON.stringify(events, null, 2);
    } catch (e: any) {
      throw new Error(`aws logs filter-log-events failed: ${e.message}`);
    }
  },
});
