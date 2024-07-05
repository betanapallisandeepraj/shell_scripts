#!/bin/bash

# ip="192.168.153.1"
# ip="10.223.249.22"
ip=$(cat ~/target2_ip.txt)
ssh_cmd="ssh -q -oStrictHostKeyChecking=no -oHostKeyAlgorithms=+ssh-rsa root@$ip"

firmware_version=$($ssh_cmd "cat /etc/banner")
firmware_version=$(echo "$firmware_version" | awk -F \( '{print $2}'  | awk -F \) '{print $1}')
echo "$firmware_version"
# get the list of models exist
models_list=$($ssh_cmd "ls /usr/share/.doodlelabs/fes/")
# echo "$models_list"
parent_models_list=$(echo "$models_list" | grep MB-)
# echo "$parent_models_list"
nano_parent_models_list=$(echo "$parent_models_list" | grep 1L)
# echo "$nano_parent_models_list"
mini_parent_models_list=$(echo "$parent_models_list" | grep 2L)
# echo "$mini_parent_models_list"
palix_parent_models_list=$(echo "$parent_models_list" | grep 2KM)
# echo "$palix_parent_models_list"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
declare -a sub_models_hash_array

change_to_model() {
    echo "Changing to the model $1"
    $ssh_cmd "fes_model.sh set $1"
    $ssh_cmd "umount /overlay/"
    $ssh_cmd "firstboot -y"
    $ssh_cmd "reboot"
    ~/show_sleep.sh 400
}

