#!/bin/bash

powerReport() {
  $ssh_cmd0 root@"${portIPV6[$1]}"%"${ports[$1]}" ash -c "'/scripts_lima_phy/bitrates_11n.sh 0'"
  echo -n "MCS0 ($mcs0 dBm)    " >>"./reports/$MAC.txt"

  for x in $(seq $2 $((${#freqPR1[@]} - 1 - $2))); do
    #currentPathLoss=${pathloss[$(((($1+$3)*12)+$x))]}
    currentPathLoss=${pathlossPR1[$(((($1 * 2 + $3) * 3) + $x))]}
    currentPathLoss=$(echo $currentPathLoss+$offset | bc)
    echo "Path Loss set to $currentPathLoss"

    powerMeasure $1 $(($mcs0 * 2)) ${freqPR1[x]}
    if [ $? -eq 1 ]; then
      return 1
    fi
  done

  $ssh_cmd0 root@"${portIPV6[$1]}"%"${ports[$1]}" ash -c "'/scripts_lima_phy/bitrates_11n.sh 7'"
  echo "      " >>"./reports/$MAC.txt"
  echo -n "MCS7 ($mcs7 dBm)    " >>"./reports/$MAC.txt"

  for x in $(seq $2 $((${#freqPR1[@]} - 1 - $2))); do
    #currentPathLoss=${pathloss[$(((($1+$3)*12)+$x))]}
    currentPathLoss=${pathlossPR1[$(((($1 * 2 + $3) * 3) + $x))]}
    echo "Path Loss set to $currentPathLoss"

    powerMeasure $1 $(($mcs7 * 2)) ${freqPR1[x]}
    if [ $? -eq 1 ]; then
      return 1
    fi
  done
}
