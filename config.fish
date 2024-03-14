function config -a utility -d 'Manages various utility configurations'
    set EDITOR_DIR (string replace -r '\-?w' '' "$EDITOR")

    switch "$utility"
        case 'alacritty'
            eval $EDITOR_DIR ~/.config/alacritty
        case 'bottom' 'btm'
            eval $EDITOR ~/.config/bottom/bottom.toml
        case 'fish'
            eval $EDITOR_DIR ~/.config/fish
        case 'lsd'
            eval $EDITOR_DIR ~/.config/lsd
        case 'neovim' 'nvim'
            eval $EDITOR_DIR ~/.config/nvim
        case 'rtx' 'mise'
            eval $EDITOR_DIR ~/.config/mise
        case 'starship'
            eval $EDITOR ~/.config/starship.toml
        case '*'
            echo 'Manage various utility configurations.'
            echo ''
            echo "Usage: $_ UTILITY"
            echo ''
            echo 'Utilities:'
            echo '  alacritty    Opens the Alacritty config directory'
            echo '  bottom/btm   Opens the bottom config file'
            echo '  fish         Opens the Fish config directory'
            echo '  lsd          Opens the lsd config directory'
            echo '  neovim/nvim  Opens the Neovim config directory'
            echo '  rtx/mise     Opens the mise-en-place (former rtx) config directory'
            echo '  starship     Opens the Starship config file'
            echo ''
            echo 'Parameters:'
            echo '  UTILITY     An utility name [required]'
    end
end
