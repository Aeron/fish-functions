function up-up -d 'Updates macOS software, Homebrew, asdf, and local Python packages'
    soft-up
    brew-up

    if contains -- --all $argv
        asdf-up
    end

    pip-up
end
