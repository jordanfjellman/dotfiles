function load_env --description 'Export the KEY=value pairs in a file into this shell'
    if test (count $argv) -lt 1
        echo "Usage: load_env <env_file>"
        return 1
    end

    set -l env_file $argv[1]

    if not test -f $env_file
        echo "Error: File not found: $env_file"
        return 1
    end

    while read -l line
        if test -z (string trim -- $line); or string match -q '#*' -- $line
            continue
        end

        if string match -q '*=*' -- $line
            set -l key (string split -m 1 '=' $line)[1]
            set -l value (string split -m 1 '=' $line)[2]

            set key (string trim -- $key)
            set value (string trim -- $value)
            set value (string trim -c '"' -- $value)
            set value (string trim -c "'" -- $value)

            set -gx $key $value
        end
    end <$env_file
end
