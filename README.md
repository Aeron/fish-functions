# Fish Functions

A repo with my [Fish](http://fishshell.com) shell functions.

Some are very usable, yet some are just gimmicks and tinkering (e.g., `cal` and
`notify`), and some are simply outdated and irrelevant (e.g., `vpn` and `smtp`).

> [!WARNING]
> Most of the functions here written for macOS as a platform. Yet some of them
> are entirely POSIX-compatible. Please check before use.

## Fish theme

`fish_prompt.fish` is a theme I currently use. Inspired by
[Kenneth Reitz](https://github.com/kennethreitz)’ original theme for
[Oh-my-ZSH](https://github.com/robbyrussell/oh-my-zsh).

![Terminal with Fish](https://user-images.githubusercontent.com/278423/27943158-783e5b80-62e5-11e7-863b-053dd9d897ab.png)

> [!NOTE]
> Not using it much these days because of [Starship](https://starship.rs).

## Functions

### > activate

Activates Python's venv for current directory. A shorthand for
`source ./bin/activate.fish`.

Usage: `activate [-v]`

### > asdf-check

Checks for asdf plugin newer versions.

Usage: `asdf-check [--no-update]`

### > asdf-prune

Removes older asdf plugin versions.

Usage: `asdf-prune [-f]`

### > asdf-up

Updates asdf, its plugins, and reshims packages.

Usage: `asdf-up [--prune] [--check-only]`

### > brew-up

Updates Homebrew, upgrades and cleans up packages, removes leftover deps.

Usage: `brew-up`

### > cal

Handy wrapper to colorize current date in `cal`. Arguments usage will reset layout to
normal.

Usage: `cal [ARGS...]`

### > cip

Displays the current IP addresses (using [ifconfig.co](https://ifconfig.co)).

Usage: `cip`

### > config

Manages various utility configurations. For example: `fish`, `mise`, `starship`.

```text
Usage:
    config UTILITY

Utilities:
    bottom      Opens the bottom config in the $EDITOR
    fish        Opens the Fish config in the $EDITOR
    lsd         Opens the lsd config in the $EDITOR
    rtx/mise    Opens the mise-en-place (former rtx) config in the $EDITOR
    starship    Opens the Starship config in the $EDITOR

Parameters:
    UTILITY      An utility name [required]
```

### > curl-time

Measures time for a performed CURL request.

Usage: `curl-time URL`

### > database

Manages databases as containers (via Docker).

```text
Usage:
    database COMMAND DATABASE [OPTS...]

Commands:
    up/start         Starts a new database container
    down/stop        Stops an existing database container
    rm/remove        Removes an existing database container

Mongo Commands:
    dump             Exports the content of a running server
    restore          Restores backups to a running server

Databases:
    mongo            Specifies MongoDB as a database
    postgres         Specifies Postgres as a database
    redis            Specifies Redis as a database

Mongo Dump/Restore Options:
    --path=<PATH>    Specifies a directory path or name
                     [default: "mongo-dump-<DATE>" and "."]
    --db=<NAME>      Specifies a database name
    --coll=<NAME>    Specifies a collection name

Parameters:
    COMMAND          A command name [required]
    DATABASE         A database name [required]
```

### > date-hash

Displays current timestamp hash (hexadecimal representation).

Usage: `date-hash`

### > date-iso

Displays the current date in ISO8601 (without milliseconds).

Usage: `date-iso [--short]`

### > dns

Adds or removes common DNS servers (Quad9 and Cloudflare) to or from a network.
Or cleans all of network DNS servers.

```text
Usage:
    dns CMD [NAME]

Commands:
    list/ls      Lists current DNS servers of a network
    add          Adds common DNS servers to a network
    rm/remove    Removes common DNS servers from a network
    clean        Cleans all DNS servers of a network

Parameters:
    CMD          A command to perform [required]
    NAME         A network name [default: "Wi-Fi"]
```

### > docker-reset

Stops all containers, removes them and all images.

Usage: `docker-reset`

### > flushdns

Flushes a macOS DNS cache.

Usage: `flushdns`

### > fuzz

Interactive fuzzy finder on top of [`ripgrep`][ripgrep]+[`skim`][skim].

Usage: `fuzz [RG_QUERY [SK_QUERY]]`

[ripgrep]: https://github.com/BurntSushi/ripgrep
[skim]: https://github.com/lotabout/skim

### > gen

Generates either an X.509 cert, SSH key, or random base64 string.

```text
Usage:
    gen ENTITY [OPTS]

Entities:
    cert/x509          Generate an X.509 certificate
    ssh/key            Generate an SSH key
    base64/b64         Generate a random base64 string

Options:
    --bits=NUM         Base64 binary bit-length [optional]
    --cn=NAME          Certificate common name [optional]
    --days=NUM         Certificate validity period [optional]
    --filename=NAME    SSH key filename [optional]
    --comment=TEXT     SSH key comment [optional]

Parameters:
    ENTITY             An entity name [required]
```

### > hide

Hides (or reveals) a given item (file, link, or directory) from GUI.

Usage: `hide [--rev] PATH`

### > ip-up-add

Easier way to add a subnetwork in `/etc/ppp/ip-up`. Usable for a selective VPN traffic.

Usage: `ip-up-add SUBNET [COMMENT]`

### > kick

Kickstarts a new software development project.

```text
Usage:
    kick [OPTS...] [TARGET]

Options:
    --lang=python    Creates a Python project [default]
    --lang=go        Creates a Go project
    --lang=rust      Creates a Rust project
    --lang=zig       Creates a Zig project

    --name=<NAME>    Specifies the project name [default: "thingy"]
    --lib            Specifies the project is a library
    --no-git         Ignores Git VCS initialization

Python Options:
    --no-venv        Ignores Python virtual environment creation

Parameters:
    TARGET           A target directory [default: "."]
```

### > kube-ctx

Displays or sets current Kube context.

Usage: `kube-ctx [CTX]`

### > launchpad-reset

Resets macOS Launchpad layout.

Usage: `launchpad-reset`

### > mise-check

Checks for mise-en-place (former rtx) plugin newer versions.

Usage: `mise-check [--verbose]`

### > mise-up

Updates mise-en-place (former rtx) packages (and reshims them).

Usage: `mise-up [--check-only]`

### > mise-venv

Configures a local mise-en-place (former rtx) Python with a virtual environment.

Usage: `mise-venv`

### > notify

Displays a macOS notification.

Usage: `notify MESSAGE [TITLE [SUBTITLE]]`

### > pbcopy-gpg

Copies a GPG public key.

Usage: `pbcopy-gpg [FINGERPRINT]`

### > pbcopy-ssh

Copies an SSH public key (that starts with `id_`).

Usage: `pbcopy-ssh [TYPE]`

### > ping

A wrapper around the `ping` with a default address (1.1.1.1).

Usage: `ping [ARGS...]`

### > pip-reset

Removes local Python packages, except the default ones.

It supports both `pip` and [`uv`](https://github.com/astral-sh/uv).

Usage: `pip-reset`

### > pip-up

Updates local Python packages listed in the default packages file.

It supports both `pip` and [`uv`](https://github.com/astral-sh/uv).

Usage: `pip-up`

### > pyclean

Cleans directory Python cache and pre-compiled modules recursively.

Usage: `pyclean`

### > semver

Evaluates an actual semantic version for a Git Flow repo.

Usage: `semver [-lv]`

### > smtp

Runs a local Python SMTP ``DebuggingServer``.

Usage: `smtp [PORT]`

### > soft-up

Updates macOS software.

Usage: `soft-up [--check-only]`

### > source-posix

Exports variables from a POSIX-compatible environment file.

Usage: `source-posix FILE [-v]`

### > sri-hash

Calculates the subresource integrity hash for a given file.

Usage: `sri-hash FILE`

### > tztime

Displays current time in given timezones, e.g. `US/Pacific`, `UTC`, `Asia/Bangkok` and
etc. See `/usr/share/zoneinfo/` for more.

Usage: `tztime TIMEZONE`

### > unlock

Disables macOS Gatekeeper for a specified application.

Usage: `unlock PATH [--sign]`

### > up-up

Updates macOS software, Homebrew, asdf, and local Python packages.

An alias for `soft-up`, `brew-up`, `mise-up`, and `pip-up`.

Usage: `up-up [--all]`

### > venv

Simple wrapper for Python’s `venv` module.

Usage: `venv [--reset] [--rm]`

### > vpn

Faster way to handle existing PPTP/L2TP connections in macOS. _Not so usable for L2TP_,
because of a shared key.

Usage: `vpn [list | start CONN | stop CONN | switch CONN]`
