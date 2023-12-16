function smtp -a port -d 'Runs a fake (Python) SMTP server'
    set pyver (string split '.' (string split ' ' (command python --version))[2])

    if test $pyver[1] -ge 3 -a $pyver[2] -ge 12
        echo -s \
            (set_color $fish_color_error) \
            "error: Python dropped support for smtpd module since 3.12" \
            (set_color normal)
        return 1
    end

    set host 127.0.0.1

    if test -z "$port"
        set port 8025
    end

    echo -n "Starting fake SMTP on $host:$port"

    set cmd "command python -m smtpd -n -c DebuggingServer $host:$port"

    if test $port -lt 1024  # only root should bind below 1024th port
        set cmd 'sudo' $cmd
    end

    eval $cmd
end
