function config -a utility -d 'Manages various utility configurations'
    set EDITOR_DIR (string replace -r '\-?w' '' $EDITOR)

    switch "$utility"
        case 'bottom'
            eval $EDITOR '~/Library/Application Support/bottom/bottom.toml'
        case 'fish'
            eval $EDITOR_DIR ~/.config/fish
        case 'lsd'
            eval $EDITOR_DIR ~/.config/lsd
        case 'rtx'
            eval $EDITOR ~/.config/rtx/config.toml
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
            echo '    rtx         Opens the rtx config in the $EDITOR'
            echo '    starship    Opens the Starship config in the $EDITOR'
            echo ''
            echo 'Parameters:'
            echo '    UTILITY      An utility name [required]'
    end
end
