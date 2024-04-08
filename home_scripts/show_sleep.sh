#!/bin/bash
show_sleep() {
  secs=$(($1))
  while [ $secs -gt 0 ]; do
    echo -ne "$secs\033[0K\r"
    sleep 1
    : $((secs--))
  done
}

show_sleep $1
