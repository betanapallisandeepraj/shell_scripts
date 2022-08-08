#!/bin/bash
# Validating number of helix devices connected
if [[ $1 == "1" ]] || [[ $1 == "2" ]]; then
   echo "Got $1, I hope $1 helix device must have connected for calibration."
   numPorts=$(($1))
else
   var=$(zenity --entry --title "Helix connected count" --text "Please enter number of helix devices connceted for calibration.\nExample: 1 or 2")
   if [[ $var == "1" ]] || [[ $var == "2" ]]; then
      numPorts=$(($var))
   else
      # echo "Enter correct input. Valid inputs are 1 or 2."
      # exit 0
      echo "I didn't get valid information. So setting number of ports connected as $maxPorts"
      numPorts=$maxPorts
   fi
fi
echo "numPorts=$numPorts"
