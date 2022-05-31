function gen-ssh-key -a filename comment -d 'Generates an ed25519 SSH key'
    if test -z $filename
        set filename key
    end

    if test -z $comment
        set comment (whoami)@(hostname)
    end

    ssh-keygen -o -a 100 -t ed25519 -C "$comment" -f $filename
end
