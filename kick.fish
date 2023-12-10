begin
	set python_gitignore 'https://github.com/github/gitignore/raw/main/Python.gitignore'
	set go_gitignore 'https://github.com/github/gitignore/raw/main/Go.gitignore'

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
			if functions -q venv
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

	function _init_git -a gitignore_url
		curl -Lso .gitignore $gitignore_url
		git init -q .
	end

    function _get_help
        echo "Usage:"
        echo "    kick [OPTS...] NAME [TARGET]"
        echo ""
        echo "Options:"
        echo "    --lang=python    Creates a Python project"
        echo "    --lang=go        Creates a Go project"
        echo "    --lang=rust      Creates a Rust project"
        echo ""
        echo "    --lib            Specifies the project is a library"
        echo ""
        echo "    --no-git         Ignores Git VCS initialization"
        echo "    --no-venv        Ignores Python virtual environment creation"
        echo ""
        echo "Parameters:"
        echo "    NAME             A project name [required]"
        echo "    TARGET           A target directory [default: '.']"
    end

	function kick -d "Kickstarts a new software development project"
		argparse --ignore-unknown 'h/help' 'l/lang=?' -- $argv

		if test $_flag_help; or test -z "$argv"
			echo -e \
				"kick (short for kickstart) help you start a new" \
				"software development project.\n"
			_get_help
			return 0
		end

		# HACK: `function -a <args>` does not quite work here
		# since all options goes to named params first
		set params (string match --invert -- '-*' $argv)
		set flags (string match -- '-*' $argv)

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

		set current_dir (basename (pwd))

		if test -z "$target" -o "$target" = '.'
			set target $current_dir
		end

		if test -z "$_flag_lang"
			read -P 'Choose a language [python|go|rust]: ' _flag_lang
		end

		if not contains $_flag_lang python go rust
			echo -s \
				(set_color $fish_color_error) \
				"error: no suitable language specified; must be python, go, or rust" \
				(set_color normal)
			return 1
		end

		if test "$target" != "$current_dir"
			if test -d $target -a -n "$(command ls -1qA)"
				echo -s \
					(set_color $fish_color_error) \
					"error: directory '$target' exists, and it is not empty" \
					(set_color normal)
				return 1
			end

			mkdir $target
			and cd $target
		end

		switch $_flag_lang
			case python; _create_python $name $flags
			case go; _create_go $name $flags
			case rust; _create_rust $name $flags
		end

		if test $status -ne 0
			cd ..
			# rm -rf $target
			return 1
		end

		echo "# $name" > README.md

		if not contains -- --no-git $argv; and test -d .git
			git add --all
		end
	end
end
