function pbcopy-ssh -a type -d 'Copies an SSH public key'
    if test -z "$type"
        set type ed25519
    end

    pbcopy <~/.ssh/id_$type.pub
    and echo "SSH public key ($type) copied"
end
