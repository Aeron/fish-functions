function __config_edit
	eval $EDITOR ~/.config/fish/config.fish
end

function __config_reload
	source ~/.config/fish/config.fish
end

function __config_prompt
	eval $EDITOR ~/.config/fish/functions/fish_prompt.fish
end

function config -a cmd -d 'Handly alias to manage fish config'
	eval __config_$cmd
end
