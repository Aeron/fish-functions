begin
    function _extract_version
        set v (string split -f1,2,3 --allow-empty "." $argv)

        for part in 1 2 3
            if test -z $v[$part]
                set v[$part] 0
            end

            echo $v[$part]
        end
    end

    function asdf-check -d "Checks for asdf plugin newer versions"
        if ! contains -- --no-update $argv
            asdf plugin update --all
        end

        for current in (asdf current)
            set current (string split -n -f1,2 " " $current)
            set current_plugin $current[1]
            set current_version $current[2]
            set current_version_info (_extract_version $current[2])

            # asking for the latest but keeping the major version in mind
            set newer_version (asdf latest $current_plugin $current_version_info[1])
            set newer_version_info (_extract_version $newer_version)

            if test $current_version_info[1] -lt $newer_version_info[1] \
                -o $current_version_info[2] -lt $newer_version_info[2] \
                -o $current_version_info[3] -lt $newer_version_info[3]
                echo -s (set_color blue) \
                    "$current_plugin has a newer version: $newer_version" \
                    (set_color normal)
            end
        end
    end
end
