function mise-venv \
    -d 'Configures a virtual environment via mise-en-place (former rtx)'

    if test -e .mise.toml
        echo -s \
            (set_color $fish_color_error) \
            'File .mise.toml already exists; Better to edit it manually' \
            (set_color normal)
        return
    end

    # See https://github.com/jdx/mise/blob/main/docs/lang/python.md#automatic-virtualenv-activation
    echo -se \
        '[tools]\n' \
        'python = "latest"\n\n' \
        '[env._.python.venv]\n' \
        'path = ".venv"\n' \
        'create = true\n' \
    > .mise.toml

    command mise trust --quiet
end
