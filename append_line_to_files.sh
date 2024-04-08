#!/bin/bash

# Iterate through the files
for filename in ./*; do
    # Determine the value of hw_category based on the filename
    if [[ $filename == *-1L-X ]]; then
        hw_category="X"
    elif [[ $filename == *-2L-X ]]; then
        hw_category="X"
    elif [[ $filename == *-2L-P ]]; then
        hw_category="P"
    elif [[ $filename == *-2KM-XO ]]; then
        hw_category="XO"
    elif [[ $filename == *-2KM-XW ]]; then
        hw_category="XW"
    else
        continue
    fi

    # Append hw_category to the file
    # echo "$filename --> $hw_category"
    echo "hw_category=\"$hw_category\"" >> "$filename"
done
