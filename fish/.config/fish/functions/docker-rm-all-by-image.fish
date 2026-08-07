function docker-rm-all-by-image --description 'Force remove every container matching a filter'
    if test (count $argv) -eq 0
        echo "Usage: docker-rm-all-by-image <filter>"
        return 1
    end
    set -l containers (docker ps -q --filter "$argv[1]")
    if test -z "$containers"
        echo "No containers match $argv[1]"
        return 0
    end
    docker rm -f $containers
end
