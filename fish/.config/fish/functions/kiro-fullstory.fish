function kiro-fullstory --description 'Run kiro-cli with the FullStory agent'
    ~/.kiro/bin/link-plugin-skills
    and kiro-cli chat --agent fullstory $argv
end
