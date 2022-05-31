function date-hash -d 'Displays current timestamp hash'
    printf '%x\n' (date '+%s')
end
