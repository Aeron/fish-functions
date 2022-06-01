function get-my-ip -d "Displays the current IP addresses"
    echo 'IPv4:' (curl -4s ifconfig.co)
    echo 'IPv6:' (curl -6s ifconfig.co)
end
