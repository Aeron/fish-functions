begin
    function _extract_version
        string match -rg '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)' -- "$argv"
    end

    function mise-check -d "Checks for mise-en-place (former rtx) plugin newer versions"
        set verbose (contains -- --verbose $argv; or contains -- -v $argv; and echo 1; or echo 0)
        set number 0

        for current in (mise outdated --no-header)
            set current (string split -n -f1,3,4 " " $current)
            set current_plugin $current[1]
            set current_version $current[2]
            set current_version_info (_extract_version $current_version)

            # skipping if a version does not split
            if test "$current_version_info[1]" = "$current_version"
                if test $verbose
                    echo "$current_plugin: $current_version (skipping)"
                end
                continue
            end

            set newer_version $current[3]
            set newer_version_info (_extract_version $newer_version)

            if test $verbose -eq 1
                echo "$current_plugin: $current_version vs $newer_version"
            end

            if test $current_version_info[1] -lt $newer_version_info[1] \
                    -o $current_version_info[2] -lt $newer_version_info[2] \
                    -o $current_version_info[3] -lt $newer_version_info[3]
                echo -s (set_color blue) \
                    "$current_plugin has a newer version: $newer_version" \
                    (set_color normal)
                set number (math $number + 1)
            end
        end

        if test $number -eq 0
            echo "Nothing to update."
        end
    end
end
