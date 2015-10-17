function world_time -d 'Show time in given timezones'
	if [ (count $argv) -gt 0 ]
		for tz in $argv
			set -x TZ $tz

			set_color cyan
			echo -n (date -j +%H:%M)
			set_color yellow
			echo -n \ (date -j +%Z)  # or just $tz maybe
			set_color normal

			if [ $tz != $argv[-1] ]
				echo -n ' | '
			end

			set -x -e TZ
		end

		echo
	else
		set_color red
		echo "$_: at least one timezone should be provided"
		set_color normal

		echo "usage: $_ <timezones>"

		return 1
	end
end
