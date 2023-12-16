function flushdns -d 'Flushes a macOS DNS cache'
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
end
