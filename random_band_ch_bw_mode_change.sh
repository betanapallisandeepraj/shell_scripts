#!/bin/bash
# This script is to automatically change
# band, channel, bandwidth for palix MB-0001-2KM-XW only
ssh_cmd="ssh -q -o StrictHostKeyChecking=no root@10.223.255.73"

# radio=(radio0 radio1)
# echo ${radio[0]}
# radio[0]="skfkjdkj"
# echo ${radio[0]}

# radio0,wlan0,phy0 are for fes interface related in palix
# radio1,wlan1,phy1 are for wifi interface related in palix
radio=(radio0 radio1)
wlan=(wlan0 wlan1)
phy=(phy0 phy1)
# palix MB-0001-2KM-XW submodels
submodel=(RM-1675-2KM-XW RM-1815-2KM-XW RM-2065-2KM-XW RM-2245-2KM-XW RM-2350-2KM-XW RM-2455-2KM-XW RM-2450-2KM-XW)
fes_radio_chanl=("chanl_1675" "chanl_1815" "chanl_2065" "chanl_2245" "chanl_2350" "chanl_2455" "chanl_2450")
chanl_1675=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100)
chanl_1815=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70)
chanl_2065=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85)
chanl_2245=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90)
chanl_2350=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100)
chanl_2455=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110)
chanl_2450=(1 2 3 4 5 6 7 8 9 10 11 12 13 14)
fes_radio_bw=("bw_1675" "bw_1815" "bw_2065" "bw_2245" "bw_2350" "bw_2455" "bw_2450")
bw_1675=(3 5 10 0 26)
bw_1815=(3 5 10 0 26)
bw_2065=(3 5 10 0 26)
bw_2245=(3 5 10 0 26)
bw_2350=(3 5 10 0 26)
bw_2455=(3 5 10 15 0 26)
bw_2450=(3 5 10 15 0 26)
fes_radio_mode=(mesh wds_ap)
wifi_radio_2band_chanl=(1 2 3 4 5 6 7 8 9 10 11 12 13 14)
wifi_radio_5band_chanl=(32 36 40 44 48 52 56 60 64 100 104 108 112 116 120 124 128 132 136 140 149 153 157 161 165 169 173 177)
wifi_radio_5band_dfs_chanl=(52 56 60 64 100 104 108 112 116 120 124 128 132 136 140)
wifi_radio_5band_non_dfs_chanl=(32 36 40 44 48 149 153 157 161 165 169 173 177)
wifi_radio_all_non_dfs_chanl=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 32 36 40 44 48 149 153 157 161 165 169 173 177)
wifi_radio_all_chanl=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 32 36 40 44 48 52 56 60 64 100 104 108 112 116 120 124 128 132 136 140 149 153 157 161 165 169 173 177)
wifi_radio_mode=(none)
# wifi_radio_bw=(3 5 10 15 0 26)
prev_mode=""

# submodel=(RM-1675-2KM-XW RM-1815-2KM-XW)
# fes_radio_chanl=("chanl_1675" "chanl_1815")
# chanl_1675=(1 2 3)
# chanl_1815=(1 2)
# fes_radio_bw=("bw_1675" "bw_1815")
# bw_1675=(3 5)
# bw_1815=(3 5 10)
# fes_radio_mode=(mesh)
# wifi_radio_all_chanl=(52 56 60 64 100 104 108 112 116 120 124 128 132 136 140 149 153 157 161 165 169 173 177)
# wifi_radio_mode=(none ap_no_fes)

# echo "${submodel[0]}"
# echo "${fes_radio_chanl[0]}"
# echo "${chanl_1675[@]}"

# # Loop through the variable list
# for var_name in "${fes_radio_chanl[@]}"; do
#     # Use variable indirection to get the array elements
#     array_name="$var_name[@]"
#     array=("${!array_name}")
#     echo ${array[@]}
#     # echo "Elements of $var_name:"
#     # for element in "${array[@]}"; do
#     #     echo -n "$element "
#     # done
#     # echo
# done

