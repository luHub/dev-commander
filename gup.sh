#!/usr/bin/env bash

# Move to the directory where this script is located
cd "$(dirname "$0")" || exit 1

echo "Updating all Git repositories in $(pwd)..."
echo "----------------------------------------"

# Loop through all directories in the current folder
for dir in */; do
    # Remove the trailing slash
    dir=${dir%/}

    # Check if the directory contains a .git folder
    if [ -d "$dir/.git" ]; then
        echo "📁 Updating: $dir"
        
        # Run fetch and pull inside the directory using git -C
        git -C "$dir" fetch --all --prune
        git -C "$dir" pull
        
        echo "----------------------------------------"
    else
        echo "Skipping: $dir (not a git repository)"
        echo "----------------------------------------"
    fi
done

echo "✅ Done!"