print_status() {
    local current_bandwidth="$1"
    iw_wlan_info=$($ssh_cmd "iw wlan${fes_phy} info | head -7 | tail -1")
    iw_wlan_info_freq=$(echo "$iw_wlan_info" | awk -F \( '{print $2}' | awk '{print $1}')
    iw_wlan_info_bw=$(echo "$iw_wlan_info" | awk '{print $6}')
    # echo "band=$sub_model,chan=$current_chan,freq=$current_freq,bw=$current_bandwidth,iw_freq=$iw_wlan_info_freq,iw_bw=$iw_wlan_info_bw"
    if [ "$current_bandwidth" = "0" ]; then
        validation_current_bandwidth=20
    else
        validation_current_bandwidth=$current_bandwidth
    fi
    if [ "$current_freq" = "$iw_wlan_info_freq" ] && [ "$validation_current_bandwidth" = "$iw_wlan_info_bw" ]; then
        printf "band=%s, chan=%s, freq=%s, bw=%s\t --> ${GREEN}%s${NC}\n" "$sub_model" "$current_chan" "$current_freq" "$validation_current_bandwidth" "PASS"
    else
        printf "band=%s, chan=%s, freq=%s, bw=%s\t --> ${RED}%s${NC}\n" "$sub_model" "$current_chan" "$current_freq" "$validation_current_bandwidth" "FAIL"
    fi
}

process_list() {
    local list="$1"
    # Convert xxxx_parent_models_list to an array
    IFS=$'\n' read -d '' -r -a parent_models_array <<< "$list"
    for parent_model in "${parent_models_array[@]}"; do
        echo "Model: $parent_model"
        current_model=$($ssh_cmd "fes_model.sh get parent")
        if [[ "$current_model" == "$parent_model" ]]; then
            echo "Current model is already $current_model"
        else
            change_to_model "$parent_model"
            current_model=$($ssh_cmd "fes_model.sh get parent")
            if [[ "$current_model" == "$parent_model" ]]; then
                echo "Model changed to $current_model"
            else
                echo "Model changing failed"
                # exit 0
                continue
            fi
        fi

        # get the submodels list
        sub_models_list=$($ssh_cmd "cat /usr/share/.doodlelabs/fes/$parent_model")
        sub_models_list=$(echo "$sub_models_list" | awk -F \" '{print $2}')
        # echo "$sub_models_list"
        IFS=$'\n' read -d '' -r -a sub_models_array <<< "$sub_models_list"
        for sub_model in "${sub_models_array[@]}"; do
            # echo "submodel: $sub_model"
            # Find MD5 Crypt hash for a given string
            sub_model_hash=$($ssh_cmd "uhttpd -m \$(cat /usr/share/.doodlelabs/fes/$sub_model)")
            # echo "$sub_model_hash"
            # Check if hash is already in the array, to avoid same submodel verification
            if [[ " ${sub_models_hash_array[*]} " == *" $sub_model_hash "* ]]; then
                echo "Submodel: $sub_model is already done, Hash already exists in the array: $sub_model_hash"
            else
                # echo "Adding hash to the array: $sub_model_hash"
                sub_models_hash_array+=("$sub_model_hash")
                echo "submodel: $sub_model"
                sub_model_data=$($ssh_cmd "cat /usr/share/.doodlelabs/fes/$sub_model")
                # echo "$sub_model_data"
                fes_phy=$($ssh_cmd "/usr/share/simpleconfig/get_fes_phy.sh")
                [ -z "${fes_phy}" ] && fes_phy=0

                # bandwidth is, number of 1 MHz frequency apart from lower to upper frequencies 
                # available in that band. 
                bandwidth=$(echo "$sub_model_data" | grep -w bandwidth | awk -F = '{print $2}')
                bandwidth_step=$(echo "$sub_model_data" | grep -w bandwidth_step | awk -F = '{print $2}')
                bandwidth_step=${bandwidth_step:-1}
                chanbw_list=$(echo "$sub_model_data" | grep -w chanbw_list | awk -F \" '{print $2}')
                min_gainIndex=$(echo "$sub_model_data" | grep -w min_gainIndex | awk -F = '{print $2}')
                max_gainIndex=$(echo "$sub_model_data" | grep -w max_gainIndex | awk -F = '{print $2}')
                min_gainIndex=${min_gainIndex:-1}
                max_gainIndex=${max_gainIndex:-1}
                if [  "$min_gainIndex" -gt "$max_gainIndex"  ]; then
                    max_gainIndex="$min_gainIndex"
                fi
                fes_gainIndex=5
                [ -z "$min_gainIndex" ] && fes_gainIndex=$min_gainIndex
                if ! [ "$fes_gainIndex" -eq "$fes_gainIndex" ] 2>/dev/null; then
                    fes_gainIndex=0
                fi
                if [  "$min_gainIndex" -gt "$fes_gainIndex"  ]; then
                    fes_gainIndex="$min_gainIndex"
                fi
                if [  "$max_gainIndex" -lt "$fes_gainIndex"  ]; then
                    fes_gainIndex="$max_gainIndex"
                fi
                # echo "$bandwidth"
                # echo "$bandwidth_step"
                # echo "$chanbw_list"
                num_channels=$((bandwidth/bandwidth_step))
                # iw command parameters
                phy="phy${fes_phy}"
                fes_freq_bw_step=$bandwidth_step
                fes_chanbw_list=$chanbw_list
                fes_min_integrated_radio_shift=$(echo "$sub_model_data" | grep -w min_integrated_radio_shift | awk -F = '{print $2}')
                fes_gain=$fes_gainIndex
                HT="HT20"
                case "$sub_model" in
                    RM-2450*)
                        is_RM_2450=true
                        num_channels=14
                        bandwidth_step=5
                        min_shift=-19
                        fes_freq_bw="123"
                        fes_freq_bw_in="10000"
                        ;;
                    *)
                        is_RM_2450=false
                        fes_freq_bw=$bandwidth
                        fes_freq_bw_in=$(echo "$sub_model_data" | grep -w bandwidth_in | awk -F = '{print $2}')
                        ;;
                esac
                case "$sub_model" in
                    RM-5500*)
                        for band_width in $chanbw_list; do
                            band_width=$((band_width/1000))
                            [ -n "$band_width" ] && current_bandwidth=$band_width
                            # echo "band=$sub_model,bw=$current_bandwidth"
                            $ssh_cmd "echo $current_bandwidth >/sys/kernel/debug/ieee80211/$phy/ath9k/chanbw"
                            sleep 0.1
                            frequency=5140
                            while [ $frequency -lt 5885 ]; do
                                if [ "$frequency" = "5700" ]; then
                                    frequency="5745"
                                elif [ "$frequency" = "5320" ]; then
                                    frequency="5500"
                                else
                                    frequency=$((frequency + 20))
                                fi
                                channel=$(( (frequency - 5000) / 5 ))
                                [ -n "$frequency" ] && current_freq=$frequency
                                [ -n "$channel" ] && current_chan=$channel
                                # echo "$current_chan ($current_freq)"
                                # echo "band=$sub_model,chan=$current_chan,freq=$current_freq"
                                new_freq=$current_freq
                                # echo iw "$phy" fes fes_set fes_freq_shift "$fes_freq_shift" fes_freq_bw "$fes_freq_bw" fes_freq_bw_in "$fes_freq_bw_in" fes_freq_bw_step "$fes_freq_bw_step" fes_chanbw_list \""$fes_chanbw_list"\" fes_min_integrated_radio_shift "$fes_min_integrated_radio_shift" fes_gain "$fes_gain" special_ch_assign "$special_ch_assign" new_freq "$new_freq" "$HT"
                                $ssh_cmd "iw $phy fes fes_set fes_freq_shift $fes_freq_shift fes_freq_bw $fes_freq_bw fes_freq_bw_in $fes_freq_bw_in fes_freq_bw_step $fes_freq_bw_step fes_chanbw_list '$fes_chanbw_list' fes_min_integrated_radio_shift $fes_min_integrated_radio_shift fes_gain $fes_gain special_ch_assign $special_ch_assign new_freq $new_freq $HT >/dev/null"
                                sleep 1
                                # echo "band=$sub_model,chan=$current_chan,freq=$current_freq,bw=$current_bandwidth,iw_freq=$iw_wlan_info_freq,iw_bw=$iw_wlan_info_bw"
                                print_status "$current_bandwidth"
                            done
                        done
                        ;;
                    *)
                        special_ch_assign=$(echo "$sub_model_data" | grep -w special_ch_assign | awk -F = '{print $2}')
                        special_ch_assign=${special_ch_assign:-0}
                        min_shift=$(echo "$sub_model_data" | grep -w min_shift | awk -F = '{print $2}')
                        fes_freq_shift=$min_shift
                        channel=0
                        for band_width in $chanbw_list; do
                            band_width=$((band_width/1000))
                            [ -n "$band_width" ] && current_bandwidth=$band_width
                            # echo "band=$sub_model,bw=$current_bandwidth"
                            $ssh_cmd "echo $current_bandwidth >/sys/kernel/debug/ieee80211/$phy/ath9k/chanbw"
                            sleep 0.1
                            while [ "$channel" -lt "$num_channels" ]; do
                                frequency=$((channel*bandwidth_step))
                                if [ "$special_ch_assign" = "2" ]; then
                                    frequency=$((frequency+4000))
                                else
                                    frequency=$((frequency+2431))
                                fi
                                frequency=$((frequency+min_shift))
                                frequency=${frequency#-}
                                channel=$((channel+1))
                                [ $is_RM_2450 = true ] && [ $channel -eq 14 ] && frequency=2484
                                [ -n "$frequency" ] && current_freq=$frequency
                                [ -n "$channel" ] && current_chan=$channel
                                if [ "$special_ch_assign" = "2" ]; then
                                    [ -n "$channel" ] && current_chan=$((channel+15))
                                fi
                                # echo "$current_chan ($current_freq)"
                                # echo "band=$sub_model,chan=$current_chan,freq=$current_freq"
                                new_freq=$current_freq
                                # echo iw "$phy" fes fes_set fes_freq_shift "$fes_freq_shift" fes_freq_bw "$fes_freq_bw" fes_freq_bw_in "$fes_freq_bw_in" fes_freq_bw_step "$fes_freq_bw_step" fes_chanbw_list \""$fes_chanbw_list"\" fes_min_integrated_radio_shift "$fes_min_integrated_radio_shift" fes_gain "$fes_gain" special_ch_assign "$special_ch_assign" new_freq "$new_freq" "$HT"
                                $ssh_cmd "iw $phy fes fes_set fes_freq_shift $fes_freq_shift fes_freq_bw $fes_freq_bw fes_freq_bw_in $fes_freq_bw_in fes_freq_bw_step $fes_freq_bw_step fes_chanbw_list '$fes_chanbw_list' fes_min_integrated_radio_shift $fes_min_integrated_radio_shift fes_gain $fes_gain special_ch_assign $special_ch_assign new_freq $new_freq $HT >/dev/null"
                                sleep 1
                                # echo "band=$sub_model,chan=$current_chan,freq=$current_freq,bw=$current_bandwidth,iw_freq=$iw_wlan_info_freq,iw_bw=$iw_wlan_info_bw"
                                print_status "$current_bandwidth"
                            done
                        done
                        ;;
                esac
            fi
        done
    done
}

# Process each list
process_list "$nano_parent_models_list"
process_list "$mini_parent_models_list"
process_list "$palix_parent_models_list"

unset sub_models_hash_array
