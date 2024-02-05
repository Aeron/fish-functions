function hide -d 'Hides (or reveals) a given item (file, link, or directory) from GUI'
    set -l opts (fish_opt -s r -l rev)

    argparse --ignore-unknown $opts -- $argv
    or return

    set path $argv[1]

    if not test -e "$path"
        echo -s \
            (set_color $fish_color_error) \
            'error: path does not exist' \
            (set_color normal)
        return 1
    end

    if test $_flag_rev
        command chflags -fh nohidden "$path"
        return 0
    end

    command chflags -fh hidden "$path"
end
