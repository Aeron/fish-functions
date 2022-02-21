#
# Aeron theme for Fish.
# Inspired by Kenneth Reitz’ original theme for Oh-my-ZSH.
#
# Author: Eugene “Aeron” Glybin <aeron@aeron.cc>
#

function fish_prompt -d 'Writes out the prompt'
	set git_branch (git symbolic-ref --short HEAD 2> /dev/null)  # fastest way
	set git_modified (git status -suno 2> /dev/null)  # fastest way

	if test -n "$VIRTUAL_ENV" -a -n "$VIRTUAL_ENV_DISABLE_PROMPT"
		set_color magenta
	else
		set_color green
	end

	echo -n (basename (prompt_pwd))

	if test -n "$git_branch"
		echo -n (set_color normal) ''

		if test -n "$__fish_git_prompt_shorten_branch_len" \
				-a (string length $git_branch) \
				-gt $__fish_git_prompt_shorten_branch_len
			set git_branch (
				string sub --length=$__fish_git_prompt_shorten_branch_len $git_branch
			)
			set git_branch "$git_branch…"
		end

		echo -n (set_color yellow) $git_branch

		if test -n "$git_modified"
			echo -n (set_color brred) '±'
		end
	end

	if set -q SUDO_USER
		echo -n (set_color brred) '⚡'
	end

	echo -n (set_color red) '❯' (set_color normal)
end
