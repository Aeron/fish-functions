function mise-venv \
    -d "Configures a local mise-en-place (former rtx) Python with a virtual environment"

    if test -e .rtx.toml
        echo -s \
            (set_color $fish_color_error) \
            'File .rtx.toml already exists; Better to edit it manually' \
            (set_color normal)
        return
    end

    echo -ne '[tools]\npython = {version="latest", virtualenv=".venv"}\n' > .rtx.toml
end
