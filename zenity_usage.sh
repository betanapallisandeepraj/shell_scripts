#!/bin/bash

var=$(zenity --calendar)
echo $var
var=$(zenity --entry --title "Name request" --text "Please enter your name:")
echo $var
var=$(zenity --file-selection --multiple --filename "${HOME}/")
echo $var
var=$(zenity --file-selection --save --confirm-overwrite --filename "${HOME}/")
echo $var

#
# Below Dummy script to demonstrate the zenity progress widget!

var= $( (
  echo 25
  echo "# Setting up..."
  sleep 2

  echo 30
  echo "# Reading files..."
  sleep 2

  echo 70
  echo "# Creating content..."
  sleep 1

  echo 100
  echo "# Done!"
) | zenity --title "Progress bar example" --progress --auto-kill)
echo $var

var=$(zenity --info --width=400 --height=200 --text "This is a notification!")
echo $var
var=$(zenity --info --width=400 --height=200 --text "$(date)\nThis is a notification!")
echo $var
var=$(zenity --info --timeout 3 --width=400 --height=200 --text "This is a notification!")
echo $var
var=$(zenity --warning --width=400 --height=200 --text "This is a warning!")
echo $var
var=$(zenity --error --width=400 --height=200 --text "This is an error!")
echo $var
#var=$(zenity --question --text "Are you sure you want to quit?" --no-wrap --ok-label "Yes" --cancel-label "No")
#echo $var
zenity --question --text="Do you want to answer stupid questions?"
var=$?
if [[ $var == 0 ]]; then
  echo "Yes"
else
  echo "No"
fi

var=$(zenity --password --username)
case $? in
0)
  echo "User Name: $(echo $var | cut -d'|' -f1)"
  echo "Password : $(echo $var | cut -d'|' -f2)"
  ;;
1)
  echo "Stop login."
  ;;
-1)
  echo "An unexpected error has occurred."
  ;;
esac
echo $var

var=$(zenity --color-selection --color red --show-palette)
echo $var
var=$(zenity --list --column Selection --column Distribution 1 Debian 2 Fedora 3 Ubuntu)
echo $var
var=$()
echo $var
var=$()
echo $var
var=$()
echo $var
var=$()
echo $var
