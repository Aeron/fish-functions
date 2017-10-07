# Fish Functions
Just a repo with my functions (mostly just to test and play) for [Fish](http://fishshell.com) shell.

## Fish theme
`fish_prompt.fish` is a theme I currently use. Inspired by [Kenneth Reitz](https://github.com/kennethreitz)’ original theme for [Oh-my-ZSH](https://github.com/robbyrussell/oh-my-zsh).

![Terminal with Fish](https://user-images.githubusercontent.com/278423/27943158-783e5b80-62e5-11e7-863b-053dd9d897ab.png)

## Functions

### > activate
Activates Python's venv for current directory. Shorthand for `source ./bin/activate.fish`.

Usage: `activate [--quiet]`

### > brew-up
Shorthand for Homebrew’s `update`, `upgrade` and `cleanup --prune`.

Usage: `brew-up`

### > cal
Handy wrapper to colorize current date in `cal`. Arguments usage will reset layout to normal.

Usage: `cal [<arguments>]`

### > curl-time
Measures time for performed CURL request.

Usage: `curl-time <url>`

### > docker-reset
Stops all containers, removes them and all images.

Usage: `docker-reset`

### > fish-config
Provides short way to reload/edit config file or its home/functions folder, or edit prompt function.

Usage: `fish-config [edit | reload | prompt | home | functions]`

### > flushdns
Flushes macOS's DNS cache.

Usage: `flushdns`

### > ip-up-add
Easier way to add a subnetwork in `/etc/ppp/ip-up`. Usable for selective VPN traffic.

Usage: `ip-up-add <subnetwork> [<comment>]`

### > newpy
Helps to setup a new Python project, its venv and Git repo.

Usage: `newpy [<project> [<package> [<python>]]] [--no-venv] [--no-git]`

### > notify
Displays macOS notification.

Usage: `notify <message> [<title> [<subtitle>]]`

### > pip
Simple wrapper to track which version of PIP is used. Also helps with `sudo`.

Usage: `pip [<whatever>]`

### > pyclean
Cleans folder's Python cache and pre-compiled modules recursively.

Usage: `pyclean`

### > smtp
Runs local Python’s SMTP ``DebuggingServer``.

Usage: `smtp [<port>]`

### > source-posix
Exports variables from POSIX-compatible environment file.

Usage: `source-posix <file.env>`

### > tztime
Displays current time in given timezones, e.g. `US/Pacific`, `UTC`, `Asia/Bangkok` and etc. See `/usr/share/zoneinfo/` for more.

Usage: `tztime <timezones>`

### > unlock
Disables macOS's Gatekeeper check for certain application.

Usage: `unlock <path>`

### > venv
Simple wrapper for Python’s `venv` module.

Usage: `venv <arguments>`

### > vpn
Faster way to handle existing PPTP/L2TP connections in macOS. Not so usable for L2TP, because of a shared key.

Usage: `vpn [list | start <connection> | stop <connection> | switch <connection>]`
