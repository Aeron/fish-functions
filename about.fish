function about -d 'Shows information about this Mac'
    # NOTE: Decided to make my own logo instead of using variants from Neofetch
    # NOTE: All symbols are Braille, so there are no spaces in it
    set logo \
        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⡟⠀⠀⠀⠀⠀' \
        '⠀⠀⠀⠀⠀⠀⠀⠀⣼⡿⠋⠀⠀⠀⠀⠀⠀' \
        '⠀⠀⢀⣾⣿⣿⣿⣷⣶⣾⣿⣿⣿⣿⣦⠀⠀' \
        '⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀' \
        '⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀' \
        '⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀' \
        '⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀' \
        '⠀⠀⠀⠈⠻⣿⣿⡿⠿⢿⣿⣿⣿⡿⠁⠀⠀'

    set logo_length (string length --visible $logo[-1])

    # CPU can be found here as well
    set product (
        ioreg -rd1 -c IOPlatformDevice -k product-name \
        | rg -or '$1' 'product-name.*<"(.+)">'
    )
    set model (sysctl -n hw.model)
    set cpu (sysctl -n machdep.cpu.brand_string)
    set memory (math (sysctl -n hw.memsize) / 1024^3) 'GB'

    # model can be found here as well
    set serial (
        ioreg -rd1 -c IOPlatformExpertDevice -k IOPlatformSerialNumber \
        | rg -or '$1' 'IOPlatformSerialNumber.*"(.*)"'
    )
    set os (sw_vers | rg -o '[\w\d.]+$')
    set codename (
        head -n30 '/Library/Documentation/License.lpdf/Contents/Resources/English.lproj/License.html' \
        | rg -or '$1' 'macOS ([\w\s]+)<'
    )
    set display (
        system_profiler SPDisplaysDataType \
        | rg -or '$2' '(Display Type|Resolution): (.*)$'
    )

    set display[1] (string trim (string replace -ira 'built-in|display' '' $display[1]))
    set display[2] (string trim (string replace -ia 'retina' '' $display[2]))

    set info \
        "$(whoami)@$(hostname -s)" \
        "Host: $product" \
        "Model: $model" \
        "Chip: $cpu" \
        "Memory: $memory" \
        "Serial: $serial" \
        "$os[1]: $codename $os[2] ($os[3])" \
        "Display: $display[1] ($display[2])"

    set logo_colored
    set logo_line 1

    # NOTE: 8-bit (xterm-256color) compatible logo colors
    for color in '5faf5f' '5faf5f' '5faf5f' 'ffaf00' 'ff8700' 'd75f5f' '875f87' '00afd7'
        set -a logo_colored \
            (echo -s (set_color $color) $logo[$logo_line] (set_color normal))
        set logo_line (math $logo_line + 1)
    end

    set info_line 1

    for line in $info
        echo -e $logo_colored[$info_line] $info[$info_line]
        set info_line (math $info_line + 1)
    end

    echo

    set term (string replace '_' ' ' (string replace '.app' '' $TERM_PROGRAM))
    set shell (path basename $SHELL)

    set term_info \
        "Shell: $shell" \
        "Terminal: $term ($TERM)"

    for line in $term_info
        string pad --width (math $logo_length + (string length --visible $line) + 1) \
            $line
    end

    set term_colors
    set term_colors_bright
    set term_colors_block '   ' # simply three spaces and no Unicode symbols
    set term_colors_block_length (string length --visible $term_colors_block)

    for color in 'black' 'red' 'green' 'yellow' 'blue' 'magenta' 'cyan' 'white'
        set -a term_colors \
            (echo -s (set_color --background $color) \
            $term_colors_block \
            (set_color normal))
        set -a term_colors_bright \
            (echo -s (set_color --background br$color) \
            $term_colors_block \
            (set_color normal))
    end

    set term_colors (echo -s $term_colors)
    set term_colors_bright (echo -s $term_colors_bright)

    set term_colors_padding (
        math $logo_length + $(string length --visible $term_colors) + 1
    )

    string pad --width $term_colors_padding \
        $term_colors \
        $term_colors_bright
end
