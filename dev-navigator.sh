#!/bin/zsh

cn='\033[0m'
cg='\033[1;49;32m'
cb='\033[1;34m'
cy='\033[1;33m'
cr='\033[1;31m'

# Enable native zsh tab-completion for interactive prompts
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select

create_header() {
    echo
    echo -e "${cg}--------------------- $1 -------------------${cn}"
    echo
}

open_in_new_terminal() {
    local target="$1"
    local abs_path="${target:A}"
    
    # Escape single quotes for AppleScript safety
    local escaped_path="${abs_path//\'/\'\\\'\'}"

    if [[ -d "$abs_path" ]]; then
        osascript -e "tell application \"Terminal\" to do script \"cd '$escaped_path'\"" > /dev/null
    else
        osascript -e "tell application \"Terminal\" to do script \"vim '$escaped_path'\"" > /dev/null
    fi
}

browse_files() {
    local filter=""
    local limit=100

    while true; do
        clear
        create_header "Direct File Navigator"
        echo -e " Base Path: ${cy}$(pwd)${cn}"
        if [[ -n "$filter" ]]; then
            echo -e " Filter: ${cb}*${filter}*${cn}"
        fi
        echo
        echo -e " Options: ${cg}[number]${cn} Open file | ${cg}f${cn}: Filter | ${cg}d${cn}: Change dir | ${cg}o${cn}: Open dir | ${cg}c${cn}: Clear | ${cg}q${cn}: Exit"
        echo " ----------------------------------------------------------------------"

        local files=()
        local index=1
        local ask_more=true
        local clean_path dir_part base_part

        # Collect paths safely into a zsh array
        local all_paths=("${(@f)$(find . -type f -not -path '*/.git/*' -not -path '*/node_modules/*' | sort)}")

        for filepath in "${all_paths[@]}"; do
            [[ -z "$filepath" ]] && continue
            clean_path="${filepath#./}"

            # Case-insensitive literal substring filter
            if [[ -n "$filter" ]]; then
                if [[ "${clean_path:l}" != *"${filter:l}"* ]]; then
                    continue
                fi
            fi

            # Pause and ask when reaching the 100-file threshold
            if (( index > limit )) && [[ "$ask_more" == true ]]; then
                echo
                echo -e " ${cy}Reached $limit files.${cn}"
                read -r "cont_opt? Continue scanning all remaining files? (y/n): "
                echo
                if [[ "$cont_opt" =~ ^[Yy]$ ]]; then
                    ask_more=false
                else
                    echo -e " ${cr}Stopped at $limit files. Use 'f' to filter down.${cn}"
                    break
                fi
            fi

            files+=("$clean_path")
            dir_part=$(dirname "$clean_path")
            base_part=$(basename "$clean_path")

            if [[ "$dir_part" == "." ]]; then
                echo -e " ${cg}$index)${cn} $base_part"
            else
                echo -e " ${cg}$index)${cn} ${cb}${dir_part}/${cn}${base_part}"
            fi

            ((index++))
        done

        if (( ${#files[@]} == 0 )); then
            echo " (No matching files found)"
        fi

        echo
        read -r "opt? >>> " || exit 0

        if [[ "$opt" == "q" ]]; then
            clear
            exit 0
        elif [[ "$opt" == "f" ]]; then
            echo
            local input_filter="$filter"
            vared -p " Filter path (press Tab to autocomplete): " input_filter
            input_filter="${input_filter#./}"
            filter="${input_filter%/}"
        elif [[ "$opt" == "d" ]]; then
            echo
            local target_dir=""
            vared -p " Change directory (press Tab to autocomplete): " target_dir
            if [[ -n "$target_dir" && -d "$target_dir" ]]; then
                cd "$target_dir" || true
                filter=""
            else
                echo -e " ${cr}Directory not found.${cn}"
                sleep 1
            fi
        elif [[ "$opt" == "o" ]]; then
            echo
            # Pre-fill with active filter if it is a valid directory, or its parent directory if it is a file
            local default_dir="."
            if [[ -n "$filter" ]]; then
                if [[ -d "$filter" ]]; then
                    default_dir="$filter"
                elif [[ -e "$filter" ]]; then
                    default_dir=$(dirname "$filter")
                fi
            fi

            local open_dir="$default_dir"
            vared -p " Open directory in new Terminal (Tab to autocomplete, Enter to confirm): " open_dir
            open_dir="${open_dir:-$default_dir}"

            if [[ -d "$open_dir" ]]; then
                echo -e "\n ${cg}Opening ${open_dir:A} in a new Terminal window...${cn}"
                open_in_new_terminal "$open_dir"
                sleep 1
            else
                echo -e " ${cr}Directory not found.${cn}"
                sleep 1
            fi
        elif [[ "$opt" == "c" ]]; then
            filter=""
        elif [[ "$opt" =~ ^[0-9]+$ ]] && (( opt >= 1 && opt <= ${#files[@]} )); then
            local selected="${files[$opt]}"
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
if [[ -n "$1" && -d "$1" ]]; then
    cd "$1" || exit 1
fi

browse_files
