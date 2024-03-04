function pip-reset -d 'Removes local Python packages, except the default ones'
    set default_requirements_path ~/.default-python-packages

    if set -q MISE_PYTHON_DEFAULT_PACKAGES_FILE
        set default_requirements_path "$MISE_PYTHON_DEFAULT_PACKAGES_FILE"
    else if set -q ASDF_PYTHON_DEFAULT_PACKAGES_FILE
        set default_requirements_path "$ASDF_PYTHON_DEFAULT_PACKAGES_FILE"
    end

    set pattern (string join '|' (cat "$default_requirements_path"))

    if test -z "$pattern"
        echo -s \
            (set_color yellow) \
            "no packages to remove" \
            (set_color normal)
        return 0
    end

    if command -q uv
        uv pip uninstall --system (
            uv pip freeze --system | grep --invert-match "$pattern"
        )
    else if command -q pip
        # pip itself is never included in freeze results
        pip uninstall -y (pip freeze | grep --invert-match "$pattern")
    else
        echo -s \
            (set_color $fish_color_error) \
            "error: no Python package installer found" \
            (set_color normal)
        return 1
    end
end
