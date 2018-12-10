function venv -d 'Handy wrapper for `python3 -m venv`'
	if test -z "$argv"
		set argv ".venv"
	end

	command python3 -m venv $argv;
		and activate;
		and pip install -U pip setuptools wheel
end
