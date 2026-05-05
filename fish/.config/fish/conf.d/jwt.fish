function jwt --description "Decode a JWT token from the clipboard"
    pbpaste | jq -R 'split(".") | .[0],.[1] | @base64d | fromjson'
end
