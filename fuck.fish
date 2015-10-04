function fuck -a cmd -d 'Corrects your previous command'
	if [ -z "$cmd" ]
		set cmd $history[1]
	end

	thefuck $cmd | read -z correct_cmd

	if [ -n "$correct_cmd" ]
		# Extra arguments support
		set -l cmd_args_count (count $argv)
		if [ $cmd_args_count -gt 1 ]
			set -l cmd_args $argv[2..$cmd_args_count]
		end

		# Executing correct command
		eval $correct_cmd $cmd_args

		# Cleaning history
		if [ $status -eq 0 ]
			history --delete $cmd
		end
	end
end
