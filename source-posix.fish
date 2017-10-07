function source-posix -a file -d "Exports variables from POSIX-compatible environment file"
	for line in (cat $file)
		set -gx (string split -m1 '=' $line)
	end
end
