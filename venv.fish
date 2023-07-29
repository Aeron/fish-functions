begin
	function _get_default_dir
		set default_dir $VIRTUAL_ENV_DIR

		if test -z "$default_dir"
			set default_dir ".venv"
		end

		echo $default_dir
	end

	function _remove_venv
		set default_dir (_get_default_dir)

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
		command python3 -m venv (_get_default_dir)
		and activate -v
		and pip install -U pip setuptools wheel
	end

	function _reset_venv
		_remove_venv
		_create_venv
	end

	function _upgrade_venv
		if functions -q deactivate
			deactivate
		end

		command python3 -m venv --upgrade (_get_default_dir)
		and activate --quiet
	end

	function venv -d 'Handy wrapper for `python3 -m venv`'
		if contains -- --rm $argv
			_remove_venv
		else if contains -- --reset $argv
			_reset_venv
		else if contains -- --upgrade $argv
			_upgrade_venv
		else
			_create_venv
		end
	end
end
