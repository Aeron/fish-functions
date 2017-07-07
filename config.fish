begin
	set _home '~/.config/fish'
	set _functions (string join '/' $_home 'functions')

	set _config (string join '/' $_home 'config.fish')
	set _prompt (string join '/' $_functions 'fish_prompt.fish')

	set EDITOR_DIRS (string replace w '' $EDITOR)

	function __config_edit
		eval $EDITOR $_config
	end

	function __config_reload
		source $_config
	end

	function __config_prompt
		eval $EDITOR $_prompt
	end

	function __config_home
		eval $EDITOR_DIRS $_home
	end

	function __config_functions
		eval $EDITOR_DIRS $_functions
	end

	function config -a cmd -d 'Handly alias to manage fish config'
		if [ -z $cmd ]
			__config_home
		else
			eval __config_$cmd
		end
	end
end
