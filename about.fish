function about -d 'Shows information about this Mac'
    # NOTE: Decided to make my own logo instead of using variants from Neofetch
    # NOTE: All symbols are Braille, so there are no spaces in it
    set -l logo \
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
    set -l product (
        ioreg -rd1 -c IOPlatformDevice -k product-name \
        | rg -or '$1' 'product-name.*<"(.+)">'
    )
    set -l model (sysctl -n hw.model)
    set -l cpu (sysctl -n machdep.cpu.brand_string)
    set -l memory (math (sysctl -n hw.memsize) / 1024^3) 'GB'

    # model can be found here as well
    set -l serial (
        ioreg -rd1 -c IOPlatformExpertDevice -k IOPlatformSerialNumber \
        | rg -or '$1' 'IOPlatformSerialNumber.*"(.*)"'
    )
    set -l os (sw_vers | rg -o '[\w\d.]+$')
    set -l codename (
        head -n30 '/Library/Documentation/License.lpdf/Contents/Resources/English.lproj/License.html' \
        | rg -or '$1' 'macOS ([\w\s]+)<'
    )
    set -l display (
        system_profiler SPDisplaysDataType \
        | rg -or '$2' '(Display Type|Resolution): (.*)$'
    )

    set -l display[1] (string trim (string replace -ira 'built-in|display' '' $display[1]))
    set -l display[2] (string trim (string replace -ia 'retina' '' $display[2]))

    set -l info \
        "$(whoami)@$(hostname -s)" \
        "Host: $product" \
        "Model: $model" \
        "Chip: $cpu" \
        "Memory: $memory" \
        "Serial: $serial" \
        "$os[1]: $codename $os[2] ($os[3])" \
        "Display: $display[1] ($display[2])"

    set -l logo_colored
    set -l logo_line 1

    # NOTE: 8-bit (xterm-256color) compatible logo colors
    for color in '5faf5f' '5faf5f' '5faf5f' 'ffaf00' 'ff8700' 'd75f5f' '875f87' '00afd7'
        set -a logo_colored (echo -s (set_color $color) $logo[$logo_line] (set_color normal))
        set -l logo_line (math $logo_line + 1)
    end

    set -l info_line 1

    for line in $info
        echo -e $logo_colored[$info_line] $info[$info_line]
        set -l info_line (math $info_line + 1)
    end

    set -l term_colors
    set -l term_colors_bright
    set -l term_colors_block '   ' # simply three spaces and no Unicode symbols
    set -l term_colors_block_length (string length --visible $term_colors_block)
    set -l term_colors_padding (math "$logo_length + $(count $logo_colored) * $term_colors_block_length + 1")

    for color in 'black' 'red' 'green' 'yellow' 'blue' 'magenta' 'cyan' 'white'
        set -a term_colors (echo -s (set_color --background $color) $term_colors_block (set_color normal))
        set -a term_colors_bright (echo -s (set_color --background br$color) $term_colors_block (set_color normal))
    end

    echo
    string pad --width $term_colors_padding (echo -s $term_colors) (echo -s $term_colors_bright)
end
