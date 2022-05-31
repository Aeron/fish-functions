# Fish Functions

A repo with my [Fish](http://fishshell.com) shell functions.

Some are very usable, yet some are just gimmicks and tinkering (e.g., `cal` and
`notify`), and some are simply outdated and irrelevant (e.g., `vpn` and `smtp`).

## Fish theme

`fish_prompt.fish` is a theme I currently use. Inspired by
[Kenneth Reitz](https://github.com/kennethreitz)’ original theme for
[Oh-my-ZSH](https://github.com/robbyrussell/oh-my-zsh).

![Terminal with Fish](https://user-images.githubusercontent.com/278423/27943158-783e5b80-62e5-11e7-863b-053dd9d897ab.png)

**Note**: Not using it much these days because of [Starship](https://starship.rs).

## Functions

### > activate

Activates Python's venv for current directory. A shorthand for
`source ./bin/activate.fish`.

Usage: `activate [-v]`

### > asdf-prune

Removes older asdf plugin versions.

Usage: `asdf-prune [-f]`

### > asdf-up

Updates asdf, its plugins, and reshims packages.

Usage: `asdf-up [--prune]`

### > brew-up

Updates Homebrew, upgrades and cleans up packages, removes leftover deps.

Usage: `brew-up`

### > cal

Handy wrapper to colorize current date in `cal`. Arguments usage will reset layout to
normal.

Usage: `cal [<arguments>]`

### > curl-time

Measures time for a performed CURL request.

Usage: `curl-time <url>`

### > date-hash

Displays current timestamp hash (hexadecimal representation).

Usage: `date-hash`

### > docker-reset

Stops all containers, removes them and all images.

Usage: `docker-reset`

### > fish-config

Provides a short way to reload/edit a config file or its home/functions folder, or edit
a prompt function.

Usage: `fish-config [edit | reload | prompt | home | functions]`

### > flushdns

Flushes a macOS DNS cache.

Usage: `flushdns`

### > gen-openssl-cert

Generates a simple OpenSSL X509 certificate.

Usage: `gen-openssl-cert [<cn>] [<days>]`

### > gen-ssh-key

Generates an ed25519 SSH key.

Usage: `gen-ssh-key [<filename>] [<comment>]`

### > ip-up-add

Easier way to add a subnetwork in `/etc/ppp/ip-up`. Usable for a selective VPN traffic.

Usage: `ip-up-add <subnetwork> [<comment>]`

### > kube-ctx

Displays or sets current Kube context.

Usage: `kube-ctx [<context>]`

### > newpy

Helps to setup a new Python project, its venv and Git repo.

Usage: `newpy [<project> [<package> [<python>]]] [--no-venv] [--no-git]`

### > notify

Displays a macOS notification.

Usage: `notify <message> [<title> [<subtitle>]]`

### > pbcopy-gpg

Copies a GPG public key.

Usage: `pbcopy-gpg [<fingerprint>]`

### > pbcopy-ssh

Copies an SSH public key.

Usage: `pbcopy-ssh [<type>]`

### > pip-reset

Removes local Python packages, except for a few vital ones.

Usage: `pip-reset`

### > pip-up

Updates local Python packages, like `pip`, `wheel` and `setuptools`, as well as
everything listed in `~/.requirements.txt`.

Usage: `pip-up`

### > pyclean

Cleans directory Python cache and pre-compiled modules recursively.

Usage: `pyclean`

### > semver

Evaluates an actual semantic version for a Git Flow repo.

Usage: `semver [-lv]`

### > smtp

Runs a local Python SMTP ``DebuggingServer``.

Usage: `smtp [<port>]`

### > soft-up

Updates all macOS (App Store) applications.

Usage: `soft-up`

### > source-posix

Exports variables from a POSIX-compatible environment file.

Usage: `source-posix <file.env> [-v]`

### > startship-config

Handy alias to manage a Starship config.

Usage: `starship-config`

### > tztime

Displays current time in given timezones, e.g. `US/Pacific`, `UTC`, `Asia/Bangkok` and
etc. See `/usr/share/zoneinfo/` for more.

Usage: `tztime <timezones>`

### > unlock

Disables macOS Gatekeeper for a specified application.

Usage: `unlock <path>`

### > up-up

Updates macOS software, Homebrew, asdf, and local Python packages.

An alias for `soft-up`, `brew-up`, (optionally) `asdf-up`, and `pip-up`.

Usage: `up-up [--all]`

### > venv

Simple wrapper for Python’s `venv` module.

Usage: `venv <arguments>`

### > vpn

Faster way to handle existing PPTP/L2TP connections in macOS. _Not so usable for L2TP_,
because of a shared key.

Usage: `vpn [list | start <connection> | stop <connection> | switch <connection>]`
