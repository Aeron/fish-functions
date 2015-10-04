function fake_smtp -a port -d 'Runs fake SMTP server'
	set -l host 127.0.0.1
	if [ -z $port ]
		set port 25
	end

	set_color yellow
	echo "Starting fake SMTP on $host:$port"
	set_color normal

	set -l cmd "python -m smtpd -n -c DebuggingServer $host:$port"

	if [ $port -le 1024 ]  # only root should bind below 1024th port
		set cmd 'sudo' $cmd
	end

	eval $cmd
end
