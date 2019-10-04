function activate -d "Activates Python's venv for current directory"
	if test -e $VIRTUAL_ENV_DIR
		source (string join / $PWD $VIRTUAL_ENV_DIR 'bin/activate.fish')

		if contains -- -v $argv
			echo -s (set_color green) "Python's venv for $PWD activated" (set_color normal)
		end
	else
		if contains -- -v $argv
			echo (set_color red) "There's no venv found in current directory" (set_color normal)
		end
	end
end
