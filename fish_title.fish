function fish_title -d 'Writes out tab or window title'
    set original_status $status
    set pwd (basename (prompt_pwd))

    if test $_ = 'fish'
        if test $original_status -gt 0
            echo -ns "💩 $pwd [$original_status]"
        else
            echo -ns "🐠 $pwd"
        end
    else
        echo "🚀 $_"
    end
end
