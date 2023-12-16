function activate -d 'Activates Python virtual environment in CWD'
    set default_dir $VIRTUAL_ENV_DIR

    if test -z "$default_dir"
        set default_dir ".venv"
    end

    if test -d "$default_dir"
        set script_path "$PWD/$default_dir/bin/activate.fish"

        if test -e "$script_path"
            source "$script_path"

            if contains -- -v $argv
                echo -s (set_color $fish_color_cwd) \
                    "Python's venv for $PWD activated" \
                    (set_color normal)
            end
        else
            echo (set_color $fish_color_error) \
                "error: activation script $script_path not found" \
                (set_color normal)
        end
    else
        if contains -- -v $argv
            echo (set_color $fish_color_error) \
                "error: no venv found in current directory" \
                (set_color normal)
        end
    end
end
