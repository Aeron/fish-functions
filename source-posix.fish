function source-posix -a file -d "Exports variables from a POSIX-compatible environment file"
	set sep_comment '#'
	set sep_value '='

	for line in (cat $file)
		set line (string split -m1 $sep_value (string split -r -m1 $sep_comment $line)[1])

		if test -n "$line[1]" -a -n "$line[2]"
			if contains -- -v $argv
				echo $line
			end

			set -gx $line[1] $line[2]
		end
	end
end
