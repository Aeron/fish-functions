begin
    function napi -a value
        if string match -qr '^\d+$' (string trim $value)
            return 1
        end
        return 0
    end

    function ssh_key -a filename comment
        if test -z "$filename"
            set filename key
        end

        if test -z "$comment"
            set comment (whoami)@(hostname)
        end

        ssh-keygen -o -a 100 -t ed25519 -C "$comment" -f "$filename"
    end

    function x509_cert -a cname days
        if test -z "$cname"
            set cname localhost
        end

        if test -z "$days"
            set days 365
        else if napi $bits
            echo -s \
                (set_color $fish_color_error) \
                "error: days value must be a positive integer" \
                (set_color normal)
            return 1
        end

        openssl req \
            -x509 \
            -newkey rsa:4096 \
            -sha256 \
            -nodes \
            -days $days \
            -subj "/CN=$cname" \
            -keyout key.pem \
            -out cert.pem
    end

    function rand_base64 -a bits
        if test -z "$bits"
            set bits 32
        else if napi $bits
            echo -s \
                (set_color $fish_color_error) \
                "error: bit-length must be a positive integer" \
                (set_color normal)
            return 1
        end

        openssl rand -base64 $bits
    end

    function gen -d 'Generates either an X.509 cert, SSH key, random base64 string'
        set -l options
        set options $options (fish_opt -s B -l bits --optional-val)
        set options $options (fish_opt -s N -l cn --optional-val)
        set options $options (fish_opt -s D -l days --optional-val)
        set options $options (fish_opt -s f -l filename --optional-val)
        set options $options (fish_opt -s C -l comment --optional-val)

        argparse --ignore-unknown $options -- $argv

        set params (string match --invert -- '-*' $argv)

        switch "$params[1]"
            case 'cert' 'x509'
                x509_cert $_flag_cn $_flag_days
            case 'ssh' 'key'
                ssh_key $_flag_filename $_flag_comment
            case 'base64' 'b64'
                rand_base64 $_flag_bits
            case '*'
                echo "$_ generate either an X.509 cert, SSH key, random base64 string."
                echo ''
                echo 'Usage:'
                echo "    $_ ENTITY [OPTS]"
                echo ''
                echo 'Entities:'
                echo '    cert/x509          Generate an X.509 certificate'
                echo '    ssh/key            Generate an SSH key'
                echo '    base64/b64         Generate a random base64 string'
                echo ''
                echo 'Options:'
                echo '    --bits=NUM         Base64 binary bit-length [optional]'
                echo '    --cn=NAME          Certificate common name [optional]'
                echo '    --days=NUM         Certificate validity period [optional]'
                echo '    --filename=NAME    SSH key filename [optional]'
                echo '    --comment=TEXT     SSH key comment [optional]'
                echo ''
                echo 'Parameters:'
                echo '    ENTITY             An entity name [required]'
        end
    end
end
