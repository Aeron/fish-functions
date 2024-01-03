function mise-venv \
    -d 'Configures a local mise-en-place (former rtx) Python with a virtual environment'

    if test -e .mise.toml
        echo -s \
            (set_color $fish_color_error) \
            'File .mise.toml already exists; Better to edit it manually' \
            (set_color normal)
        return
    end

    echo -ne '[tools]\npython = {version="latest", virtualenv=".venv"}\n' > .mise.toml
end
