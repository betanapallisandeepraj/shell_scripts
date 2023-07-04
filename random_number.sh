#!/bin/bash
array=("file1.sdf" "file2" "3" "4")

size=${#array[@]}
index=$(($RANDOM % $size))
echo ${array[$index]}
