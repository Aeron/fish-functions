function venv -d 'Handy wrapper for `python3.6 -m venv`'
	command python3.6 -m venv $argv
end

function activate -a quiet -d "Activates Python's venv for current directory"
	set -l default_path 'bin/activate.fish'
	set -l full_path (string join / $PWD $default_path)

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

function _auto_venv -v PWD -d 'Automates Python’s venv (event listner)'
	if functions -q deactivate
		deactivate
	end

	if set -qg VIRTUAL_ENV_AUTO -a functions -q activate
		activate --quiet
	end
end
