#!/bin/sh

# Define a space-separated string
my_string="-e 5 -s 9"

# Print the original string
echo "Original String: $my_string"

# Loop until the string becomes empty
while [ -n "$my_string" ]; do
    # Get the first parameter (word) from the string
    first_param=$(echo "$my_string" | awk '{print $1}')
    second_param=$(echo "$my_string" | awk '{print $2}')
    
    # Print the first parameter
    echo "First Parameter: $first_param"
    echo "Second Parameter: $second_param"
    
    # Introduce a small delay to avoid overwhelming the loop (optional)
    sleep 1
    case $first_param in
        -e|--name) abc="$second_param"
            my_string=$(echo "$my_string" | awk '{$1=""; print $0}' | sed 's/^ //')
            my_string=$(echo "$my_string" | awk '{$1=""; print $0}' | sed 's/^ //')
        ;;
        -s|--name_non_fes) bcd="$second_param"
            my_string=$(echo "$my_string" | awk '{$1=""; print $0}' | sed 's/^ //')
            my_string=$(echo "$my_string" | awk '{$1=""; print $0}' | sed 's/^ //')
        ;;
        *) echo "Invalid option -$second_param" >&2
            my_string=$(echo "$my_string" | awk '{$1=""; print $0}' | sed 's/^ //')
            my_string=$(echo "$my_string" | awk '{$1=""; print $0}' | sed 's/^ //')
        ;;
    esac
done

echo "String is now empty."
echo "$abc,$bcd"