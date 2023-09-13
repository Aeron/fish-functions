function date-iso -d "Displays the current date in ISO8601"
    # For +%Y-%m-%dT%T.%N%z format, BSD systems do not support %N yet
    command date +%Y-%m-%dT%T%z
end
