#!/bin/bash
i=0
echo "" > status.txt
while true; do
    sleep 1
    start=$(date +'%s')
    ~/scp_beast.sh file.txt
    ~/scp_beast.sh file1.txt
    end=$(date +'%s')
    diff=$((end-start))
    echo "$i->$diff" >> status.txt
    ~/scp_beast.sh status.txt
    i=$((i+1))
done
