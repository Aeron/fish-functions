function rgsk -d 'Interactive ripgrep+skim fuzzy finder'
    if not command -q rg; or not command -q sk
        echo "error: both ripgrep and skim must be installed"
        return 1
    end

    if contains -- --help $argv
        echo "Usage: $_ [RG_QUERY [SK_QUERY]]"
        return 0
    end

    sk --ansi \
        --cmd 'rg --column --line-number --no-heading --color=always --smart-case "{}"'\
        --cmd-query "$argv[1]" \
        --query "$argv[2]" \
        --delimiter ':' \
        --no-bold \
        --preview 'bat --number --color=always --highlight-line={2} {1}' \
        --preview-window 'up:66%' \
        --cmd-prompt 'rg> ' \
        --prompt 'sk> ' \
        --bind "enter:execute($EDITOR {1}:{2}:{3})"
end
