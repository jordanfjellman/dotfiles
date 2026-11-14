function claude-cloudflare --description 'Run claude with the Cloudflare plugin and MCP server'
    claude --settings ~/.claude/settings.cloudflare.json $argv
end
