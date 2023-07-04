#!/bin/bash

#zenity --question --text="Do you want to answer stupid questions?"
#var=$?
#echo $var
#if zenity --question --text="Do you want to answer stupid questions?"
#then
#    zenity --entry --text="Why?"
#fi

zenity --question --text="Do you want to answer stupid questions?"
var=$?
echo $var
if [[ $var == 0 ]]; then
	echo "Yes"
else
	echo "No"
fi
