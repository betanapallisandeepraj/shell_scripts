#!/bin/bash

# Define the input and output directories
input_dir="/home/sandeepraj/Downloads/dictionary_pics_jpg"
output_dir="/home/sandeepraj/Downloads/dictionary_pics_jpg1"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop through all DNG files recursively in the input directory
find "$input_dir" -type f -name "*.DNG" | while IFS= read -r dng_file; do
    # Get the relative path of the input file
    relative_path="${dng_file#$input_dir/}"
    relative_dir="$(dirname "$relative_path")"
    
    # Create the corresponding output directory
    mkdir -p "$output_dir/$relative_dir"
    
    # Extract the filename without extension
    # filename=$(basename -- "$dng_file")
    # filename_no_ext="${filename%.*}"

    # Convert DNG to JPG using dcraw and convert
    dcraw -c -w -q 3 "$dng_file" | convert - -auto-gamma -contrast-stretch 0 -unsharp 0x1.5 -contrast -modulate 110,90 -channel RGB -fx 'u.r+u.g+u.b' -contrast-stretch 1.5% -quality 100% -level 0%,100%,1.5 "$output_dir/$relative_path.jpg"

    
    # Print status
    echo "$dng_file --> $output_dir/$relative_path.jpg"
    # echo "Converted $filename_no_ext.DNG to $output_dir/$relative_path.jpg"
done
# echo "Conversion complete."

