#
# Aeron theme for Fish.
# Based on Kenneth Reitz’ original theme for Oh-my-ZSH.
#
# Author: Eugene “Aeron” Glybin <aeron@aeron.cc>
#

function fish_prompt -d 'Write out the prompt'
	if test -n "$VIRTUAL_ENV" -a -n "$VIRTUAL_ENV_DISABLE_PROMPT"
		set_color magenta
	else
		set_color green
	end

	echo -n (basename (prompt_pwd))

	if test -d .git
		echo -n (set_color normal) '' (set_color yellow; git symbolic-ref --short HEAD ^ /dev/null)  # fastest way

		if test (git status -suno ^ /dev/null)  # fastest way
			echo -n (set_color brred) '±'
		end
	end

	if set -q SUDO_USER
		echo -n (set_color brred) '⚡'
	end

	echo -n (set_color red) '❯' (set_color normal)
end

function fish_right_prompt -a return_status -d 'Write out the right prompt'
	set -l last_status $status

	echo -sn (set_color blue) (prompt_pwd | string split -r -m1 /)[1] (set_color normal)

	if [ $last_status -ne 0 ]
		echo -s (set_color red) " $last_status" (set_color normal)
	end
end

function fish_title -d 'Write out tab or window title'
	switch $_
		case 'fish'
			if [ $status -gt 0 ]
				# echo -n '\u26A0\uFE0F'  # fish's echo doesn't work with UCS-2 subset's pairs
				echo -nse '\xE2\x9A\xA0\xEF\xB8\x8F'  # but byte set of hex values is fine
			end
			# echo -n '\U1F41F'  # fish's echo doesn't work with 32-bit Unicode characters
			echo -nse '\xF0\x9F\x90\x9F'  # but byte set of hex values is fine
		case '*'
			echo "$_"
	end
end
