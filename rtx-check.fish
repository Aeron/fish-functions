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

    function rtx-check -d "Checks for rtx plugin newer versions"
        set number 0

        for current in (rtx current)
            set current (string split -n -f1,2 " " $current)
            set current_plugin $current[1]
            set current_version $current[2]
            set current_version_info (_extract_version $current[2])

            # asking for the latest but keeping the major version in mind
            set newer_version (rtx latest $current_plugin@$current_version_info[1].)
            set newer_version_info (_extract_version $newer_version)

            if contains -- --verbose $argv
                echo "$current_plugin: $current_version vs $newer_version"
            end

            if test $current_version_info[1] -lt $newer_version_info[1] \
                -o $current_version_info[2] -lt $newer_version_info[2] \
                -o $current_version_info[3] -lt $newer_version_info[3]
                echo -s (set_color blue) \
                    "$current_plugin has a newer version: $newer_version" \
                    (set_color normal)
                set number $number + 1
            end
        end

        if test $number -eq 0
            echo "Nothing to update."
        end
    end
end
