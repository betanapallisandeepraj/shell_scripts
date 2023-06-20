#!/bin/bash
submodel="RM-2450-2L-X"
var0=$(echo $submodel | awk -F - '{print $1}')
var1=$(echo $submodel | awk -F - '{print $2}')
var2=$(echo $submodel | awk -F - '{print $3}')
var3=$(echo $submodel | awk -F - '{print $4}')
echo "var0=$var0,var1=$var1,var2=$var2,var3=$var3"
band_value=$var1
submodel1="$var0-$var1-$var2-$var3"
echo "band_value=$band_value"
echo "submodel1=$submodel1"