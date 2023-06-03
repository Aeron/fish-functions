function sri-hash -d 'Calculates subresource integrity hash'
    if test -z $argv[1]
        echo -s (set_color $fish_color_error) 'error: valid file path is required' (set_color normal)
        return 1
    end

    echo sha384-(openssl dgst -sha384 -binary $argv[1] | openssl base64 -A)
end
