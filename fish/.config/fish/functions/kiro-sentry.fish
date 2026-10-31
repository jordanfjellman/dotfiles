function kiro-sentry --description 'Run kiro-cli with the Sentry agent'
    ~/.kiro/bin/link-plugin-skills
    and kiro-cli chat --agent sentry $argv
end
