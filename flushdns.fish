function flushdns -d "Flushes macOS's DNS cache"
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
end
