begin
    set prefix 'rg --column --line-number --no-heading --color=always --smart-case'
    set preview 'bat --number --color=always --highlight-line={2} {1}'

    set prompt_rg 'rg ❯ '
    set prompt_fzf 'fzf ❯ '
    set prompt_sk 'sk ❯ '

    set color 'hl:-1,hl+:-1'

    function ripgrep-fzf
        set tmp_rg_path /tmp/fuzz-rg
        set tmp_fzf_path /tmp/fuzz-fzf

        rm -f $tmp_rg_path $tmp_fzf_path

        if not command -q rg; or not command -q fzf
            echo "error: both ripgrep and fzf must be installed"
            return 1
        end

        FZF_DEFAULT_COMMAND="$prefix $argv[1]" \
        fzf --ansi \
            --no-bold \
            --tabstop=4 \
            --color "$color" \
            --prompt "$prompt_fzf" \
            --query "$argv[2]" \
            --delimiter ':' \
            --preview "$preview" \
            --preview-window 'up,66%,border-bottom,+{2}+3/3,~3' \
            --bind "enter:become($EDITOR {1}:{2}:{3})"
    end

    function ripgrep-skim
        if not command -q rg; or not command -q sk
            echo "error: both ripgrep and skim must be installed"
            return 1
        end

        sk  --ansi \
            --no-bold \
            --color "$color" \
            --tabstop=4 \
            --cmd "$prefix \"{}\""\
            --cmd-query "$argv[1]" \
            --cmd-prompt "$prompt_rg" \
            --prompt "$prompt_sk" \
            --query "$argv[2]" \
            --delimiter ':' \
            --preview "$preview" \
            --preview-window 'up:66%' \
            --bind "enter:execute($EDITOR {1}:{2}:{3})"
    end

    # NOTE: skim already smells like abandonware, and it has unsolved issues, so
    # it is not always convenient or even possible to use
    function fuzz -d 'Interactive fuzzy finder'
        set -l opts (fish_opt -s h -l help)
        set -a opts (fish_opt -s s -l skim --long-only)

        argparse --ignore-unknown --stop-nonopt $opts -- $argv
        or return

        if test -n "$_flag_help" -o -z "$argv"
            echo "Usage: $_ [OPTS...] RG_QUERY [FZ_QUERY]"
            echo ''
            echo 'Options:'
            echo '  -s, --skim  Use skim instead of fzf'
            echo ''
            echo 'Parameters:'
            echo '  RG_QUERY    An initial filtering ripgrep query'
            echo '  FZ_QUERY    A fuzzy finder query [optional]'
        else if test -n "$_flag_skim"
            ripgrep-skim $argv
        else
            ripgrep-fzf $argv
        end
    end
end

