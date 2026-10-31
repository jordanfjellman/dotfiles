function cortex --description 'Run cortex with all tool calls auto-approved'
    # --bypass parses only on the root command and on `resume`. Put it before a
    # subcommand and yargs opens the TUI instead of dispatching the subcommand.
    set -l subcommands exec mcp acp profile skill ctx conversations resume update \
        versions worktree connections search analyst agents agent-studio lineage \
        airflow completion plugin managed-settings browser logs memory

    if test (count $argv) -eq 0
        command cortex --bypass
    else if test "$argv[1]" = resume
        command cortex resume --bypass $argv[2..]
    else if contains -- "$argv[1]" $subcommands
        command cortex $argv
    else
        command cortex --bypass $argv
    end
end
