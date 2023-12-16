function source-posix -a file \
    -d 'Exports variables from a POSIX-compatible environment file'

    for line in (cat $file)
        if string match -q -re '^\#.*$' $line
            continue
        end

        set line (string split -m1 '=' (string split -r -m1 '#' $line)[1])

        # TODO: do we always need an explicit value?
        if test -n "$line[1]" -a -n "$line[2]"
            if contains -- -v $argv
                echo $line
            end

            set -gx $line[1] $line[2]
        end
    end
end
