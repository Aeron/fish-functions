function brewup -d 'Shorthand for homebrew’s update, upgrade and cleanup with prune'
	brew update; and brew upgrade; and brew cleanup --prune
end
