function pkgutil-old -d "Queries MacOS Installer older packages"
    set now (date +%s)
    set timedelta (math 31622400 x 3)  # three years in seconds
    set threshold (math $now - $timedelta)

    for pkg_id in (pkgutil --pkgs | grep -v com.apple)
        set installed (
            pkgutil --pkg-info $pkg_id \
            | string match -ir 'install-time:\ ([0-9]+)'
        )[2]

        if test $installed -le $threshold
            echo (date -r $installed -u +%Y-%m-%d) $pkg_id
        end
    end
end
