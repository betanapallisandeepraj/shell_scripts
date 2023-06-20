#!/bin/bash
animals=( ["moo"]="cow" ["woof"]="dog" )
echo "${animals[moo]}"
for sound in "${!animals[@]}"; do 
	echo "$sound - ${animals[$sound]}"; 
done
