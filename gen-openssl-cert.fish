function gen-openssl-cert -a cn days -d 'Generates an OpenSSL X509 certificate'
    if test -z $cn
        set cn localhost
    end

    if test -z $days
        set days 365
    end

    openssl req -x509 \
        -newkey rsa:4096 -sha256 \
        -days $days -nodes -subj "/CN=$cn" \
        -keyout key.pem -out cert.pem
end
