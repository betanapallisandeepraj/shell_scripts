#!/bin/bash
abc() {
	echo "Starting of $FUNCNAME"
	echo $0
	echo $1
	echo $2
	for x in $(seq $1 $2); do
		echo $x
	done
}
abc 1 2
