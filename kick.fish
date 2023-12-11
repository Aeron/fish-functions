begin
    set languages python go rust zig

    set python_gitignore 'https://github.com/github/gitignore/raw/main/Python.gitignore'
    set go_gitignore 'https://github.com/github/gitignore/raw/main/Go.gitignore'
    set zig_gitignore 'https://github.com/ziglang/zig/raw/master/.gitignore'

    function _create_python -a name
        if contains -- --lib $argv
            set package (string trim (string replace '-' '_' "$name"))

            if not string match -aq -r '^[a-z_]+$' "$package"
                echo -s \
                    (set_color $fish_color_error) \
                    "$package does not comply with package naming" \
                    (set_color normal)
                return 1
            end

            set package "src/$package"
        else
            set package 'app'
        end

        touch pyproject.toml requirements.txt

        mkdir -p $package
        echo -e '__version__ = "0.0.0"\n' > $package/__init__.py

        mkdir tests
        touch tests/__init__.py

        if not contains -- --no-venv $argv
            if functions -q rtx-venv
                rtx-venv
            else if functions -q venv
                venv
            else
                command python3 -m venv .venv
                source .venv/bin/activate.fish
                pip install -U pip setuptools wheel
            end
        end

        if not contains -- --no-git $argv
            _init_git $python_gitignore
        end
    end

    function _create_go -a name
        # https://github.com/golang-standards/project-layout
        if contains -- --lib $argv
            set package pkg
        else
            set package internal
        end

        go mod init $name

        mkdir -p $package
        echo "package main" > $package/main.go

        if not contains -- --no-git $argv
            _init_git $go_gitignore
        end
    end

    function _create_rust -a name
        set opts "--name $name"

        if contains -- --lib $argv
            set -a opts '--lib'
        else
            set -a opts '--bin'
        end

        if contains -- --no-git $argv
            set -a opts '--vcs none'
        end

        command cargo init $opts .
    end

    function _create_zig -a name
        set cmd 'init-exe'

        if contains -- --lib $argv
            set cmd 'init-lib'
        else

        echo -se \
            '.{\n' \
            "    .name = \"$name\",\n" \
            '    .version = "0.0.0",\n' \
            '    .dependencies = .{},\n' \
            '}\n' \
        > build.zig.zon

        if not contains -- --no-git $argv
            _init_git $zig_gitignore
        end

        command zig $cmd
    end

    function _init_git -a gitignore_url
        curl -Lso .gitignore $gitignore_url
        git init -q .
    end

    function _get_help
        echo 'Usage:'
        echo '    kick [OPTS...] NAME [TARGET]'
        echo ''
        echo 'Options:'
        echo '    --lang=python    Creates a Python project [default]'
        echo '    --lang=go        Creates a Go project'
        echo '    --lang=rust      Creates a Rust project'
        echo '    --lang=zig       Creates a Zig project'
        echo ''
        echo '    --lib            Specifies the project is a library'
        echo ''
        echo '    --no-git         Ignores Git VCS initialization'
        echo '    --no-venv        Ignores Python virtual environment creation'
        echo ''
        echo 'Parameters:'
        echo '    NAME             A project name [required]'
        echo '    TARGET           A target directory [default: "."]'
    end

    function kick -d "Kickstarts a new software development project"
        set -l options
        set options $options (fish_opt -s h -l help)
        set options $options (fish_opt -s l -l lang --optional-val)
        set options $options (fish_opt -s L -l lib --long-only)
        set options $options (fish_opt -s G -l no-git --long-only)
        set options $options (fish_opt -s V -l no-venv --long-only)

        argparse --ignore-unknown $options -- $argv

        if test $_flag_help; or test -z "$argv"
            echo -e \
                "$_ (short for kickstart) help you start a new" \
                "software development project.\n"
            _get_help
            return 0
        end

        if test -z "$_flag_lang"
            set _flag_lang $languages[1]
            # read -P 'Choose a language [python|go|rust]: ' _flag_lang
        end

        if not contains "$_flag_lang" $languages
            echo -s \
                (set_color $fish_color_error) \
                'error: no suitable language specified; must be one of these: ' \
                (string join ', ' $languages) \
                (set_color normal)
            return 1
        end

        # HACK: `function -a <args>` does not quite work here
        # since all options goes to named params first
        set params (string match --invert -- '-*' $argv)
        set name $params[1]
        set target $params[2]

        if test -z "$name"
            echo -s \
                (set_color $fish_color_error) \
                "error: name is a required argument" \
                (set_color normal)
            _get_help
            return 1
        end

        set target (path resolve "$target") # TODO: error handling maybe?

        if test (ls -1A "$target" 2> /dev/null | wc -l | string trim) -gt 0
            read -lun1 -P 'directory is not empty; continue anyway? [y|N] ' answer
            if test "$answer" != 'y'
                return 0
            end
        else if test "$target" != "$PWD"
            mkdir -p $target
            and cd $target
        end

        set flags $_flag_lib $_flag_no_git $_flag_no_venv

        switch "$_flag_lang"
            case python
                _create_python $name $flags
            case go
                _create_go $name $flags
            case rust
                _create_rust $name $flags
            case zig
                _create_zig $name $flags
        end

        if test $status -ne 0
            cd ..
            # rm -rf $target
            return 1
        end

        echo "# $name" > README.md

        if test -z "$_flag_no_git"; and test -d .git
            git add --all
        end
    end
end
