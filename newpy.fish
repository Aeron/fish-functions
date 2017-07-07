begin
	set _default_python 'python3'
	set _default_readme 'README.md'
	set _default_requirements 'requirements.txt'
	set _default_activate './bin/activate.fish'
	set _package_regex '^[a-z]+$'
	set _gitignore '.gitignore'
	set _python_gitignore 'https://github.com/github/gitignore/raw/master/Python.gitignore'
	set _venv_gitignore '
		# venv
		bin/
		include/
		man/
		pyvenv.cfg
	'

	function newpy -a project package python -d "Helps to setup a new Python project and its venv"
		if test -n $project
			if test -n $project -a -d $project
				echo -n (set_color red) "Directory “$project” already exists" (set_color normal)
				exit 1
			end

			if test -z $package
				set package (string trim (string split '-' $project)[1])
			end

			if not string match -aq -r $_package_regex $package
				echo -n (set_color red) "Package name “$package” doesn’t comply with PEP8"
				exit 2
			end

			if test -n $project -a $project != '.'
				mkdir $project
				cd $project
			end

			touch $_default_readme $_default_requirements
			echo "# $package" >> $_default_readme

			curl -Lso $_gitignore $_python_gitignore

			mkdir $package
			touch $package/__init__.py

			if test -z $python
				set python $_default_python
			end

			set python (which $python)

			eval $python -m venv .
			source $_default_activate

			echo $_venv_gitignore >> $_gitignore

			git init .
			git add --all
			git commit -am 'Initial commit.'
		end
	end
end
