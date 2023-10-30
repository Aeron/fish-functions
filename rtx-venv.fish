function rtx-venv -d "Configures a local RTX Python with a virtual environment"
    echo -ne '[tools]\npython = {version="latest", virtualenv=".venv"}' > .rtx.toml
end
