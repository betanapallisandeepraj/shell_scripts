#!/bin/bash
threshold_space="60"
used_space_percent=$(df -h /dev/sda3 | awk '{print $5}' | awk -F % '{print $1}' | tail -1)
if [ "$threshold_space" -le "$used_space_percent" ]; then
	echo "[$(date '+%H%M%S%d%m%Y')] -> disk space $used_space_percent% used."
	echo "[$(date '+%H%M%S%d%m%Y')] -> But the threshold is $threshold_space% of disk space."
else
	echo "[$(date '+%H%M%S%d%m%Y')] -> disk space is available. continuing to build."
fi
