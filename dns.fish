function dns -a cmd name -d 'Adds/removes common DNS servers'
    if test -z "$name"
        set name 'Wi-Fi'
    end

    # Quad9 and Cloudflare secure (no malware) servers
    set extra_ipv4 9.9.9.9 149.112.112.112 1.1.1.2 1.0.0.2
    set extra_ipv6 2620:fe::fe 2620:fe::fe:9 2606:4700:4700::1112 2606:4700:4700::1002

    set current (command networksetup -getdnsservers $name)

    switch "$cmd"
        case 'clear'
            command networksetup -setdnsservers "$name" empty
        case 'add'
            for i in $extra_ipv4 $extra_ipv6
                if not contains $i $current
                    set current $current $i
                end
            end

            command networksetup -setdnsservers "$name" $current
        case 'remove' 'rm'
            for i in $extra_ipv4 $extra_ipv6
                set index (contains -i $i $current)

                if test -n "$index"
                    set -e current[$index]
                end
            end

            command networksetup -setdnsservers "$name" $current
        case '*'
            echo "$_ add or remove common DNS servers to or from a network."
            echo ''
            echo 'Usage:'
            echo "    $_ CMD [NAME]"
            echo ''
            echo 'Commands:'
            echo '    add          Adds common DNS servers to a network'
            echo '    rm/remove    Removes common DNS servers from a network'
            echo '    clean        Cleans all DNS servers of a network'
            echo ''
            echo 'Parameters:'
            echo '    CMD          A command to perform [required]'
            echo '    NAME         A network name [default: "Wi-Fi"]'
    end
end
