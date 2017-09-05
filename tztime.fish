function tztime -d 'Show current time in given timezones'
	if test (count $argv) -gt 0
		for tz in $argv
			set -x TZ $tz

			echo -ns (set_color cyan) (date -j +%H:%M) (set_color yellow) \ (date -j +%Z) (set_color normal)

			set -x -e TZ

			if [ $tz != $argv[-1] ]
				echo -n ' | '
			end
		end

		return 0
	else
		echo -s (set_color red) "$_: at least one timezone should be provided" (set_color normal)

		echo "usage: $_ <timezones>"
		echo "example: $_ 'UTC' 'Asia/Bangkok' 'US/Pacific' 'Europe/Moscow'"

		return 1
	end
end
