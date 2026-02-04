#!/bin/bash

prompt=""
if [ ! -f "./home/BOOTSTRAP.md" ]; then
    prompt="$1"
fi

merged_variable=""

for file in ./home/*; do
    if [ -f "$file" ]; then
        merged_variable+="$(cat "$file")"$'\n'
    fi
done

opencode run "$merged_variable $prompt"
