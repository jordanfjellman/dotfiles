export const AwsGuardPlugin = async ({ client }) => {
  await client.app.log({
    body: {
      service: "aws-guard",
      level: "info",
      message:
        "AWS guard plugin loaded — direct AWS CLI usage via bash is blocked",
    },
  });

  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool !== "bash") return;

      const cmd = output.args.command ?? "";

      // Match `aws` as a standalone command token in various shell contexts:
      // - start of line: `aws logs ...`
      // - after pipe: `cat foo | aws ...`
      // - after &&, ||, ;: `echo hi && aws ...`
      // - in subshell/backtick: `$(aws ...)` or `` `aws ...` ``
      // - after xargs or similar: `xargs aws ...`
      const awsPattern = /(?:^|[|;&`$(\s])aws(?:\s|$)/;

      if (awsPattern.test(cmd)) {
        throw new Error(
          [
            "Direct AWS CLI usage is blocked for safety.",
            "Use the aws-cloudwatch-logs, aws-log-groups, or aws-log-stream tools instead.",
          ].join(" ")
        );
      }
    },
  };
};
