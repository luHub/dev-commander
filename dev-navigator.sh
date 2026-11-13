#!/bin/bash

cn='\033[0m'
cg='\033[1;49;32m'
cb='\033[1;34m'
cy='\033[1;33m'
cr='\033[1;31m'

function create_header {
    echo
    echo -e "${cg}--------------------- $1 -------------------${cn}"
    echo
}

function open_in_new_terminal {
    local target_file="$1"
    local abs_path
    abs_path="$(cd "$(dirname "$target_file")" && pwd)/$(basename "$target_file")"
    
    # Escape single quotes for AppleScript safety
    local escaped_path="${abs_path//\'/\'\\\'\'}"
    
    osascript -e "tell application \"Terminal\" to do script \"vim '$escaped_path'\"" > /dev/null
}

function browse_files {
    local filter=""
    local limit=100

    while :
    do
        clear
        create_header "Direct File Navigator"
        echo -e " Base Path: ${cy}$(pwd)${cn}"
        if [ -n "$filter" ]; then
            echo -e " Filter:    ${cb}*${filter}*${cn}"
        fi
        echo
        echo -e " Options: ${cg}[number]${cn} Open file | ${cg}f${cn}: Filter paths | ${cg}c${cn}: Clear filter | ${cg}q${cn}: Exit"
        echo " ----------------------------------------------------------------------"

        local files=()
        local index=1
        local ask_more=true

        # Read paths via FD 3 so standard input (FD 0) remains free for user prompts
        while IFS= read -r filepath <&3; do
            clean_path="${filepath#./}"

            # Apply filter if active (case-insensitive)
            if [ -n "$filter" ]; then
                if ! echo "$clean_path" | grep -iq "$filter"; then
                    continue
                fi
            fi

            # Pause and ask when reaching the 100-file threshold
            if [ "$index" -gt "$limit" ] && [ "$ask_more" == true ]; then
                echo
                echo -e " ${cy}Reached $limit files.${cn}"
                read -p " Continue scanning all remaining files? (y/n): " cont_opt
                echo
                if [[ "$cont_opt" =~ ^[Yy]$ ]]; then
                    ask_more=false
                else
                    echo -e " ${cr}Stopped at $limit files. Use 'f' to filter down.${cn}"
                    break
                fi
            fi

            files+=("$clean_path")
            
            local dir_part
            local base_part
            dir_part=$(dirname "$clean_path")
            base_part=$(basename "$clean_path")

            if [ "$dir_part" == "." ]; then
                echo -e "  ${cg}$index)${cn} $base_part"
            else
                echo -e "  ${cg}$index)${cn} ${cb}${dir_part}/${cn}${base_part}"
            fi

            ((index++))
        done 3< <(find . -type f -not -path '*/.git/*' -not -path '*/node_modules/*' | sort)

        if [ ${#files[@]} -eq 0 ]; then
            echo "  (No matching files found)"
        fi

        echo
        read -p " >>> " opt

        if [ "$opt" == "q" ]; then
            clear
            exit 0
        elif [ "$opt" == "f" ]; then
            echo
            read -p " Enter search text to filter paths: " filter
        elif [ "$opt" == "c" ]; then
            filter=""
        elif [[ "$opt" =~ ^[0-9]+$ ]] && [ "$opt" -ge 1 ] && [ "$opt" -le "${#files[@]}" ]; then
            local selected="${files[$((opt-1))]}"
            echo -e "\n ${cg}Opening $selected in a new Terminal window...${cn}"
            open_in_new_terminal "$selected"
            sleep 1
        else
            echo -e "\n Please select a valid number or option."
            sleep 1
        fi
    done
}

# Start in the directory passed as an argument, or default to current directory
if [ -n "$1" ] && [ -d "$1" ]; then
    cd "$1" || exit 1
fi

browse_files
