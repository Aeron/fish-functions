function unicode -d 'Returns a Unicode code point for a given character'
    printf 'U+%04X\n' (printf '%d' "'$argv[1]")
end
