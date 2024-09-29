function config -a utility -d 'Manages various utility configurations'
    set EDITOR_DIR (string replace -r '\-?w' '' "$EDITOR")

    switch "$utility"
        case alacritty
            eval $EDITOR_DIR ~/.config/alacritty
        case bat
            eval $EDITOR ~/.config/bat/config
        case bottom btm
            eval $EDITOR ~/.config/bottom/bottom.toml
        case delta
            git config edit --global
        case fish
            eval $EDITOR_DIR ~/.config/fish
        case git
            git config edit --global
        case hosts
            eval $EDITOR /etc/hosts
        case jj
            jj config edit --user
        case hx helix
            eval $EDITOR_DIR ~/.config/helix
        case kube kubectl
            eval $EDITOR ~/.kube/config
        case lsd
            eval $EDITOR_DIR ~/.config/lsd
        case neovim nvim
            eval $EDITOR_DIR ~/.config/nvim
        case rtx mise
            eval $EDITOR ~/.config/mise/config.toml
        case starship
            eval $EDITOR ~/.config/starship.toml
        case ssh
            eval $EDITOR ~/.ssh/config
        case '*'
            echo 'Manage various utility configurations.'
            echo ''
            echo "Usage: $_ UTILITY"
            echo ''
            echo 'Utilities:'
            echo '  alacritty    Opens the Alacritty config directory'
            echo '  bat          Opens the bat config file'
            echo '  bottom, btm  Opens the bottom config file'
            echo '  delta        Opens the delta config file (same as Git)'
            echo '  fish         Opens the Fish config directory'
            echo '  git          Opens the Git global config file'
            echo '  hosts        Opens the hosts config file [required: sudo]'
            echo '  jj           Opens the jj config file'
            echo '  hx, helix    Opens the Helix config directory'
            echo '  kube[ctl]    Opens the kubectl config file'
            echo '  lsd          Opens the lsd config directory'
            echo '  n[eo]vim     Opens the Neovim config directory'
            echo '  rtx, mise    Opens the mise-en-place (former rtx) config file'
            echo '  starship     Opens the Starship config file'
            echo '  ssh          Opens the SSH config file'
            echo ''
            echo 'Parameters:'
            echo '  UTILITY      An utility name [required]'
    end
end
