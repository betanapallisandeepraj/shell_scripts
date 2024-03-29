#!/bin/bash

# Array pretending to be a Pythonic dictionary
ARRAY=("cow:moo"
    "dinosaur:roar"
    "bird:chirp"
    "bash:rock")

for animal in "${ARRAY[@]}"; do
    KEY="${animal%%:*}"
    VALUE="${animal##*:}"
    printf "%s likes to %s.\n" "$KEY" "$VALUE"
done

printf "%s is an extinct animal which likes to %s\n" "${ARRAY[1]%%:*}" "${ARRAY[1]##*:}"

for i in $(seq 0 3); do
    echo "key=${ARRAY[$i]%%:*},value=${ARRAY[$i]##*:}"
    sleep 1
done

echo "value=${ARRAY["cow"]##*:}"