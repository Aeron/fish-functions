begin
    set name_default 'RAM Disk'
    set size_default '2G'

    # Accepts sizes like 512M, 1G, or plain bytes. Returns number of 512-byte sectors.
    function _size_to_sectors -a size
        if string match -qr '^[0-9]+[Kk]$' -- $size
            math (string replace -r '([0-9]+)[Kk]' '$1' $size) "* 1024 / 512"
        else if string match -qr '^[0-9]+[Mm]$' -- $size
            math (string replace -r '([0-9]+)[Mm]' '$1' $size) "* 1024 * 1024 / 512"
        else if string match -qr '^[0-9]+[Gg]$' -- $size
            set -l n (string replace -r '([0-9]+)[Gg]' '$1' $size)
            math (string replace -r '([0-9]+)[Gg]' '$1' $size) "* 1024 * 1024 * 1024 / 512"
        else if string match -qr '^[0-9]+$' -- $size
            math "$size / 512"
        else
            echo -s \
                (set_color $fish_color_error) \
                "error: invalid size ($size)" \
                (set_color normal)
            return 1
        end
    end

    function _create -a size name
        if test -z "$size" -o -z "$name"
            echo -s \
                (set_color $fish_color_error) \
                "error: invalid size or name parameter" \
                (set_color normal)
            return 1
        end

        # Converting size to sector number
        set sectors (_size_to_sectors $size)
        if test -z "$sectors" -o "$sectors" -le 0
            echo -s \
                (set_color $fish_color_error) \
                "error: cannot compute sectors for size ($size)" \
                (set_color normal)
            return 1
        end

        # Creating RAM-backed device (disk)
        set dev (string trim (hdiutil attach -nomount ram://$sectors))
        if test -z "$dev"
            echo -s \
                (set_color $fish_color_error) \
                "error: cannot create RAM device" \
                (set_color normal)
            return 1
        end

        # Formatting the disk as APFS and mounting it
        if not diskutil eraseDisk apfs "$name" $dev &>/dev/null
            echo -s \
                (set_color $fish_color_error) \
                "error: cannot format/mount RAM disk as APFS" \
                (set_color normal)

            # Detaching if partially attached
            if test -n "$dev"
                hdiutil detach $dev &>/dev/null
            end

            return 1
        end

        echo "Mounted RAM disk ($dev) at /Volumes/$name"
    end

    function _remove -a target
        if test -z "$target"
            echo -s \
                (set_color $fish_color_error) \
                "error: invalid target parameter" \
                (set_color normal)
            return 1
        end

        # Expanding a simple volume name into a full mounting point path
        if not string match -r '^/Volumes/' -- $target
            set target "/Volumes/$target"
        end

        # Checking whether volume mounting point exists
        if not test -d "$target"
            echo -s \
                (set_color $fish_color_error) \
                "error: volume not found: $target" \
                (set_color normal)
            return 1
        end

        # Getting a device behind the mounting point
        set dev (string trim (df -h "$target" | tail -n1 | string split -m1 " ")[1])
        if test -z "$dev"
            echo -s \
                (set_color $fish_color_error) \
                "error: cannot find device for $target" \
                (set_color normal)
            return 1
        end

        # Unmounting the device
        if not diskutil eject $dev &>/dev/null
            echo -s \
                (set_color $fish_color_error) \
                "error: cannot eject $dev" \
                (set_color normal)
            return 1
        end

        echo "Removed RAM disk ($dev) at $target"
    end

    function ramdisk -d 'Manages RAM disks'
        set -l opts (fish_opt -s s -l size --optional-val)
        argparse --ignore-unknown $opts -- $argv
        or return

        # Setting name
        set name "$argv[2]"
        if test -z "$name"
            set name "$name_default"
        end

        # Setting size
        set size "$_flag_size"
        if test -z "$size"
            set size "$size_default"
        end

        # Dispatching the command
        switch "$argv[1]"
            case create
                _create "$size" "$name"
            case remove rm
                _remove "$name"
            case '*'
                echo 'Manages RAM disks.'
                echo ''
                echo "Usage: $_ [OPTS...] [NAME]"
                echo ''
                echo 'Commands:'
                echo '  create                Creates a new RAM disk and mounts it'
                echo '  remove, rm            Unmounts an existing RAM volume and releases its device'
                echo ''
                echo 'Create Options:'
                echo "  --size=<NUM>[k|m|g]   Specifies the disk size in (kilo|mega|giga)bytes [default: $size_default]"
                echo ''
                echo 'Parameters:'
                echo "  NAME                  A target volume name [default: \"$name_default\"]"
        end
    end
end
