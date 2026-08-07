function start-kiro-gateway --description 'Run the kiro-gateway container on port 9111'
    set -l container_name kiro-gateway
    docker rm -f $container_name &>/dev/null
    docker run -d -p 9111:8000 \
        -v ~/Library/Application\ Support/kiro-cli:/home/kiro/.local/share/kiro-cli:ro \
        -e KIRO_CLI_DB_FILE=/home/kiro/.local/share/kiro-cli/data.sqlite3 \
        -e PROXY_API_KEY="$(cat ~/.secrets/kiro-gateway-password)" \
        --name $container_name \
        ghcr.io/jwadow/kiro-gateway:latest
end
