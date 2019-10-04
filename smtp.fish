function smtp -a port -d 'Runs a fake (Python) SMTP server'
	set host 127.0.0.1

	if [ -z $port ]
		set port 25
	end

	echo -n (set_color yellow) "Starting fake SMTP on $host:$port" (set_color normal)

	set cmd "python -m smtpd -n -c DebuggingServer $host:$port"

	if test $port -le 1024  # only root should bind below 1024th port
		set cmd 'sudo' $cmd
	end

	eval $cmd
end
