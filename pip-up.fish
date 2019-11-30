function pip-up -d "Update local Python packages"
    set default_requirements_path ~/.requirements.txt

    command pip install -U pip wheel setuptools

    if test -e $default_requirements_path
        command pip install -Ur $default_requirements_path
    else
        echo -s (set_color yellow) "$default_requirements_path not found" (set_color normal)
    end
end
