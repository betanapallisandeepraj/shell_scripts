#!/bin/bash
ssh_cmd="ssh -q -o StrictHostKeyChecking=no root@10.223.249.22"
channel_delay=3

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
