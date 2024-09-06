function ping -w ping -d 'A wrapper around the ping with a default host address'
    if test -z $argv
        if test -z $PING_DEFAULT_HOST
            # set PING_DEFAULT_HOST 1.1.1.1
            set PING_DEFAULT_HOST 9.9.9.9
        end

        command ping $PING_DEFAULT_HOST
    else
        command ping $argv
    end
end
