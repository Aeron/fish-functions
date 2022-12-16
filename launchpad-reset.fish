function launchpad-reset -d "Resets macOS Launchpad layout"
    defaults write com.apple.dock ResetLaunchPad -bool true
    and killall Dock
end
