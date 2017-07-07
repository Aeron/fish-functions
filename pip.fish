function pip -d 'Handy wrapper for macOS/Homebrew pip'
	set pip_version (command pip --version)
	set cmd

	switch $pip_version 
		case '* /Library*'
			echo -s (set_color green) "Using built-in $pip_version"
			set cmd "sudo -H command pip $argv"
		case '*'
			echo -s (set_color yellow) "Using another $pip_version"
			set cmd "command pip $argv"
	end

	set_color normal
	eval $cmd
end
