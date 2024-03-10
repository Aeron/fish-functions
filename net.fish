begin
    set ifconfig 'ifconfig.co'

    set protocols 'TCP' 'UDP'
    set tcp_states \
        'CLOSED' 'IDLE' 'BOUND' 'LISTEN' 'ESTABLISHED' \
        'SYN_SENT' 'SYN_RCDV' 'CLOSE_WAIT' 'FIN_WAIT1' \
        'CLOSING' 'LAST_ACK' 'FIN_WAIT_2' 'TIME_WAIT'
    set udp_states 'Unbound' 'Idle'

    function is_valid_port -a port
        return (
            string match -qr '^\d+$' -- "$port"
            and test "$port" -gt 0 -a "$port" -le 65535
        )
    end

    function addrs
        set -l options
        set options $options (fish_opt -s '4' -l 'ipv4')
        set options $options (fish_opt -s '6' -l 'ipv6')

        argparse -n 'net addrs' --ignore-unknown $options -- $argv
        or return

        if test -n "$_flag_4" -o -z "$_flag_6"
            curl -4s "$ifconfig"
        end


        if test -n "$_flag_6" -o -z "$_flag_4"
            curl -6s "$ifconfig"
        end
    end

    function ports
        set -l options
        set options $options (fish_opt -s 'p' -l 'proto' --required-val)
        set options $options (fish_opt -s 's' -l 'state' --required-val)
        set options $options (fish_opt -s 'n' -l 'num' --required-val)

        argparse -n 'net ports' --ignore-unknown $options -- $argv
        or return

        set proto (string upper "$_flag_p")
        set state "$_flag_s"
        set port "$_flag_n"

        if test -n "$proto"
            if not contains "$proto" $protocols
                echo -s \
                    (set_color $fish_color_error) \
                    'error: unsupported protocol; must be either ' \
                    (string join ' or ' $protocols) \
                    (set_color normal)
                return 1
            end
        else
            set proto $protocols[1]
        end

        if test -n "$state"
            set -l states

            if test "$proto" = $protocols[1]
                set state (string upper "$state")
                set states $tcp_states
            else if test "$proto" = $protocols[2]
                set state (string upper (string sub -l 1 $state))(string sub -s 2 $state)
                set states $udp_states
            end

            if not contains "$state" $states
                echo -s \
                    (set_color $fish_color_error) \
                    'error: unsupported state; must be either ' \
                    (string join ', or ' $states) \
                    (set_color normal)
                return 1
            end
        else if test "$proto" = "$protocols[1]"
            set state $tcp_states[4]
        end

        if test -n "$port"; and not is_valid_port "$port"
            echo -s \
                (set_color $fish_color_error) \
                'error: invalid port number; must be in the 1..=65535 range' \
                (set_color normal)
            return 1
        end

        # NOTE: lsof on macOS does not distinguish UDP states by names
        if test "$(uname)" = 'Darwin'
            set state
        end

        set -l opts '-i' "$proto"

        if test -n "$port" -a -n "$state"
            set opts '-i' "$proto:$port" '-s' "$proto:$state"
        else if test -n "$state"
            set opts '-i' "$proto" '-s' "$proto:$state"
        else if test -n "$port"
            set opts '-i' "$proto:$port"
        end

        lsof -nP $opts
    end

    function net -d 'Displays network stuff (IP address(es), used port(s), etc)'
        argparse --ignore-unknown --stop-nonopt -- $argv
        or return

        switch "$argv[1]"
            case 'ports'; ports $argv[2..]
            case 'addrs'; addrs $argv[2..]
            case '*'
                echo 'Display network stuff (IP address(es), used port(s), etc).'
                echo ''
                echo "Usage: $_ CMD [OPTS]"
                echo ''
                echo 'Commands:'
                echo '  addrs              Display the current public IP address(es)'
                echo '  ports              Display the port(s) currently in use'
                echo ''
                echo 'Addresses Options:'
                echo '  -4, --ipv4         Prefer an IPv4 address'
                echo '  -6, --ipv6         Prefer an IPv6 address'
                echo ''
                echo 'Ports Options'
                echo '  -p, --proto PROTO  A protocol to lookup [default: "TCP"]'
                echo '  -s, --state STATE  A state to lookup [default: "LISTEN"]'
                echo '  -n, --num PORT     A port number to lookup'
        end
    end
end
