#!/bin/bash
ssh_cmd="ssh -q -o StrictHostKeyChecking=no root@192.168.153.1"
channel_delay=3
# convert channel to frequency
# new_freq=$(jsonfilter -i /etc/models_conf -e "@.models[@.model=\"$submodel\"].channels[@.freq=$channel].ch")
# iw "$phy" fes fes_set fes_freq_shift "$fes_freq_shift" fes_freq_bw "$fes_freq_bw" fes_freq_bw_in "$fes_freq_bw_in" fes_freq_bw_step "$fes_freq_bw_step" fes_chanbw_list "$fes_chanbw_list" fes_min_integrated_radio_shift "$fes_min_integrated_radio_shift" fes_gain "$fes_gain" new_freq "$new_freq" HT20 >/dev/null
$ssh_cmd "ifconfig"