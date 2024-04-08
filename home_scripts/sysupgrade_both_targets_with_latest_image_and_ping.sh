#!/bin/bash

show_sleep() {
    secs=$(($1))
    while [ $secs -gt 0 ]; do
        echo -ne "$secs\033[0K\r"
        sleep 1
        : $((secs--))
    done
}
latest_image=$(ls -lhtr | grep rwart | tail -1 | awk '{print $9}')
echo $latest_image
read -p "Do you want to proceed? (yes/no): " user_input
user_input_lc=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
if [[ "$user_input_lc" == "yes" || "$user_input_lc" == "y" ]]; then
    echo "Proceeding with image $latest_image"
else
    echo "Aborted."
    exit 0
fi
~/sysupgrade_target1.sh $latest_image
~/sysupgrade_target2.sh $latest_image
show_sleep 100
tar1_ip=$(cat ~/target1_ip.txt)
tar2_ip=$(cat ~/target2_ip.txt)
i=0
j=0
while true; do
    if [[ "$i" != "1" ]]; then
        ping -c 1 -W 0.1 $tar1_ip
        var1=$?
        echo $var1
        if [[ "$var1" == "1" ]]; then
            echo "not reachable $tar1_ip"
            show_sleep 3
        else
            i=1
            sleep 1
        fi
    fi
    if [[ "$j" != "2" ]]; then
        ping -c 1 -W 0.1 $tar2_ip
        var2=$?
        echo $var2
        if [[ "$var2" == "1" ]]; then
            echo "not reachable $tar2_ip"
            show_sleep 3
        else
            j=2
            sleep 1
        fi
    fi
    if [[ $i == "1" ]] && [[ $j == "2" ]]; then
        echo "both targets are reachable"
        ~/speak_out.sh "both targets are reachable"
        break
    fi
done
