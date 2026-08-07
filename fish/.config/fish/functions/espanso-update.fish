function espanso-update --description 'Reinstall the lw-snippets espanso package'
    espanso install lw-snippets --git git@github.com:LifewayIT/lw-snippets.git --external --force
    and espanso restart
end
