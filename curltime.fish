function curltime -a url -d "Measures request time via cURL request"
	if test -z "$url"
		echo -s (set_color $fish_color_error) 'URL is required' (set_color normal)
		return 1
	end

	set time (command curl -w '%{time_total}' -o /dev/null -s "$url" | string replace ',' '.')

	echo -s (math -s3 "$time * 1000" | string split '.')[1] 'ms'
end
