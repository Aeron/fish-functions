function soft-up -d "Updates macOS software"
    if contains -- --check-only $argv
        softwareupdate --list
    else
        # softwareupdate --install --all --force
        softwareupdate --install --all --agree-to-license
    end
end
