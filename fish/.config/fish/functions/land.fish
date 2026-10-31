function land --description 'Track a PR from merge to healthy prod: land <pr> [owner/repo]'
    set -l pr $argv[1]
    set -l repo $argv[2]
    test -n "$repo"; or set repo (gh repo view --json nameWithOwner -q .nameWithOwner)
    set -l ref gh-pr-$repo#$pr
    set -l open (BD_JSON_ENVELOPE=1 bd list -n 0 --all --external-ref $ref --json | jq -r '[.data[] | select(.status != "closed")][0].id // empty')
    if test -n "$open"
        echo "$repo#$pr is already landing as $open" >&2
        return 1
    end
    set -l title (gh pr view $pr -R $repo --json title -q .title); or return 1
    set -l bead (bd create "Land $repo#$pr: $title" --external-ref $ref --silent); or return 1
    bd mol pour mol-land-prod --var bead=$bead --var pr=$pr --var repo=$repo
end
