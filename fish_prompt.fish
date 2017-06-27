#
# Aeron theme for Fish.
# Based on Kenneth Reitz’ original theme for Oh-my-ZSH.
#
# Author: Eugene “Aeron” Glybin <aeron@aeron.cc>
#

function fish_prompt -d 'Write out the prompt'
	if not set -q -g __fish_aeron_functions_defined
		set -g __fish_aeron_functions_defined

		function _git_branch_name
			echo (git symbolic-ref --short HEAD ^ /dev/null)  # fastest way, redirecting errors
		end

		function _is_git_dirty
			echo (git status -suno ^ /dev/null)  # fastest way, redirecting errors
		end
	end

	if [ -n "$VIRTUAL_ENV" -a -n "$VIRTUAL_ENV_DISABLE_PROMPT" ]
		set_color magenta
	else
		set_color green
	end

	echo -n (basename (prompt_pwd))

	if [ (_git_branch_name) ]
		echo -n (set_color normal) '' (set_color yellow; _git_branch_name)

		if [ (_is_git_dirty) ]
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

	set_color blue
	echo (prompt_pwd | string split -r -m1 /)[1]
	set_color normal

	if [ $last_status -ne 0 ]
		set_color red
		printf ' %d' $last_status
		set_color normal
	end
end

function fish_title -d 'Write out tab or window title'
	switch $_
		case 'fish'
			if [ $status -gt 0 ]
				# echo -n '\u26A0\uFE0F'
				# but `echo` has known issue (see https://github.com/fish-shell/fish-shell/issues/1894)
				# closed but still, using printf instead
				printf '\u26A0\uFE0F'  # warning sign emoji (not just warning sign)
			end
			printf '\U1F41F'  # fish emoji
		case '*'
			echo $_
	end
end
