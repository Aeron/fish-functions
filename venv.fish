function venv -d 'Handy wrapper for `python3 -m venv`'
	if [ -z "$argv" ]
		set argv ".venv"
	end

	command python3 -m venv $argv
end
