function up-up -d 'Updates macOS software, Homebrew, asdf, and local Python packages'
    soft-up
    and brew-up
    and asdf-up
    and pip-up
end
