function sso --description 'Export AWS credentials for a profile into this shell'
    if test (count $argv) -eq 0
        echo "Usage: sso <profile>"
        return 1
    end
    eval (aws configure export-credentials --format env --profile $argv[1])
end
