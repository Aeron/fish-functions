function rtx-up -d 'Updates rtx packages'
    if contains -- --check-only $argv; and functions -q rtx-check
        rtx-check
        return
    end

    for plugin in $RTX_GLOBAL_LATEST
        rtx global $plugin@latest
    end

    rtx install $RTX_GLOBAL_LATEST

    if contains -- --prune $argv
        rtx prune
    end

    rtx reshim
    and rtx list
end
