function dns -a cmd name -d 'Manages common DNS servers of a given network'
    if test -z "$name"
        set name 'Wi-Fi'
    end

    # Quad9 and Cloudflare secure (no malware) servers
    set extra_ipv4 9.9.9.9 149.112.112.112 1.1.1.2 1.0.0.2
    set extra_ipv6 2620:fe::fe 2620:fe::fe:9 2606:4700:4700::1112 2606:4700:4700::1002

    set current (command networksetup -getdnsservers "$name")

    switch "$cmd"
        case 'list' 'ls'
            for addr in $current
                echo $addr
            end
        case 'add'
            for addr in $extra_ipv4 $extra_ipv6
                if not contains $addr $current
                    set current $current $addr
                end
            end

            command networksetup -setdnsservers "$name" $current
        case 'remove' 'rm'
            for addr in $extra_ipv4 $extra_ipv6
                set index (contains -i $addr $current)

                if test -n "$index"
                    set -e current[$index]
                end
            end

            command networksetup -setdnsservers "$name" $current
        case 'clear'
            command networksetup -setdnsservers "$name" empty
        case '*'
            echo "Manage common DNS servers of a given network."
            echo ''
            echo "Usage: $_ CMD [NAME]"
            echo ''
            echo 'Commands:'
            echo '  list/ls    Lists current DNS servers of a network'
            echo '  add        Adds common DNS servers to a network'
            echo '  rm/remove  Removes common DNS servers from a network'
            echo '  clean      Cleans all DNS servers of a network'
            echo ''
            echo 'Parameters:'
            echo '  CMD        A command to perform [required]'
            echo '  NAME       A network name [default: "Wi-Fi"]'
    end
end
