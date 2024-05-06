#!/bin/bash

input_dir="/home/sandeepraj/Downloads/dictionary_pics_jpg1"

find "$input_dir" -type f -name "*.DNG.jpg" | while IFS= read -r dng_file; do
    relative_path="${dng_file#$input_dir/}"
    relative_dir="$(dirname "$relative_path")"
    
    # Extract the filename without extension
    filename=$(basename -- "$dng_file")
    filename_no_ext="${filename%.*}"
    filename_no_ext1="${filename_no_ext%.*}"
    
    # Print status
    echo "
            $input_dir,
            $dng_file,
            $filename,
            $relative_path,
            $relative_dir,
            $filename_no_ext
            $filename_no_ext1"
    echo "$dng_file --> $input_dir/$relative_dir/$filename_no_ext1.jpg

    "
    mv "$dng_file" "$input_dir/$relative_dir/$filename_no_ext1.jpg"
done
