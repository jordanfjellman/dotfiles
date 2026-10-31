function kiro-atlassian --description 'Run kiro-cli with the Atlassian agent'
    ~/.kiro/bin/link-plugin-skills
    and kiro-cli chat --agent atlassian $argv
end
