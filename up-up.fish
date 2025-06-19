begin
    set R '🚀'
    set G '🔍'
    # set U '─'
    set U '-'

    function title_underscore -a message
        echo -n (string repeat -n (string length --visible $message) $U)
    end

    function section_title_update -a section
        set message "$R Updating $section"
        echo -se \
            (set_color $fish_color_cwd) \
            "$message\n" \
            (title_underscore $message) \
            (set_color normal)
    end

    function section_title_check -a section
        set message "$G Checking $section"
        echo -se \
            (set_color $fish_color_escape) \
            "$message\n" \
            (title_underscore $message) \
            (set_color normal)
    end

    function up-up \
        -d 'Updates macOS software, Homebrew, mise-en-place, and Python packages'

        if contains -- --all $argv
            section_title_update 'macOS software'
            soft-up
        else
            section_title_check 'macOS software'
            soft-up --check-only
        end

        echo -ne "\n"
        section_title_update 'Homebrew packages'
        brew-up
        echo -ne "\n"

        if contains -- --all $argv
            section_title_update 'mise-en-place packages'
            mise-up
        else
            section_title_check 'mise-en-place packages'
            mise-up --check-only
        end

        echo -ne "\n"
        section_title_update 'Python packages'
        pip-up
    end
end
