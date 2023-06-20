#!/bin/bash
ssh_cmd="ssh root@192.168.153.1"

# For 2455 helix band
$ssh_cmd "iw phy0 fes fes_set fes_freq_shift -31 fes_freq_bw 110 fes_freq_bw_in 110 fes_freq_bw_step 1 fes_chanbw_list \"0 3000 5000 10000 15000 26000\" fes_min_integrated_radio_shift -31 new_freq 2455 HT20"
channel_start=96
channel_end=110
$ssh_cmd "iw wlan0 info"
while [ "$channel_start" -le "$channel_end" ]; do
    echo "channel=$channel_start"
    $ssh_cmd "iw wlan0 mesh chswitch $channel_start 20"
    sleep 10
    $ssh_cmd "iw wlan0 info | head -7 | tail -1"
    channel_start=$((channel_start + 1))
done
