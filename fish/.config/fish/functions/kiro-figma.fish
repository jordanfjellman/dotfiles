function kiro-figma --description 'Run kiro-cli with the Figma agent'
    ~/.kiro/bin/link-plugin-skills
    and kiro-cli chat --agent figma $argv
end
