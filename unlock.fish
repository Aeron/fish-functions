function unlock -a path -d "Disables macOS Gatekeeper for a specified application"
	if test -d $path
		sudo xattr -rd com.apple.quarantine $path
	else
		echo -s (set_color $fish_color_error) "Application $path not found" (set_color normal)
		return 1
	end
end
