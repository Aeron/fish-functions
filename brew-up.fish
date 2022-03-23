function brew-up -d 'Updates Homebrew, upgrades and cleans up packages'
	brew update &> /dev/null
	and brew outdated
	and brew upgrade
	and brew upgrade --cask
	and brew rm (brew leaves --installed-as-dependency --quiet)
	and brew cleanup --prune=0
end
