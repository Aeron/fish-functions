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
                "$default_dir not found" \
                (set_color normal)
        end
    end

    function _create_venv
        command python3 -m venv (_get_default_dir)

        if functions -q activate
            activate -v
            and if command -q pip
                pip install -U pip
            end
        end
    end

    function venv -d 'Handy wrapper for `python3 -m venv`'
        if contains -- --rm $argv
            _remove_venv
        else if contains -- --reset $argv
            _remove_venv
            and _create_venv
        else
            _create_venv
        end
    end
end
