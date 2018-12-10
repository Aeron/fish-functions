begin
	set newpy_default_python 'python3'
	set newpy_default_readme 'README.md'
	set newpy_default_requirements 'requirements.txt'
	set newpy_default_activate './bin/activate.fish'

	set newpy_package_regex '^[a-z]+$'
	set newpy_gitignore '.gitignore'
	set newpy_python_gitignore 'https://github.com/github/gitignore/raw/master/Python.gitignore'
	set newpy_git_initial 'Initial commit.'

	function _newpy_create_venv -a python
		if test -z "$python"
			set python $newpy_default_python
		end

		set python (which $python)

		if functions -q venv
			venv
		else
			eval $python -m venv .venv
			source $newpy_default_activate
			pip install -U pip setuptools wheel
		end
	end

	function _newpy_create_git
		git init -q .
		git add --all
		git commit -qam $newpy_git_initial

		if command -s git-flow
			git flow init -d
		end
	end

	function newpy -a project package python -d "Helps to setup a new Python project, its venv and Git repo"
		if test -z "$project" -o "$project" = '.'
			set project (basename (pwd))
		else
			if test -d $project
				echo -s (set_color $fish_color_error) "Directory '$project' already exists" (set_color normal)
				return 1
			end
		end

		if test -z "$package"
			set package (string trim (string split '-' "$project")[1])
		end

		if not string match -aq -r $newpy_package_regex "$package"
			echo -s (set_color $fish_color_error) "Package name '$package' doesn't comply with PEP8" (set_color normal)
			return 1
		end

		if test "$project" != (pwd)
			mkdir $project
			cd $project
		end

		touch $newpy_default_readme $newpy_default_requirements
		echo "# $package" >> $newpy_default_readme

		curl -Lso $newpy_gitignore $newpy_python_gitignore

		mkdir $package
		echo '__version__ = "0.0.0"' > $package/__init__.py

		if not contains -- --no-venv $argv
			_newpy_create_venv $python
		end

		if not contains -- --no-git $argv
			_newpy_create_git
		end
	end
end
