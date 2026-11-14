function kiro-cloudflare --description 'Run kiro-cli with the Cloudflare agent'
    ~/.kiro/bin/link-plugin-skills
    and kiro-cli chat --agent cloudflare $argv
end
