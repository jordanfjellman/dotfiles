complete -c kubectx -f
complete -c kubectx -n __fish_use_subcommand -a '(kubectl config get-contexts -o name)' -d Context
complete -c kubectx -n __fish_use_subcommand -a - -d "Previous context"
complete -c kubectx -s s -l shell -d "Start a shell scoped to a context"
complete -c kubectx -s r -l readonly -d "Start a read-only shell for a context"
complete -c kubectx -s c -l current -d "Show the current context name"
complete -c kubectx -s u -l unset -d "Unset the current context"
complete -c kubectx -s d -d "Delete a context" -a '(kubectl config get-contexts -o name)'
complete -c kubectx -s h -l help -d "Show help"
complete -c kubectx -s V -l version -d "Show version"
