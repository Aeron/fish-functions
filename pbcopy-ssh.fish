function pbcopy-ssh -a type -d 'Copies an SSH public key'
    if test -z "$type"
        set type ed25519
    end

    cat ~/.ssh/id_$type.pub | pbcopy

    echo 'SSH public key copied'
end
