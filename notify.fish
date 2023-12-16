function notify -a message title subtitle -d 'Displays a macOS notification'
    if test -z "$message"
        echo "usage: $_ <message> [<title> [<subtitle>]]"
        return 1
    end

    set script "display notification \"$message\""

    if test -n "$title"
        set script $script "with title \"$title\""
        if test -n "$subtitle"
            set script $script "subtitle \"$subtitle\""
        end
    end

    /usr/bin/osascript -e "$script"
end
