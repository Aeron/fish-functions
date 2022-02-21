#
# Aeron theme for Fish.
# Inspired by Kenneth Reitz’ original theme for Oh-my-ZSH.
#
# Author: Eugene “Aeron” Glybin <aeron@aeron.cc>
#
# Comment: Not using it much because of Starship <https://starship.rs>
#

function fish_right_prompt -a return_status -d 'Writes out the right prompt'
    set -l last_status $status

    echo -sn (set_color blue) (prompt_pwd | string split -r -m1 /)[1] (set_color normal)

    if test $last_status -ne 0
        echo -s (set_color red) " $last_status" (set_color normal)
    end
end
