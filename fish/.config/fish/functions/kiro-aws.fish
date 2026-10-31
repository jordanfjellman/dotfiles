function kiro-aws --description 'Run kiro-cli with the AWS agent'
    ~/.kiro/bin/link-plugin-skills
    and kiro-cli chat --agent aws $argv
end