change_band_chan_bw() {
    echo $1 $2 $3 $4 >>/tmp/log_2.txt
    $ssh_cmd "/usr/share/simpleconfig/band_switching.sh $2 $3 $4 2> /dev/null > /dev/null"
    sleep 1
    # echo -n "$1 $2 $3 $4 -> " >>/tmp/log_4.txt
    if [ "$1" == "wds_ap" ]; then
        $ssh_cmd "iw wlan0 info | head -8 | tail -1"
    else
        $ssh_cmd "iw wlan0 info | head -7 | tail -1"
    fi

    # echo "" >>/tmp/log_4.txt
}

echo -n "" >/tmp/log_1.txt
echo -n "" >/tmp/log_2.txt
echo -n "" >/tmp/log_3.txt
echo -n "" >/tmp/log_4.txt
random_radio() {
    local size
    local index
    size=${#radio[@]}
    index=$(($RANDOM % $size))
    rad=${radio[$index]}
}
random_submodel() {
    local size
    local index
    size=${#submodel[@]}
    index=$(($RANDOM % $size))
    subm=${submodel[$index]}
}
random_channel() {
    local size
    local index
    local array_name
    local array

    index=$(printf '%s\n' "${submodel[@]}" | grep -n "$1" | cut -d':' -f1)
    # Subtract 1 from the index to make it zero-based
    if [[ -n "$index" ]]; then
        index=$((index - 1))
    else
        index=-1
    fi
    chan_list_name=${fes_radio_chanl[$index]}
    array_name="$chan_list_name[@]"
    array=("${!array_name}")
    chan_list=${array[@]}
    size=${#array[@]}
    index=$(($RANDOM % $size))
    chan=${array[$index]}

}
random_channel_non_fes() {
    local size
    local index
    size=${#wifi_radio_all_chanl[@]}
    index=$(($RANDOM % $size))
    chan_non_fes=${wifi_radio_all_chanl[$index]}
}
random_channel_non_fes_non_dfs() {
    local size
    local index
    size=${#wifi_radio_all_non_dfs_chanl[@]}
    index=$(($RANDOM % $size))
    chan_non_fes=${wifi_radio_all_non_dfs_chanl[$index]}
}
random_channel_non_fes_dfs() {
    local size
    local index
    size=${#wifi_radio_5band_dfs_chanl[@]}
    index=$(($RANDOM % $size))
    chan_non_fes=${wifi_radio_5band_dfs_chanl[$index]}
}
random_bandwidth() {
    # echo $1
    local size
    local index
    local array_name
    local array

    index=$(printf '%s\n' "${submodel[@]}" | grep -n "$1" | cut -d':' -f1)
    # Subtract 1 from the index to make it zero-based
    if [[ -n "$index" ]]; then
        index=$((index - 1))
    else
        index=-1
    fi
    bw_list_name=${fes_radio_bw[$index]}
    array_name="$bw_list_name[@]"
    array=("${!array_name}")
    bw_list=${array[@]}
    size=${#array[@]}
    index=$(($RANDOM % $size))
    bw=${array[$index]}

}
random_mode() {
    local size
    local index
    if [ "$rad" == "radio0" ]; then
        size=${#fes_radio_mode[@]}
        index=$(($RANDOM % $size))
        mode=${fes_radio_mode[$index]}
    else
        size=${#wifi_radio_mode[@]}
        index=$(($RANDOM % $size))
        mode=${wifi_radio_mode[$index]}
    fi
}
while true; do
    # generate random radio
    random_radio
    #generate random mode
    random_mode $rad
    if [ "$rad" == "radio0" ]; then
        # generate random submodel
        random_submodel
        # generate random channel
        random_channel $subm
        # generate random bandwidth
        random_bandwidth $subm
        # echo "$rad,$mode,$subm,$chan_list_name,$chan_list,$chan,$bw_list_name,$bw_list,$bw"
        echo "$rad,$mode,$subm,$chan_list_name,$chan,$bw_list_name,$bw"
        if [ "$mode" != "$prev_mode" ]; then
            $ssh_cmd "/usr/share/simpleconfig/setup.sh $mode ap_no_fes 2> /dev/null > /dev/null"
            prev_mode=$mode
            sleep 1
        fi
        change_band_chan_bw $mode $subm $chan $bw
    else
        # if [ $(($RANDOM % 5)) == 0 ]; then
        if [ $(($RANDOM % 2)) == 0 ]; then
            # generate non-fes random channel
            # random_channel_non_fes
            # random_channel_non_fes_dfs
            random_channel_non_fes_non_dfs
            echo "$rad,$mode,$chan_non_fes"
            if [ "$chan_non_fes" -le "14" ]; then
                # For 2.4G
                # $ssh_cmd "uci set wireless.radio1.hwmode=11g"
                # $ssh_cmd "uci set wireless.radio1.channel=$chan_non_fes"
                # $ssh_cmd "uci commit"
                # $ssh_cmd "wifi"
                # sleep 3
                echo "skipping this"
            else
                # For 5G
                $ssh_cmd "uci set wireless.radio1.hwmode=11a"
                $ssh_cmd "uci set wireless.radio1.channel=$chan_non_fes"
                $ssh_cmd "uci commit"
                # $ssh_cmd "wifi"
                $ssh_cmd "ubus call network reload"
                sleep 10
            fi
            $ssh_cmd "iw wlan1 info | head -8 | tail -1"
        fi
    fi
    sleep 1
done

# for wifi_mode in "${wifi_radio_mode[@]}"; do
#     echo -e "$wifi_mode"
#     for wifi_chan in "${wifi_radio_all_chanl[@]}"; do
#         # echo -e "\t$wifi_chan"
#         if [ "$wifi_chan" -le "14" ]; then
#             echo -e "\t$wifi_chan"
#             # For 2.4G
#             $ssh_cmd "uci set wireless.radio1.hwmode=11g"
#             $ssh_cmd "uci set wireless.radio1.channel=$wifi_chan"
#             $ssh_cmd "uci commit"
#             $ssh_cmd "/etc/init.d/network restart"
#             sleep 10
#         else
#             echo -e "\t$wifi_chan"
#             # For 5G
#             $ssh_cmd "uci set wireless.radio1.hwmode=11a"
#             $ssh_cmd "uci set wireless.radio1.channel=$wifi_chan"
#             $ssh_cmd "uci commit"
#             $ssh_cmd "/etc/init.d/network restart"
#             sleep 120
#         fi
#         $ssh_cmd "iw wlan1 info | head -8 | tail -1"
#         for fes_mode in "${fes_radio_mode[@]}"; do
#             echo -e "\t$fes_mode"
#             $ssh_cmd "/usr/share/simpleconfig/setup.sh $fes_mode none 2> /dev/null > /dev/null"
#             sleep 1
#             for band in "${submodel[@]}"; do
#                 echo -e "\t\t$band"
#                 for chan_list_name in "${fes_radio_chanl[@]}"; do
#                     band_base=$(echo $band | awk -F - '{print $2}')
#                     if [ $(echo $chan_list_name | grep $band_base) ]; then
#                         echo -e "\t\t\t$chan_list_name"
#                         array_name="$chan_list_name[@]"
#                         array=("${!array_name}")
#                         echo -e "\t\t\t${array[@]}"
#                         for chan in "${array[@]}"; do
#                             echo -e "\t\t\t$chan"
#                             for bw_list_name in "${fes_radio_bw[@]}"; do
#                                 if [ $(echo $bw_list_name | grep $band_base) ]; then
#                                     echo -e "\t\t\t\t$bw_list_name"
#                                     array_name="$bw_list_name[@]"
#                                     array=("${!array_name}")
#                                     echo -e "\t\t\t\t${array[@]}"
#                                     for bw in "${array[@]}"; do
#                                         echo -e "\t\t\t\t$bw"
#                                         echo "$wifi_mode,$fes_mode,$band,$chan,$bw" >>/tmp/log_1.txt
#                                         change_band_chan_bw $wifi_mode $fes_mode $band $chan $bw
#                                         sleep 0.1
#                                     done
#                                 fi
#                                 sleep 0.1
#                             done
#                             sleep 0.1
#                         done
#                     fi
#                     sleep 0.1
#                 done
#                 sleep 0.1
#             done
#             sleep 0.1
#         done
#         sleep 0.1
#     done
#     sleep 0.1
# done
