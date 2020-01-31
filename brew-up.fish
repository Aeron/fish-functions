function brew-up -d 'Handy alias for Homebrew’s update, upgrade, and cleanup with prune'
	brew update
	and brew upgrade
	and brew cask upgrade
	and brew cleanup --prune=0
end
