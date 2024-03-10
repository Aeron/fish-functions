begin
    set languages 'python' 'go' 'rust' 'zig'

    set python_gitignore 'https://github.com/github/gitignore/raw/main/Python.gitignore'
    set go_gitignore 'https://github.com/github/gitignore/raw/main/Go.gitignore'
    set zig_gitignore 'https://github.com/ziglang/zig/raw/master/.gitignore'

    set default_name 'unnamed'

    function _create_python -a name
        set package 'app'

        if contains -- '--lib' $argv
            set package (string trim (string replace '-' '_' "$name"))

            if not string match -aq -r '^[a-z_]+$' "$package"
                echo -s \
                    (set_color $fish_color_error) \
                    "$package does not comply with package naming" \
                    (set_color normal)
                return 1
            end

            # TODO: do we really believe in the src layout?
            # Yes, Hynek, but also common sense. One needs to (un)intentionally
            # design a library the way it’d behave differently as an installed
            # package. So, it’s either a very special choice or an error.
            set package "src/$package"
        end

        touch pyproject.toml requirements.txt

        mkdir -p $package
        echo -e '__version__ = "0.0.0"\n' > $package/__init__.py

        mkdir tests
        touch tests/__init__.py

        if not contains -- '--no-venv' $argv
            if functions -q mise-venv
                mise-venv
            else if functions -q venv
                venv
            else
                command python3 -m venv .venv
                and source .venv/bin/activate.fish
                and if command -q pip
                    pip install -U pip
                end
            end
        end

        echo "# $name" > README.md

        if not contains -- '--no-git' $argv
            _init_git $python_gitignore
        end
    end

    function _create_go -a name
        # Yeah, there is https://github.com/golang-standards/project-layout, but as
        # Russ Cox (tech lead of the Go language project) explained in a relevant issue,
        # there are no exact standards for a layout.
        # See https://github.com/golang-standards/project-layout/issues/117#issuecomment-828503689.
        # Also, https://go.googlesource.com/example/.
        set package 'app'

        if contains -- '--lib' $argv
            set package (string trim (string replace '-' '_' "$name"))
        end

        go mod init $name

        mkdir -p $package
        echo "package main" > $package/main.go

        echo "# $name" > README.md

        if not contains -- '--no-git' $argv
            _init_git $go_gitignore
        end
    end

    function _create_rust -a name
        set opts "--name=$name"

        if contains -- '--lib' $argv
            set -a opts '--lib'
        else
            set -a opts '--bin'
        end

        if contains -- '--no-git' $argv
            set -a opts '--vcs none'
        end

        command cargo init $opts .
    end

    function _create_zig -a name
        set cmd 'init-exe'

        if contains -- '--lib' $argv
            set cmd 'init-lib'
        end

        echo -se \
            '.{\n' \
            "    .name = \"$name\",\n" \
            '    .version = "0.0.0",\n' \
            '    .dependencies = .{},\n' \
            '}\n' \
        > build.zig.zon

        command zig $cmd

        if not contains -- '--no-git' $argv
            _init_git $zig_gitignore
        end
    end

    function _init_git -a gitignore_url
        curl -Lso .gitignore $gitignore_url
        git init -q .
    end

    function kick -d 'Kickstarts a new software development project'
        set -l opts (fish_opt -s h -l help)
        set -a opts (fish_opt -s L -l lang --long-only --optional-val)
        set -a opts (fish_opt -s n -l name --required-val)
        set -a opts (fish_opt -s l -l lib)
        set -a opts (fish_opt -s G -l no-git)
        set -a opts (fish_opt -s R -l no-readme)
        set -a opts (fish_opt -s V -l no-venv)

        argparse --ignore-unknown --stop-nonopt $opts -- $argv
        or return

        if test -n "$_flag_help"
            echo 'Kickstart a new software development project.'
            echo ''
            echo "Usage: $_ [OPTS...] [TARGET]"
            echo ''
            echo 'Options:'
            echo '  --lang=python      Creates a Python project [default]'
            echo '  --lang=go          Creates a Go project'
            echo '  --lang=rust        Creates a Rust project'
            echo '  --lang=zig         Creates a Zig project'
            echo ''
            echo '  -n, --name <NAME>  Specifies the project name [default: "unnamed"]'
            echo '  -l, --lib          Specifies the project is a library'
            echo '  -G, --no-git       Omits Git VCS initialization'
            echo '  -R, --no-readme    Omits README.md creation'
            echo ''
            echo 'Python Options:'
            echo '  -V, --no-venv      Ignores Python virtual environment creation'
            echo ''
            echo 'Parameters:'
            echo '  TARGET             A target directory [default: "."]'
            return
        end

        set lang $languages[1]

        if test -n "$_flag_lang"
            set lang (string trim "$_flag_lang")
        end

        if not contains "$lang" $languages
            echo -s \
                (set_color $fish_color_error) \
                'error: invalid language name; must be either ' \
                (string join ', ' $languages) \
                (set_color normal)
            return 1
        end

        set target '.'

        if test -z "$argv[1]"
            set target "$argv[1]"
        end

        set target (path resolve "$target") # TODO: error handling maybe?

        if test "$target" != "$PWD"
            mkdir -p $target
            and cd $target
        end

        if test (ls -1A 2> /dev/null | wc -l | string trim) -gt 0
            read -lun1 -P 'directory is not empty; continue anyway? [y|N] ' answer
            if test "$answer" != 'y'
                return 0
            end
        end

        set name "$default_name"

        if test -n "$_flag_name"
            set name "$_flag_name"
        end

        switch "$lang"
            case 'python'
                _create_python $name $_flag_lib $_flag_no_git $_flag_no_venv
            case 'go'
                _create_go $name $_flag_lib $_flag_no_git
            case 'rust'
                _create_rust $name $_flag_lib $_flag_no_git
            case 'zig'
                _create_zig $name $_flag_lib $_flag_no_git
        end

        if test $status -ne 0
            echo -s \
                (set_color $fish_color_error) \
                'error: something went wrong' \
                (set_color normal)

            if test "$PWD" = "$target"
                cd ..
            end

            if test -d "$target"
                echo -s \
                    (set_color yellow) \
                    "consider removing $target" \
                    (set_color normal)
                # rm -rf $target
            end

            return 1
        end

        if test -z "$_flag_no_readme"
            echo "# $name" > README.md
        end

        if test -z "$_flag_no_git" -a -d .git
            git add --all
        end
    end
end
