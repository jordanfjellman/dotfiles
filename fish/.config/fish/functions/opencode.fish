function opencode --description 'Run opencode with the config for this machine'
    set -l profile (machine-profile 2>/dev/null)
    if test "$profile" = work
        set -x OPENCODE_CONFIG ~/.config/opencode/opencode.work.jsonc
    end
    command opencode $argv
end
