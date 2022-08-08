#!/bin/bash
fun() {
	abc=$(date +%s)
	sleep 1
	local bcd=$(date +%s) cd=9
	echo "fun:$abc,$bcd"
	echo "cd=$cd"
}
fun
echo "$abc,$bcd"
echo "cd=$cd"
