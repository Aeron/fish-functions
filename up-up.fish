function up-up -d 'Updates macOS software, Homebrew, asdf, and local Python packages'
    echo -s (set_color green) "Updating macOS software" (set_color normal)
    soft-up

    echo -se (set_color green) "\nUpdating Homebrew packages" (set_color normal)
    brew-up

    if contains -- --all $argv
        echo -se (set_color green) "\nUpdating ASDF packages" (set_color normal)
        asdf-up
    end

    echo -se (set_color green) "\nUpdating Python packages" (set_color normal)
    pip-up
end
