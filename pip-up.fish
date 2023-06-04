function pip-up -d "Updates local Python packages"
    set default_requirements_path

    if set -q ASDF_PYTHON_DEFAULT_PACKAGES_FILE
        set default_requirements_path $ASDF_PYTHON_DEFAULT_PACKAGES_FILE
    else if test -e ~/.default-python-packages
        set default_requirements_path ~/.default-python-packages
    else
        set default_requirements_path ~/.requirements.txt
    end

    if test -n $VIRTUAL_ENV
        echo -s (set_color $fish_color_error) "error: venv is active" (set_color normal)
        return 1
    end

    command pip install -U pip wheel setuptools

    if test -n $default_requirements_path
        command pip install -Ur $default_requirements_path
    else
        echo -s (set_color yellow) "$default_requirements_path not found" (set_color normal)
    end

    command pip cache purge -qqq
end
