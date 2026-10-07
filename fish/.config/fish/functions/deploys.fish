function deploys --description 'Changes in flight and what waits on me'
    for m in (bd list -n 0 --status open --json | jq -r '.[] | select(.title | test("^mol-land-")) | .id')
        bd mol progress $m | string join ' · '
    end
    bd ready -n 0 --type decision
    bd ready -n 0 --label human
end
