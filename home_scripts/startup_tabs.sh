#!/bin/bash

show_sleep() {
    secs=$(($1))
    while [ $secs -gt 0 ]; do
        echo -ne "$secs\033[0K\r"
        sleep 1
        : $((secs--))
    done
}
ping_both_targets()
{
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
}
ping_both_targets

# USAGE:
# open_tab <tab name> <command to execute after opening the tab>
open_tab()
{
    gnome-terminal --tab --title=$1 --working-directory="/home/sandeepraj" -- bash -c "echo '$1 terminal opened';bash"
    window_id=$(xdotool search --name $1)
    xdotool windowactivate --sync "$window_id"
    xdotool type --delay 50 "$2"
    xdotool key Return
}

open_tab "target1" "ssh_target1"
open_tab "target2" "ssh_target2"
open_tab "lede" "goto_lede"
open_tab "lede_binary" "goto_lede;cd bin/targets/ar71xx/generic"
open_tab "luci" "goto_lede;cd ../luci"
