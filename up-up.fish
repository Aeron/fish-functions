function up-up -d 'Updates macOS software, Homebrew, asdf, and local Python packages'
    if contains -- --all $argv  # NOTE: it is hard to cancel
        echo -s (set_color green) "Updating macOS software" (set_color normal)
        soft-up
    else
        echo -s (set_color cyan) "Skipping macOS software" (set_color normal)
    end

    echo -se (set_color green) "Updating Homebrew packages" (set_color normal)
    brew-up

    if contains -- --all $argv  # NOTE: it is not always needed
        echo -se (set_color green) "Updating ASDF packages" (set_color normal)
        asdf-up
    else
        echo -se (set_color cyan) "Skipping ASDF packages" (set_color normal)
    end

    echo -se (set_color green) "Updating Python packages" (set_color normal)
    pip-up
end
