# Fish Functions

A repo with my [Fish](http://fishshell.com) shell functions.

Some are very usable, yet some are just gimmicks and tinkering (e.g., `cal` and
`notify`), and some are simply outdated and irrelevant (e.g., `vpn`).

> [!WARNING]
> Most of the functions here written for macOS as a platform. Yet some of them
> are entirely POSIX-compatible. Please check before use.

## Fish theme

`fish_prompt.fish` is a theme I currently use. Inspired by
[Kenneth Reitz](https://github.com/kennethreitz)’ original theme for
[Oh-my-ZSH](https://github.com/robbyrussell/oh-my-zsh).

> [!NOTE]
> Not using it much these days because of [Starship](https://starship.rs).

![Terminal with Fish](https://user-images.githubusercontent.com/278423/27943158-783e5b80-62e5-11e7-863b-053dd9d897ab.png)

## Functions

### > about

Shows information about this Mac. A tiny [neofetch][neofetch] or [fastfetch][fastfetch] alternative.

Usage: `about`

[neofetch]: https://github.com/dylanaraps/neofetch
[fastfetch]: https://github.com/fastfetch-cli/fastfetch

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

### > config

Manages various utility configurations. For example: `fish`, `mise`, `starship`.

```text
Usage: config UTILITY

Utilities:
  alacritty    Opens the Alacritty config directory
  bat          Opens the bat config file
  bottom, btm  Opens the bottom config file
  delta        Opens the delta config file (same as Git)
  fish         Opens the Fish config directory
  ghostty      Opens the Ghostty config file
  git          Opens the Git global config file
  hosts        Opens the hosts config file [required: sudo]
  jujutsu, jj  Opens the Jujutsu config file
  helix, hx    Opens the Helix config directory
  kube[ctl]    Opens the kubectl config file
  lsd          Opens the lsd config directory
  n[eo]vim     Opens the Neovim config directory
  rtx, mise    Opens the mise-en-place (former rtx) config file
  starship     Opens the Starship config file
  ssh          Opens the SSH config file

Parameters:
  UTILITY      An utility name [required]
```

### > curl-time

Measures time for a performed CURL request.

Usage: `curl-time URL`

### > database

Manages databases as containers (via Docker).

```text
Usage: database COMMAND DATABASE

Commands:
  up/start       Starts a new database container
  down/stop      Stops an existing database container
  rm/remove      Removes an existing database container

Databases:
  mongo          Specifies MongoDB as a database
  postgres       Specifies Postgres as a database
  valkey         Specifies Valkey as a database
  redis          Specifies Redis as a database
  dragonfly      Specifies Dragonfly as a database

Parameters:
  COMMAND        A command name [required]
  DATABASE       A database name [required]
```

### > date-hash

Displays current timestamp hash (hexadecimal representation).

Usage: `date-hash`

### > date-iso

Displays the current date in ISO8601 (without milliseconds).

Usage: `date-iso [--short]`

### > dns

Manages common DNS servers (Quad9 and Cloudflare) of a given network.

```text
Usage: dns CMD [NAME]

Commands:
  list/ls    Lists current DNS servers of a network
  add        Adds common DNS servers to a network
  rm/remove  Removes common DNS servers from a network
  clean      Cleans all DNS servers of a network

Parameters:
  CMD        A command to perform [required]
  NAME       A network name [default: "Wi-Fi"]
```

### > docker-reset

Stops all containers, removes them and all images.

Usage: `docker-reset`

### > flushdns

Flushes a macOS DNS cache.

Usage: `flushdns`

### > fuzz

Interactive fuzzy finder.

It requires [`ripgrep`][ripgrep] and [`fzf`][fzf] or [`skim`][skim].

```text
Usage: fuzz [OPTS...] RG_QUERY [FZ_QUERY]

Options:
  -s, --skim  Use skim instead of fzf

Parameters:
  RG_QUERY    An initial filtering ripgrep query
  FZ_QUERY    A fuzzy finder query [optional]
```

[ripgrep]: https://github.com/BurntSushi/ripgrep
[skim]: https://github.com/lotabout/skim
[fzf]: https://github.com/junegunn/fzf

### > gen

Generates either an X.509 cert, SSH key, or random base64 string.

```text
Usage: gen ENTITY [OPTS...]

Entities:
  x509/cert          Generate an X.509 certificate
  ssh/key            Generate an SSH key
  base64/b64         Generate a random base64 string

X.509 Options:
  --cn=<NAME>        Certificate common name [default: "localhost"]
  --days=<NUM>       Certificate validity period [default: 365]

SSH Options:
  --filename=<NAME>  SSH key filename [default: "key"]
  --comment=<TEXT>   SSH key comment [default: "username@hosname"]

Base64 Options:
  --bits=<NUM>       Base64 binary bit-length [default: 32]

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
Usage: kick [OPTS...] [TARGET]

Options:
  --lang=python  Creates a Python project [default]
  --lang=go      Creates a Go project
  --lang=rust    Creates a Rust project
  --lang=zig     Creates a Zig project

  --name=<NAME>  Specifies the project name [default: "unnamed"]
  --lib          Specifies the project is a library
  --no-git       Omits Git VCS initialization
  --no-readme    Omits README.md creation

Python Options:
  -V, --no-venv  Ignores Python virtual environment creation

Parameters:
  TARGET         A target directory [default: "."]
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

### > net

Displays network stuff (IP address(es), used port(s), etc).

```text
Usage: net CMD [OPTS...]

Commands:
  addrs                Display the current public IP address(es)
  ports                Display the port(s) currently in use

Addresses Options:
  -4, --ipv4           Prefer an IPv4 address
  -6, --ipv6           Prefer an IPv6 address

Ports Options:
  -p, --proto=<PROTO>  A protocol to lookup [default: "TCP"]
  -s, --state=<STATE>  A state to lookup [default: "LISTEN"]
  -n, --num PORT       A port number to lookup
```

### > notify

Displays a macOS notification.

Usage: `notify MESSAGE [TITLE [SUBTITLE]]`

### > ollama-up

Updates all Ollama models.

Usage: `ollama-up`

### > pbcopy-gpg

Copies a GPG public key.

Usage: `pbcopy-gpg [FINGERPRINT]`

### > pbcopy-ssh

Copies an SSH public key (that starts with `id_`).

Usage: `pbcopy-ssh [TYPE]`

### > ping

A wrapper around the `ping` with a default address (9.9.9.9).

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

### > ramdisk

Manages RAM disks.

```text
Usage: ramdisk [OPTS...] [NAME]

Commands:
  create                Creates a new RAM disk and mounts it
  remove, rm            Unmounts an existing RAM volume and releases its device

Create Options:
  --size=<NUM>[k|m|g]   Specifies the disk size in (kilo|mega|giga)bytes [default: 2G]

Parameters:
  NAME                  A target volume name [default: "RAM Disk"]
```

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

Calculates the [subresource integrity][mdn-sri] hash for a given file.

Usage: `sri-hash FILE`

[mdn-sri]: https://developer.mozilla.org/en-US/docs/Web/Security/Defenses/Subresource_Integrity

### > tztime

Displays current time in given timezones, e.g. `US/Pacific`, `UTC`, `Asia/Bangkok` and
etc. See `/usr/share/zoneinfo/` for more.

Usage: `tztime TIMEZONE`

### > unicode

Returns a Unicode code point for a given character.

Usage: `unicode CHARACTER`

### > unlock

Disables macOS Gatekeeper for a specified application.

Usage: `unlock PATH [--sign]`

### > up-up

Updates macOS software, Homebrew, mise-en-place, and local Python packages.

An alias for `soft-up`, `brew-up`, `mise-up`, and `pip-up`.

Usage: `up-up [--all]`

### > venv

Simple wrapper for Python’s `venv` module.

Usage: `venv [--reset] [--rm]`

### > vpn

Faster way to handle existing PPTP/L2TP connections in macOS. _Not so usable for L2TP_,
because of a shared key.

Usage: `vpn [list | start CONN | stop CONN | switch CONN]`
