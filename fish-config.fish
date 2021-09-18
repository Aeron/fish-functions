function fish-config -a cmd -d 'Handy alias to manage a fish config'
	# set config_home '~/.config/fish'
	set config_home $__fish_config_dir
	set EDITOR_ALT (string replace -r '\-?w' '' $EDITOR)

	switch "$cmd"
		case 'edit'
			eval $EDITOR $config_home/config.fish
		case 'reload'
			eval source $config_home/config.fish
		case 'prompt'
			eval $EDITOR $config_home/functions/fish_prompt.fish
		case 'functions'
			eval $EDITOR_ALT $config_home/functions
		case 'home' '*'
			eval $EDITOR_ALT $config_home
	end
end
