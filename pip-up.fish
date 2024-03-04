function pip-up -d "Updates local Python packages"
    set default_requirements_path ~/.default-python-packages

    if set -q MISE_PYTHON_DEFAULT_PACKAGES_FILE
        set default_requirements_path "$MISE_PYTHON_DEFAULT_PACKAGES_FILE"
    else if set -q ASDF_PYTHON_DEFAULT_PACKAGES_FILE
        set default_requirements_path "$ASDF_PYTHON_DEFAULT_PACKAGES_FILE"
    end

    if test -n "$VIRTUAL_ENV"
        echo -s \
            (set_color $fish_color_error) \
            "error: venv is active" \
            (set_color normal)
        return 1
    end

    if not test -e "$default_requirements_path"
        echo -s \
            (set_color yellow) \
            "$default_requirements_path not found" \
            (set_color normal)
        retrun 0
    end

    if command -q uv
        uv pip install --system -Ur "$default_requirements_path"
    else if command -q pip
        pip install -Ur "$default_requirements_path"
        and pip cache purge -qqq
    else
        echo -s \
            (set_color $fish_color_error) \
            "error: no Python package installer found" \
            (set_color normal)
        return 1
    end
end
