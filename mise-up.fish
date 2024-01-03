function mise-up -d 'Updates mise-en-place (former rtx) packages'
    if contains -- --check-only $argv; and functions -q mise-check
        mise-check
        return
    end

    if set -q $RTX_GLOBAL_LATEST
        if test -f ~/.tool-versions
            for plugin in $RTX_GLOBAL_LATEST
                mise global $plugin@latest
            end
        else
            for plugin in $RTX_GLOBAL_LATEST
                mise use --global $plugin@latest
            end
        end
    end

    # mise install

    # if contains -- --prune $argv
    #     mise prune --yes
    # end

    mise upgrade

    mise reshim
    and mise list
end
