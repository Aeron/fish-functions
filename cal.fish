function cal -d 'Handy cal wrapper'
	if test -z "$argv"
		command cal | grep \
			--before-context 6 \
			--after-context 6 \
			--color -e '\ '(date +%e)'\ '
	else
		command cal $argv
	end
end
