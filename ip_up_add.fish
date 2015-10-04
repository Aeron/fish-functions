function ip_up_add -a subnet comment -d 'Adds subnet for selective VPN'
	set -l cidr_regex '\b(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9]))\b\/\b([0-9]|[12][0-9]|3[0-2])\b'

	if not echo $subnet | grep -q -E $cidr_regex
		if not [ -z $subnet ]  # because somehow [ -n $subnet ] is always true (fish 2.1.2)
			set_color red
			echo "$_: subnet value should match CIDR notation (e.g. 127.0.0.1/23)"
			set_color normal
		end
		echo "usage: $_ <subnet> [<comment>]"
		return 1
	end

	set -l string "/sbin/route add -net $subnet -interface \$1"
	if [ -n $comment ]
		set string $string " # $comment"
	end
	set -l path /etc/ppp/ip-up

	if [ -e $path ]
		sudo fish -c "echo '$string' >> $path"  # because redirect need to be root too
		if [ $status -eq 0 ]
			set_color green
			echo "Subnet $subnet added to $path."
			set_color normal
		end
	else
		set_color red
		echo "$path does not exist."
		set_color normal
		return 1
	end

end
