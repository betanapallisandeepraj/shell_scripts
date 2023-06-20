#!/bin/bash
ssh_cmd="ssh -q -o StrictHostKeyChecking=no root@192.168.153.1"
channel_delay=3
count=0
# For 1675 helix band,
$ssh_cmd "iw phy0 fes fes_set fes_freq_shift -4156 fes_freq_bw 100 fes_freq_bw_in 100 fes_freq_bw_step 1 fes_chanbw_list \"3000 5000 10000 0 26000\" fes_min_integrated_radio_shift -131 fes_gain 16 new_freq 1675 HT20"
sleep $channel_delay
bandwidth_list="3 5 10 0 26"
for bw in $bandwidth_list; do
    echo "bandwidth=$bw"
    $ssh_cmd "echo $bw > /sys/kernel/debug/ieee80211/phy0/ath9k/chanbw"
    sleep 1
    $ssh_cmd "iw wlan0 info"
    channel_start=1
    channel_end=100
    while [ "$channel_start" -le "$channel_end" ]; do
        echo "channel=$channel_start"
        $ssh_cmd "iw wlan0 mesh chswitch $channel_start 20"
        sleep $channel_delay
        output=$($ssh_cmd "iw wlan0 info | head -7 | tail -1")
        echo -e "\t$output"
        chan=$(echo $output | awk '{print $2}')
        if [ "$chan" == "$channel_start" ]; then
            channel_start=$((channel_start + 1))
            count=0
        else
            $ssh_cmd "free -h"
            $ssh_cmd "cat /proc/meminfo"
            count=$((count + 1))
            echo "count=$count"
            sleep 1
        fi
    done
done

# For 1815 helix band
$ssh_cmd "iw phy0 fes fes_set fes_freq_shift -4281 fes_freq_bw 70 fes_freq_bw_in 70 fes_freq_bw_step 1 fes_chanbw_list \"3000 5000 10000 0 26000\" fes_min_integrated_radio_shift -116 fes_gain 16 new_freq 1815 HT20"
sleep $channel_delay
bandwidth_list="3 5 10 0 26"
for bw in $bandwidth_list; do
    echo "bandwidth=$bw"
    $ssh_cmd "echo $bw > /sys/kernel/debug/ieee80211/phy0/ath9k/chanbw"
    sleep 1
    $ssh_cmd "iw wlan0 info"
    channel_start=1
    channel_end=70
    while [ "$channel_start" -le "$channel_end" ]; do
        echo "channel=$channel_start"
        $ssh_cmd "iw wlan0 mesh chswitch $channel_start 20"
        sleep $channel_delay
        $ssh_cmd "iw wlan0 info | head -7 | tail -1"
        channel_start=$((channel_start + 1))
    done
done

# For 2065 helix band
$ssh_cmd "iw phy0 fes fes_set fes_freq_shift -4541 fes_freq_bw 85 fes_freq_bw_in 85 fes_freq_bw_step 1 fes_chanbw_list \"3000 5000 10000 0 26000\" fes_min_integrated_radio_shift -123 fes_gain 16 new_freq 2065 HT20"
sleep $channel_delay
bandwidth_list="3 5 10 0 26"
for bw in $bandwidth_list; do
    echo "bandwidth=$bw"
    $ssh_cmd "echo $bw > /sys/kernel/debug/ieee80211/phy0/ath9k/chanbw"
    sleep 1
    $ssh_cmd "iw wlan0 info"
    channel_start=1
    channel_end=70
    while [ "$channel_start" -le "$channel_end" ]; do
        echo "channel=$channel_start"
        $ssh_cmd "iw wlan0 mesh chswitch $channel_start 20"
        sleep $channel_delay
        $ssh_cmd "iw wlan0 info | head -7 | tail -1"
        channel_start=$((channel_start + 1))
    done
done

