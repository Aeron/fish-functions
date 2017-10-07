function brew-up -d 'Shorthand for Homebrew’s update, upgrade and cleanup with prune'
	brew update; and brew upgrade; and brew cleanup --prune
end
