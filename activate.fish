function activate -a quiet -d "Activates Python's venv for current directory"
	set default_path 'bin/activate.fish'
	set full_path (string join / $PWD $default_path)

	if test -e $full_path
		source $full_path

		if test -z "$quiet"
			echo -s (set_color green) "Python's venv for $PWD activated" (set_color normal)
		end
	else
		if test -z "$quiet"
			echo (set_color red) "There's no venv found in current directory" (set_color normal)
		end
	end
end