# For 2245 helix band
$ssh_cmd "iw phy0 fes fes_set fes_freq_shift -231 fes_freq_bw 90 fes_freq_bw_in 90 fes_freq_bw_step 1 fes_chanbw_list \"3000 5000 10000 0 26000\" fes_min_integrated_radio_shift -231 fes_gain 16 new_freq 2245 HT20"
sleep $channel_delay
bandwidth_list="3 5 10 0 26"
for bw in $bandwidth_list; do
    echo "bandwidth=$bw"
    $ssh_cmd "echo $bw > /sys/kernel/debug/ieee80211/phy0/ath9k/chanbw"
    sleep 1
    $ssh_cmd "iw wlan0 info"
    channel_start=1
    channel_end=90
    while [ "$channel_start" -le "$channel_end" ]; do
        echo "channel=$channel_start"
        $ssh_cmd "iw wlan0 mesh chswitch $channel_start 20"
        sleep $channel_delay
        $ssh_cmd "iw wlan0 info | head -7 | tail -1"
        channel_start=$((channel_start + 1))
    done
done

# For 2350 helix band
$ssh_cmd "iw phy0 fes fes_set fes_freq_shift -131 fes_freq_bw 100 fes_freq_bw_in 100 fes_freq_bw_step 1 fes_chanbw_list \"3000 5000 10000 0 26000\" fes_min_integrated_radio_shift -131 fes_gain 16 new_freq 2350 HT20"
sleep $channel_delay
bandwidth_list="3 5 10 0 26"
for bw in $bandwidth_list; do
    echo "bandwidth=$bw"
    $ssh_cmd "echo $bw > /sys/kernel/debug/ieee80211/phy0/ath9k/chanbw"
    sleep 1
    $ssh_cmd "iw wlan0 info"
    channel_start=1
    channel_end=100
    while [ "$channel_start" -le "$channel_end" ]; do
        echo "channel=$channel_start"
        $ssh_cmd "iw wlan0 mesh chswitch $channel_start 20"
        sleep $channel_delay
        $ssh_cmd "iw wlan0 info | head -7 | tail -1"
        channel_start=$((channel_start + 1))
    done
done

# For 2455 helix band
$ssh_cmd "iw phy0 fes fes_set fes_freq_shift -31 fes_freq_bw 110 fes_freq_bw_in 110 fes_freq_bw_step 1 fes_chanbw_list \"0 3000 5000 10000 15000 26000\" fes_min_integrated_radio_shift -31 fes_gain 16 new_freq 2455 HT20"
sleep $channel_delay
bandwidth_list="3 5 10 15 0 26"
for bw in $bandwidth_list; do
    echo "bandwidth=$bw"
    $ssh_cmd "echo $bw > /sys/kernel/debug/ieee80211/phy0/ath9k/chanbw"
    sleep 1
    $ssh_cmd "iw wlan0 info"
    channel_start=1
    channel_end=110
    while [ "$channel_start" -le "$channel_end" ]; do
        echo "channel=$channel_start"
        $ssh_cmd "iw wlan0 mesh chswitch $channel_start 20"
        sleep $channel_delay
        $ssh_cmd "iw wlan0 info | head -7 | tail -1"
        channel_start=$((channel_start + 1))
    done
done

# For 2450 helix band
$ssh_cmd "iw phy0 fes fes_set fes_freq_shift 0 fes_freq_bw 123 fes_freq_bw_in 10000 fes_freq_bw_step 1 fes_chanbw_list \"0 3000 5000 10000 15000 26000\" fes_min_integrated_radio_shift 0 fes_gain 16 new_freq 2457 HT20"
sleep $channel_delay
bandwidth_list="3 5 10 0 15 26"
for bw in $bandwidth_list; do
    echo "bandwidth=$bw"
    $ssh_cmd "echo $bw > /sys/kernel/debug/ieee80211/phy0/ath9k/chanbw"
    sleep 1
    $ssh_cmd "iw wlan0 info"
    channel_start=1
    channel_end=14
    while [ "$channel_start" -le "$channel_end" ]; do
        echo "channel=$channel_start"
        $ssh_cmd "iw wlan0 mesh chswitch $channel_start 20"
        sleep $channel_delay
        $ssh_cmd "iw wlan0 info | head -7 | tail -1"
        channel_start=$((channel_start + 1))
    done
done
