#!/bin/bash
# Declare arrays
var1=("apple" "banana" "cherry")
var2=("dog" "cat" "bird" "fish")
var3=("red" "green" "blue" "yellow" "orange")

# Create an array of variable names
variable_list=("var1" "var2" "var3")

# Loop through the variable list
for var_name in "${variable_list[@]}"; do
    # Use variable indirection to get the array elements
    array_name="$var_name[@]"
    array=("${!array_name}")
    echo "Elements of $var_name:"
    for element in "${array[@]}"; do
        echo "$element"
    done
    echo
done
