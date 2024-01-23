function unlock -a path -d 'Disables macOS Gatekeeper for a specified application'
    if test -d $path
        xattr -rd com.apple.quarantine $path

        if contains -- --sign $argv
            codesign --force --deep --sign - $path
        end
    else
        echo -s \
            (set_color $fish_color_error) \
            "error: application $path not found" \
            (set_color normal)
        return 1
    end
end
