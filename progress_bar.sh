#!/bin/bash

# Function to display a progress bar
progress_bar() {
    local progress=$1
    local total=$2
    local length=30 # Length of the progress bar

    # Calculate the percentage of progress
    local percent=$((progress * 100 / total))

    # Calculate the number of progress bar characters to display
    local num_chars=$((progress * length / total))

    # Generate the progress bar string
    local bar="["
    for ((i = 0; i < num_chars; i++)); do
        bar+='='
    done
    for ((i = num_chars; i < length; i++)); do
        bar+=' '
    done
    bar+="]"

    # Print the progress bar
    echo -ne "Progress: $percent% $bar\r"
}

# Example usage
total_iterations=100

for ((i = 1; i <= total_iterations; i++)); do
    # Perform some task
    sleep 0.1

    # Update the progress bar
    progress_bar "$i" "$total_iterations"
done

echo -e "\nTask completed!"
