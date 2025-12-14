function brew-up -d 'Updates Homebrew, upgrades and cleans up packages'
    brew update --quiet
    and brew upgrade
    and brew upgrade --cask
    brew autoremove
    brew cleanup --prune=0
end
