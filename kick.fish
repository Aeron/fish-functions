begin
    set languages python go rust zig

    set python_gitignore 'https://github.com/github/gitignore/raw/main/Python.gitignore'
    set go_gitignore 'https://github.com/github/gitignore/raw/main/Go.gitignore'
    set zig_gitignore 'https://github.com/ziglang/zig/raw/master/.gitignore'

    set default_name unnamed

    function _create_python -a name
        if not command -q uv
            echo -s \
                (set_color $fish_color_error) \
                'uv was not found in $PATH' \
                (set_color normal)
            return 1
        end

        set package app
        set opts "--name=$name" --no-pin-python
        set target .

        if contains -- --lib $argv
            # TODO: do we really believe in the src+package layout?
            # Yes, Hynek, but also common sense. One needs to (un)intentionally
            # design a library the way it’d behave differently as an installed
            # package. So, it’s either a very specific choice or a developer’s error.
            set -a opts --lib
        else if contains -- --script $argv
            set -a opts --script
            set target $package.py
        else
            set -a opts --app
        end

        if contains -- --no-git $argv
            set -a opts '--vcs=none'
        else
            set -a opts '--vcs=git'

            if not contains -- --no-jj $argv
                _init_jj
            end
        end

        if contains -- --no-readme $argv
            set -a opts --no-readme
        end

        command uv init $opts $target

        if test -f main.py
            # NOTE: there’s no way we’re leaving the main code in the root directory
            mkdir -p $package
            mv main.py $package/main.py
            touch $package/__init__.py
        end

        if not contains -- --no-tests $argv
            mkdir tests
            touch tests/__init__.py tests/conftest.py
            command uv add pytest
        end

        if not contains -- --no-venv $argv
            if functions -q mise-venv
                mise-venv
            else if command -q uv
                command uv venv
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
    end

    function _create_go -a name
        if not command -q go
            echo -s \
                (set_color $fish_color_error) \
                'go was not found in $PATH' \
                (set_color normal)
            return 1
        end

        # Yeah, there is https://github.com/golang-standards/project-layout, but as
        # Russ Cox (tech lead of the Go language project) explained in a relevant issue,
        # there are no exact standards for a Go project layout.
        # See https://github.com/golang-standards/project-layout/issues/117#issuecomment-828503689.
        # Also, https://go.googlesource.com/example/.
        set package app

        if contains -- --lib $argv
            set package (string trim "$name")
        end

        command go mod init $name

        mkdir -p $package
        echo "package main" > $package/main.go

        echo "# $name" > README.md

        if not contains -- --no-git $argv
            _init_git $go_gitignore

            if not contains -- --no-jj $argv
                _init_jj
            end
        end
    end

    function _create_rust -a name
        if not command -q cargo
            echo -s \
                (set_color $fish_color_error) \
                'cargo was not found in $PATH' \
                (set_color normal)
            return 1
        end

        set opts "--name=$name"

        if contains -- --lib $argv
            set -a opts --lib
        else
            set -a opts --bin
        end

        if contains -- --no-git $argv
            set -a opts '--vcs=none'
        else if not contains -- --no-jj $argv
            _init_jj
        end

        command cargo init $opts .
    end

    function _create_zig -a name
        if not command -q zig
            echo -s \
                (set_color $fish_color_error) \
                'zig was not found in $PATH' \
                (set_color normal)
            return 1
        end

        set cmd init-exe

        if contains -- --lib $argv
            set cmd init-lib
        end

        echo -se \
            '.{\n' \
            "    .name = \"$name\",\n" \
            '    .version = "0.0.0",\n' \
            '    .dependencies = .{},\n' \
            '}\n' \
        > build.zig.zon

        command zig $cmd

        if not contains -- --no-git $argv
            _init_git $zig_gitignore

            if not contains -- --no-jj $argv
                _init_jj
            end
        end
    end

    function _init_git -a gitignore_url
        if not command -q git
            echo -s \
                (set_color $fish_color_error) \
                'git was not found in $PATH' \
                (set_color normal)
            return 1
        end

        command curl -Lso .gitignore $gitignore_url
        command git init -q .
    end

    function _init_jj
        if not command -q jj
            echo -s \
                (set_color $fish_color_error) \
                'jj was not found in $PATH' \
                (set_color normal)
            return 1
        end

        command jj git init --colocate
    end

    function kick -d 'Kickstarts a new software development project'
        set -l opts (fish_opt -s h -l help)
        set -a opts (fish_opt -s L -l lang --long-only --optional-val)
        set -a opts (fish_opt -s n -l name --long-only --required-val)
        set -a opts (fish_opt -s l -l lib --long-only)
        set -a opts (fish_opt -s G -l no-git --long-only)
        set -a opts (fish_opt -s J -l no-jj --long-only)
        set -a opts (fish_opt -s R -l no-readme --long-only)
        set -a opts (fish_opt -s V -l no-venv --long-only)
        set -a opts (fish_opt -s T -l no-tests --long-only)
        set -a opts (fish_opt -s S -l script --long-only)

        argparse --ignore-unknown --stop-nonopt $opts -- $argv
        or return

        if test -n "$_flag_help"
            echo 'Kickstart a new software development project.'
            echo ''
            echo "Usage: $_ [OPTS...] [TARGET]"
            echo ''
            echo 'Options:'
            echo '  --lang=python  Creates a Python project [default]'
            echo '  --lang=go      Creates a Go project'
            echo '  --lang=rust    Creates a Rust project'
            echo '  --lang=zig     Creates a Zig project'
            echo ''
            echo '  --name=<NAME>  Specifies the project name [default: "unnamed"]'
            echo '  --lib          Specifies the project is a library'
            echo '  --no-git       Omits Git VCS initialization'
            echo '  --no-jj        Omits Jujutsu (colocate) initialization'
            echo '  --no-readme    Omits README.md creation'
            echo ''
            echo 'Python Options:'
            echo '  --no-venv      Omits Python virtual environment creation'
            echo '  --no-tests     Omits tests directory creation'
            echo '  --script       Specifies a single file project structure'
            echo ''
            echo 'Parameters:'
            echo '  TARGET         A target directory [default: "."]'
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

        if test -n "$argv[1]"
            set target "$argv[1]"
        end

        set target (path resolve "$target")

        if test "$target" != "$PWD"
            echo "Creating $target"
            mkdir -p $target
            and cd $target
        end

        if test (ls -1A 2> /dev/null | wc -l | string trim) -gt 0
            read -lun1 -P 'directory is not empty; continue anyway? [y|N] ' answer
            if test "$answer" != y
                return 0
            end
        end

        set name "$default_name"

        if test -n "$_flag_name"
            set name "$_flag_name"
        end

        set params $name $_flag_lib $_flag_no_git $_flag_no_jj $_flag_no_readme

        switch "$lang"
            case python
                _create_python $params $_flag_no_venv $_flag_no_tests $_flag_script
            case go
                _create_go $params
            case rust
                _create_rust $params
            case zig
                _create_zig $params
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
