function curltime -a url -d "Measures request time"
	set -l time (command curl -w '%{time_total}' -o /dev/null -s $url | string replace -a '0,' '')
end
