begin
	if test -z $VIRTUAL_ENV_DIR
		set default_dir ".venv"
	else
		set default_dir $VIRTUAL_ENV_DIR
	end

	function _remove_venv
		if test -d $default_dir
			rm -rf $default_dir
		else
			echo -s \
				(set_color yellow) \
				"No venv ($default_dir directory) found" \
				(set_color normal)
		end
	end

	function _create_venv
		command python3 -m venv $default_dir
		and activate -v
		and pip install -U pip setuptools wheel
	end

	function _reset_venv
		_remove_venv
		_create_venv
	end

	function venv -d 'Handy wrapper for `python3 -m venv`'
		if contains -- --rm $argv
			_remove_venv
		else
			if contains -- --reset $argv
				_reset_venv
			else
				_create_venv
			end

			# if contains -- --install-requirements $argv
			# 	pip install -r ./requirements.txt
			# end
		end
	end
end
