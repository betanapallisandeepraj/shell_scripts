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
    
    # Remove the first parameter from the string
    my_string=$(echo "$my_string" | awk '{$1=""; print $0}' | sed 's/^ //')
    my_string=$(echo "$my_string" | awk '{$1=""; print $0}' | sed 's/^ //')
    
    # Introduce a small delay to avoid overwhelming the loop (optional)
    sleep 1
done

echo "String is now empty."