#!/bin/bash
while IFS= read -r line; do
	file_line=$line
	echo "${LINENO}:$file_line"	
done < "/tmp/abc"
