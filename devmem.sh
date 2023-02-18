#!/bin/bash
# Step 1: devmem 0x42c00004 32 0xaa

get_status() {
  devmem 0x42c00008 8
}


get_status_fake() {
  echo "0x04"
}

to_binary() {
  VAL=$1
  RES=$(echo "obase=2; ibase=16; ${VAL:2}" | bc)
  printf "%08d" "${RES}"
}

get_status_bin() {
  to_binary "$(get_status)"
}

bit_value() {
  local index index1 value
  value=$1
  index=$2
  index1=$((8-index))
  echo "${value}" | cut -c "${index1}"
  echo
}

can_read() {
  local status
  status=$(get_status_bin)
  bit_value "${status}" 0
}

if [ "$(can_read)" == 1 ] ; then
  devmem 0x42c00000 8
else
  echo "Cannot read"
fi