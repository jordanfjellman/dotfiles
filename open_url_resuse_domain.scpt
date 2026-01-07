on run argv
    if (count of argv) = 0 then
        display dialog "No URL provided"
        return
    end if
    
    set theURL to item 1 of argv
    
    -- Parse domain (simple: after // and before next / or end)
    try
        set AppleScript's text item delimiters to "//"
        set parts to text items of theURL
        set hostPart to item 2 of parts
        set AppleScript's text item delimiters to "/"
        set domain to text item 1 of hostPart
    on error
        set domain to ""
    end try
    
    if domain is "" then
        display dialog "Invalid URL"
        return
    end if
    
    -- Change to "Google Chrome" or "Brave Browser" as needed
    tell application "Brave Browser" -- or "Google Chrome"
        activate
        
        set found to false
        
        repeat with w in every window
            set tabIndex to 0
            repeat with t in every tab of w
                set tabIndex to tabIndex + 1
                try
                    set tabURL to URL of t
                    if tabURL contains domain then
                        set active tab index of w to tabIndex
                        set index of w to 1 -- bring window to front
                        tell t to reload -- optional: reload with new page
                        set URL of t to theURL -- navigate to exact URL
                        set found to true
                        exit repeat
                    end if
                end try
            end repeat
            if found then exit repeat
        end repeat
        
        if not found then
            -- No matching domain tab: open in new tab in front window
            if (count of windows) = 0 then make new window
            tell front window
                make new tab with properties {URL:theURL}
            end tell
        end if
    end tell
end run
