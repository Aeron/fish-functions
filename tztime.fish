function tztime -d 'Shows current time in a given timezones'
	if test -z "$argv"
		echo -s \
			(set_color $fish_color_error) \
			"error: at least one timezone should be provided" \
			(set_color normal)

		echo "usage: $_ TZ..."
		echo "example: $_ 'UTC' 'Asia/Bangkok' 'US/Pacific' 'Europe/Moscow'"

		return 1
	end

	for tz in $argv
		set -x TZ $tz
		echo -n (date -j +%H:%M) (date -j +%Z)
		set -e TZ

		if test $tz != $argv[-1]
			echo -n ' • '
		end
	end

	echo
end
