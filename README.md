# Fish Functions
Just a repo with my functions (to test and play usually) for [Fish](http://fishshell.com) shell.

## Fish theme
`fish_prompt.fish` is a theme I currently use. Based on [Kenneth Reitz](https://github.com/kennethreitz)’ original theme for [Oh-my-ZSH](https://github.com/robbyrussell/oh-my-zsh).

![Terminal with Fish](https://user-images.githubusercontent.com/278423/27943158-783e5b80-62e5-11e7-863b-053dd9d897ab.png)

## Functions

### > brewup
Shorthand for Homebrew’s `update`, `upgrade` and `cleanup --prune`.

Usage: `brewup`

### > cal
Handy wrapper to colorize current date in `cal`. Arguments usage will reset layout to normal.

Usage: `cal [<arguments>]`

### > config
Provides short way to reload/edit config file or its home/functions folder, or edit prompt function.

Usage: `config [edit | reload | prompt | home | functions]`

### > curltime
Measures time for performed CURL request.

Usage: `curltime <url>`

### > fake_smtp
Runs local Python’s SMTP ``DebuggingServer``.

Usage: `fake_smtp [<port>]`

### > ip_up_add
Easier way to add a subnetwork in `/etc/ppp/ip-up`. Usable for selective VPN traffic.

Usage: `ip_up_add <subnetwork> [<comment>]`

### > notify
Displays macOS notification.

Usage: `notify <message> [<title> [<subtitle>]]`

### > pip
Simple wrapper to track which version of PIP is used. Also helps with `sudo`.

Usage: `pip [<whatever>]`

### > venv
Simple wrapper for Python’s `venv` module. Also provides shorthand for `. ./bin/activate.fish` and event listener for venv auto-activation/deactivation.

Usage: `venv <arguments>`, `activate [--quiet]`

### > vpn
Faster way to handle existing PPTP/L2TP connections in macOS. Not so usable for L2TP, because of a shared key.

Usage: `vpn [list | start <connection> | stop <connection> | switch <connection>]`

### > world_time
Displays current time in given timezones, e.g. `US/Pacific`, `UTC`, `Asia/Bangkok` and etc. See `/usr/share/zoneinfo` for more.

Usage: `world_time <timezones>`
