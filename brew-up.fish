function brew-up -d 'Updates Homebrew, upgrades and cleans up packages'
	brew update
	and brew upgrade
    and brew upgrade --cask
	and brew cleanup --prune=0
end
