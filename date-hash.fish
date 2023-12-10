function date-hash -d 'Displays current timestamp hash'
    printf '%x\n' (command date '+%s')
end
