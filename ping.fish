function ping -w ping -d 'A wrapper around the ping with a default address'
    if test -z $argv
        command ping 1.1.1.1
    else
        command ping $argv
    end
end
