# No namespace-name completion: listing them calls the API server, which costs
# ~380ms per tab and prints an Unauthorized error when the cluster session has
# expired. Add this line back if you want the names:
#   complete -c kubens -n __fish_use_subcommand -a '(kubens 2>/dev/null)' -d Namespace
complete -c kubens -f
complete -c kubens -n __fish_use_subcommand -a - -d "Previous namespace"
complete -c kubens -s f -l force -d "Switch even if the namespace does not exist"
complete -c kubens -s c -l current -d "Show the current namespace"
complete -c kubens -s u -l unset -d "Reset the namespace to default"
complete -c kubens -s h -l help -d "Show help"
complete -c kubens -s V -l version -d "Show version"
