begin
    set prefix_rg 'rg --column --line-number --no-heading --color=always --smart-case'
    set prefix_file 'fd --hidden --type f'
    set prefix_dir 'fd --hidden --type d'

    set preview_rg 'bat --number --color=always --highlight-line={2} {1}'
    set preview_file 'bat --number --color=always {1}'
    set preview_dir 'lsd -A --color=always --tree --depth=2 {1}'

    set window 'up,66%,border-bottom,+{2}+3/3,~3'

    set prompt 'fzf ❯ '
    set pointer '❯'
    set marker '+'

    # set color 'hl:-1,hl+:-1'

    function fd-fzf-file
        if not command -q fd
            echo "error: fd must be installed"
            return 1
        end

        FZF_DEFAULT_COMMAND="$prefix_file '$argv[1]'" \
        fzf --ansi \
            --no-bold \
            --tabstop=4 \
            # --color "$color" \
            --prompt "$prompt" \
            --pointer "$pointer" \
            --marker "$marker" \
            --query "$argv[2]" \
            --delimiter ':' \
            --preview "$preview_file" \
            --preview-window "$window" \
            --bind "enter:become($EDITOR {1})" \
            --bind "ctrl-o:become(open -R {1})"
    end

    function fd-fzf-dir
        if not command -q fd
            echo "error: fd must be installed"
            return 1
        end

        FZF_DEFAULT_COMMAND="$prefix_dir '$argv[1]'" \
        fzf --ansi \
            --no-bold \
            --tabstop=4 \
            # --color "$color" \
            --prompt "$prompt" \
            --pointer "$pointer" \
            --marker "$marker" \
            --query "$argv[2]" \
            --delimiter ':' \
            --preview "$preview_dir" \
            --preview-window "$window" \
            --bind "enter:become($EDITOR {1})" \
            --bind "ctrl-o:become(open {1})"
    end

    function ripgrep-fzf
        if not command -q rg
            echo "error: ripgrep must be installed"
            return 1
        end

        FZF_DEFAULT_COMMAND="$prefix_rg '$argv[1]'" \
        fzf --ansi \
            --no-bold \
            --tabstop=4 \
            # --color "$color" \
            --prompt "$prompt" \
            --pointer "$pointer" \
            --marker "$marker" \
            --query "$argv[2]" \
            --delimiter ':' \
            --preview "$preview_rg" \
            --preview-window "$window" \
            --bind "enter:become($EDITOR {1}:{2}:{3})" \
            --bind "ctrl-o:become(open -R {1})"
    end

    # NOTE: skim already smells like abandonware, and it has unsolved issues, so
    # it is not always convenient or even possible to use
    function fuzz -d 'Interactive fuzzy finder'
        if not command -q fzf
            echo "error: fzf must be installed"
            return 1
        end

        set -l opts (fish_opt -s h -l help)
        set -a opts (fish_opt -s f -l file)
        set -a opts (fish_opt -s d -l dir)

        argparse --ignore-unknown --stop-nonopt $opts -- $argv
        or return

        if test -n "$_flag_help" -o -z "$argv"
            echo "Usage: $_ [OPTS...] INIT_QUERY [FZF_QUERY]"
            echo ''
            echo 'Options:'
            echo '  -f, --file  Use file name search'
            echo '  -d, --dir   Use directory name search'
            echo ''
            echo 'Parameters:'
            echo '  INIT_QUERY  An initial pre-filtering query'
            echo '  FZF_QUERY   A fuzzy finder query [optional]'
        else if test -n "$_flag_file"
            fd-fzf-file $argv
        else if test -n "$_flag_dir"
            fd-fzf-dir $argv
        else
            ripgrep-fzf $argv
        end
    end
end

