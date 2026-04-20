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

export default tool({
  description: [
    "List available AWS CloudWatch log groups.",
    "Use this to discover log group names before querying logs.",
    "Supports prefix filtering to narrow results (e.g. /aws/lambda/ to find Lambda log groups).",
    "Returns log group names, stored bytes, and retention settings.",
  ].join(" "),
  args: {
    prefix: tool.schema
      .string()
      .optional()
      .describe(
        "Log group name prefix to filter by (e.g. /aws/lambda/ or /custom/)"
      ),
    limit: tool.schema
      .number()
      .optional()
      .describe("Max log groups to return (1-50, default 50)"),
  },
  async execute(args) {
    const profile = getAwsProfile();
    const limit = Math.min(Math.max(args.limit ?? 50, 1), 50);

    const cmdArgs = [
      "logs",
      "describe-log-groups",
      "--profile",
      profile,
      "--region",
      "us-east-1",
      "--limit",
      String(limit),
      "--output",
      "json",
    ];

    if (args.prefix) {
      cmdArgs.push("--log-group-name-prefix", args.prefix);
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
      const groups = (parsed.logGroups ?? []).map(
        (g: {
          logGroupName: string;
          storedBytes: number;
          retentionInDays?: number;
          creationTime: number;
        }) => ({
          name: g.logGroupName,
          storedBytes: g.storedBytes,
          retentionDays: g.retentionInDays ?? "never expires",
          created: new Date(g.creationTime).toISOString(),
        })
      );

      if (groups.length === 0) {
        return `No log groups found${args.prefix ? ` with prefix "${args.prefix}"` : ""}.`;
      }

      return JSON.stringify(groups, null, 2);
    } catch (e: any) {
      throw new Error(`aws logs describe-log-groups failed: ${e.message}`);
    }
  },
});
