#!/bin/sh

# log() {
#     echo "LINENO: $1"
#     grep -n "log()" "$0"
    
# }

# log "$LINENO"

# echo "$LINENO"



# print_line_number() {
#     line_number=$(grep -n "print_line_number()" "$0" | cut -d ':' -f 1)
#     echo "Current line number: $line_number"
# }

# print_line_number


# echo $(grep -n "" "$0" | cut -d ':' -f 1)



# Print line numbers using awk
echo $(awk '{ print NR }' "$0" | tail -1)

echo "[$(date)] $LINENO: $(uci get wireless.radio1.hwmode),$(uci get wireless.radio1.channel)" >> /tmp/output_log
