function vpn -a cmd name_or_index -d 'Handles existing OS X VPN services'
	set -l service_name
	set -l LIST 'list'
	set -l START 'start'
	set -l STOP 'stop'
	set -l SWITCH 'switch'
	# set -l STATUS 'status'
	set -l available_commands $LIST $START $STOP $SWITCH  # $STATUS
	set -l types_regex '(PPTP|L2TP)'
	set -l quoted_regex '\".*\"'
	set -l brackets_regex '(\(.*\)) '
	set -l prompt 'set_color blue; echo -n "Specify index or service name: "; set_color normal;'
	set -l service_status_true 'Connected'
	set -l service_status_false 'Disconnected'

	if [ -z "$cmd" ]
		set cmd $LIST
	else if not contains $cmd $available_commands
		set_color red
		echo "$_: invalid command, use $available_commands instead"
		set_color normal
		return 1
	end

	# get list of VPN names and statuses (DRY is crying, but it's better just like that)
	set -l names (scutil --nc list | grep -E $types_regex | grep -o -E $quoted_regex | sed -e "s/\"//g")
	set -l statuses (scutil --nc list | grep -E $types_regex | grep -o -E $brackets_regex | sed -e "s/[\(\)]//g")

	if [ -z "$name_or_index" -o $cmd = $LIST ]
		# show VPN list
		for i in (seq (count $names))
			echo -s $i '. ' $names[$i] ' - ' $statuses[$i]
		end

		if [ $cmd = $LIST ]
			return 0
		end

		# ask for input if not just list
		read -p $prompt name_or_index
	end

	if [ $name_or_index -eq $name_or_index ]  # small trick to check if it is a number (int only)
		if [ $name_or_index -gt (count $names) -a $name_or_index -le 0 ]
			set_color red
			echo '$_: invalid service index'
			set_color normal
			return 1
		end
		set service_name $names[$name_or_index]
	else 
		if not contains $name_or_index $names
			set_color red
			echo '$_: invalid service name'
			set_color normal
			return 1
		end
		set service_name $name_or_index
	end

	# # `list` command is informative enough to have separate `status` command
	# if [ $cmd = $STATUS ]
	# 	echo "$service_name is" (scutil --nc status "$service_name" | head -n 1 | tr "[:upper:]" "[:lower:]")
	# 	return 0
	# end

	while true
		set -l service_status (scutil --nc status "$service_name" | head -n 1)

		set_color green

		if [ $service_status = $service_status_true ]
			if [ $cmd = $START ]
				echo "$service_name: $service_status_true"
				break
			end
			if [ $cmd = $SWITCH ]
				set cmd $STOP
			end
		else if [ $service_status = $service_status_false ]
			if [ $cmd = $STOP ]
				echo "$service_name: $service_status_false"
				break
			end
			if [ $cmd = $SWITCH ]
				set cmd $START
			end
		end

		set_color normal

		sleep 0.2

		# it's ok to have it inside loop, because sometimes better to kick it twice or even more
		scutil --nc $cmd $service_name   # `stop` command not really working in Yosemite (see https://discussions.apple.com/message/27696050)
	end
 
end
