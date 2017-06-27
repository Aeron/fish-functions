function pip -d 'Handy wrapper for macOS/homebrew pip'
	set -l pip_version (command pip --version)
	set -l cmd

	switch $pip_version 
		case '* /Library*'
			set_color green
			echo "Using built-in $pip_version"
			set cmd "sudo -H command pip $argv"
		case '*'
			set_color yellow
			echo "Using another $pip_version"
			set cmd "command pip $argv"
	end

	set_color normal
	eval $cmd
end
