function brew-up -d 'Updates Homebrew, upgrades and cleans up packages'
	brew update &> /dev/null
	and brew upgrade
	and brew upgrade --cask

	set leftovers (brew leaves --installed-as-dependency --quiet)

	if count $leftovers
		brew rm $leftovers
	end

	brew cleanup --prune=0
end
