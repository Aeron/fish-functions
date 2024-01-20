function config -a utility -d 'Manages various utility configurations'
    set EDITOR_DIR (string replace -r '\-?w' '' "$EDITOR")

    switch "$utility"
        case 'bottom' 'btm'
            eval $EDITOR ~/.config/bottom/bottom.toml
        case 'fish'
            eval $EDITOR_DIR ~/.config/fish
        case 'lsd'
            eval $EDITOR_DIR ~/.config/lsd
        case 'rtx' 'mise'
            eval $EDITOR_DIR ~/.config/mise
        case 'starship'
            eval $EDITOR ~/.config/starship.toml
        case '*'
            echo "$_ manage various utility configurations."
            echo ''
            echo 'Usage:'
            echo "    $_ UTILITY"
            echo ''
            echo 'Utilities:'
            echo '    bottom      Opens the bottom config in the $EDITOR'
            echo '    fish        Opens the Fish config in the $EDITOR'
            echo '    lsd         Opens the lsd config in the $EDITOR'
            echo '    rtx/mise    Opens the mise-en-place (former rtx) config in the $EDITOR'
            echo '    starship    Opens the Starship config in the $EDITOR'
            echo ''
            echo 'Parameters:'
            echo '    UTILITY      An utility name [required]'
    end
end
