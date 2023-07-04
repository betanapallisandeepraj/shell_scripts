#!/bin/bash
user=$(whoami)
if [ "$user" == "root" ]; then
	echo $user
fi
