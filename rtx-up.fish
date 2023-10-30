function rtx-up -d 'Updates rtx packages'
    if contains -- --check-only $argv; and functions -q rtx-check
        rtx-check
        return
    end

    if set -q $RTX_GLOBAL_LATEST
        if test -f ~/.tool-versions
            for plugin in $RTX_GLOBAL_LATEST
                rtx global $plugin@latest
            end
        else
            for plugin in $RTX_GLOBAL_LATEST
                rtx use --global $plugin@latest
            end
        end
    end

    rtx install

    if contains -- --prune $argv
        rtx prune --yes
    end

    rtx reshim
    and rtx list
end
