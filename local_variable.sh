#!/bin/bash
fun() {
	abc=$(date +%s)
	sleep 1
	local bcd=$(date +%s)
	echo "fun:$abc,$bcd"
}
fun
echo "$abc,$bcd"
