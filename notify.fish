function notify -a message title subtitle -d "Displays OS X notification"
	if test -z "$message"
		set_color red
		echo "$_: at least message should be provided"
		set_color normal

		echo "usage: $_ <message> [<title> [<subtitle>]]"

		return 1
	end

	set -l env '/usr/bin/osascript -e' 
	set -l script "display notification \"$message\""

	if test -n "$title"
		set script $script "with title \"$title\""
		if test -n "$subtitle"
			set script $script "subtitle \"$subtitle\""
		end
	end

	eval "$env '$script'"
end
