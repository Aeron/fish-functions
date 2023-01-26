function asdf-prune -d "Removes older asdf plugin versions"
    if contains -- -f $argv
        set force 'y'
    end

    for current in (asdf current)
        set current (string split -n -f1,2 " " $current)
        set current_plugin $current[1]
        set current_version $current[2]

        set older_versions (string trim --chars=' *' (asdf list $current_plugin))
        set -e older_versions[(contains -i $current_version $older_versions)]

        for older_version in $older_versions
            echo -s "Found an older version for " $current_plugin ": " $older_version

            set confirm $force

            if test -z $confirm
                read -P 'Do you want to prune it? [y/N] ' confirm
            end

            if string match -q -i 'y' $confirm
                asdf uninstall $current_plugin $older_version
                and echo "Successfully removed" $current_plugin $older_version
            end
        end
    end
end
