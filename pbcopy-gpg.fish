function pbcopy-gpg -a fingerprint -d 'Copies a GPG public key'
    if test -z "$fingerprint"
        set fingerprint $GPG_KEY_FINGERPRINT
    end

    gpg2 --armor --export $fingerprint | pbcopy

    echo 'GPG public key copied'
end
