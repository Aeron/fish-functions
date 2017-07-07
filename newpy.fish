begin
	set _default_python 'python3'
	set _default_readme 'README.md'
	set _default_requirements 'requirements.txt'
	set _default_activate './bin/activate.fish'

	set _package_regex '^[a-z]+$'
	set _gitignore '.gitignore'
	set _python_gitignore 'https://github.com/github/gitignore/raw/master/Python.gitignore'
	set _venv_gitignore 'bin/' 'include/' 'man/' 'pyvenv.cfg'
	set _git_initial 'Initial commit.'

	function __create_venv -a python
		if test -z "$python"
			set python $_default_python
		end

		set python (which $python)

		eval $python -m venv .
		source $_default_activate

		echo -e '\n# venv' >> $_gitignore
		echo -e (string join '\n' $_venv_gitignore) >> $_gitignore
	end

	function __create_git
		git init -q .
		git add --all
		git commit -qam $_git_initial
	end

	function newpy -a project package python no_venv no_git -d "Helps to setup a new Python project and its venv"
		if test -z "$project" -o "$project" = '.'
			set project (basename (pwd))
		else
			if test -d $project
				echo -n (set_color $fish_color_error) "Directory '$project' already exists" (set_color normal)
				exit 1
			end
		end

		if test -z "$package"
			set package (string trim (string split '-' "$project")[1])
		end

		if not string match -aq -r $_package_regex "$package"
			echo -n (set_color $fish_color_error) "Package name '$package' doesn't comply with PEP8" (set_color normal)
			exit 2
		end

		if test "$project" != (pwd)
			mkdir $project
			cd $project
		end

		touch $_default_readme $_default_requirements
		echo "# $package" >> $_default_readme

		curl -Lso $_gitignore $_python_gitignore

		mkdir $package
		touch $package/__init__.py

		if test -z "$no_venv"
			__create_venv
		end

		if test -z "$no_git"
			__create_git
		end
	end
end
