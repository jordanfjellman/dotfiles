function beads-workspaces --description 'List every beads workspace under the given roots (default ~/code)'
    set -l wanted $argv
    if test (count $wanted) -eq 0
        set wanted ~/code
    end

    # Drop bad roots here rather than let fd report them. fd aborts on any invalid
    # path, so one typo would hide every other root.
    set -l roots
    for root in $wanted
        if test -d $root
            set -a roots $root
        else
            echo "Not a directory, skipping: $root" >&2
        end
    end
    if test (count $roots) -eq 0
        return 1
    end

    # -I is not optional. fd honors .git/info/exclude, and `bd init --stealth`
    # excludes .beads there, so the default search hides every private workspace —
    # exactly the ones worth listing.
    set -l dirs (fd --hidden --no-ignore --type d --max-depth 4 '^\.beads$' $roots)

    if test -z "$dirs"
        echo "No beads workspace under: $roots"
        return 0
    end

    printf '%-28s %5s %5s  %s\n' REPO OPEN READY PATH

    for dir in $dirs
        set -l repo (path dirname $dir)
        # A directory named .beads is not proof of a database. The dotfiles stow
        # package holds one with only a config file, and bd writes nothing to
        # stdout for it.
        set -l open (bd -C $repo count --status open 2>/dev/null)
        if test -z "$open"
            continue
        end
        set -l ready (BD_JSON_ENVELOPE=1 bd -C $repo ready --json 2>/dev/null | jq -r '.data | length')
        printf '%-28s %5s %5s  %s\n' (basename $repo) $open $ready $repo
    end
end
