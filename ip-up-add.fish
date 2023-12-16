function ip-up-add -a subnet comment -d 'Adds a subnet for a selective VPN'
    set cidr_regex '\b(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))\b\/\b([0-9]|[12][0-9]|3[0-2])\b'

    if not echo $subnet | grep -q -E $cidr_regex
        if not test -z "$subnet"
            echo -n \
                (set_color red) \
                "$_: subnet value should match CIDR notation (e.g. 127.0.0.1/23)" \
                (set_color normal)
        end

        echo "usage: $_ <subnet> [<comment>]"
        return 1
    end

    set string "/sbin/route add -net $subnet -interface \$1"

    if test -n "$comment"
        set string $string " # $comment"
    end

    set path /etc/ppp/ip-up

    if test -e $path
        echo "$string" | sudo tee $path

        if test $status -eq 0
            echo "Subnet $subnet added to $path"
        end
    else
        echo -n \
            (set_color $fish_color_error) \
            "error: $path does not exist" \
            (set_color normal)
        return 1
    end
end
