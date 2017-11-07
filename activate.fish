function activate -a quiet -d "Activates Python's venv for current directory"
	if test -e $VIRTUAL_ENV_DIR
		source (string join / $PWD $VIRTUAL_ENV_DIR 'bin/activate.fish')

		if test -z "$quiet"
			echo -s (set_color green) "Python's venv for $PWD activated" (set_color normal)
		end
	else
		if test -z "$quiet"
			echo (set_color red) "There's no venv found in current directory" (set_color normal)
		end
	end
end
