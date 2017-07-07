begin
	set config_home '~/.config/fish'
	set config_functions (string join '/' $config_home 'functions')

	set config_main (string join '/' $config_home 'config.fish')
	set config_prompt (string join '/' $config_functions 'fish_prompt.fish')

	set EDITOR_DIRS (string replace w '' $EDITOR)

	function _config_edit
		eval $EDITOR $config_main
	end

	function _config_reload
		source $config_main
	end

	function _config_prompt
		eval $EDITOR $config_prompt
	end

	function _config_home
		eval $EDITOR_DIRS $config_home
	end

	function _config_functions
		eval $EDITOR_DIRS $config_functions
	end

	function config -a cmd -d 'Handly alias to manage fish config'
		if [ -z $cmd ]
			_config_home
		else
			eval _config_$cmd
		end
	end
end
