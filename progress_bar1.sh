#!/bin/bash

# Function to display the progress bar
function show_progress() {
    local progress=$1
    local total=$2
    local bar_length=20

    # Calculate the percentage completion
    local percentage=$((progress * 100 / total))

    # Calculate the number of filled and empty slots in the progress bar
    local filled_slots=$((percentage * bar_length / 100))
    local empty_slots=$((bar_length - filled_slots))

    # Create the progress bar string
    local bar="["
    for ((i=0; i<filled_slots; i++)); do
        bar+="="
    done
    for ((i=0; i<empty_slots; i++)); do
        bar+=" "
    done
    bar+="]"

    # Print the progress bar
    echo -ne "Progress: $bar $percentage%\r"
}

# Example usage
total_steps=50

echo "Starting the task..."

for ((step=1; step<=total_steps; step++)); do
    # Perform the task for each step

    # Update and display the progress bar
    show_progress $step $total_steps

    # Simulate a delay to see the progress
    sleep 0.1
done

echo -e "\nTask completed!"
echo 123
show_progress 5 50
echo kjfjs
show_progress 100 200
echo skjf
show_progress 34 60
echo sjfjk
