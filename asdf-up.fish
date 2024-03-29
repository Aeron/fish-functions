function asdf-up -d 'Updates asdf, its plugins, and reshims packages'
    # asdf update  # managed by Homebrew
    asdf plugin update --all

    if contains -- --check-only $argv; and functions -q asdf-check
        asdf-check --no-update
        return
    end

    for plugin in $ASDF_GLOBAL_LATEST
        asdf install $plugin latest
        and asdf global $plugin latest
    end

    if contains -- --prune $argv; and functions -q asdf-prune
        asdf-prune -f
    end

    asdf reshim
    and asdf list
end
