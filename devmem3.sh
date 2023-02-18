#!/usr/bin/env bash

RX_FIFO=0x42c00000
TX_FIFO=0x42c00004
STAT_REG=0x42c00008
CTRL_REG=0x42c0000c

rx_fifo_has_data() {
  local value=$(devmem $STAT_REG 8)
  echo $((($value & 1) == 1))
}

rx_read() {
  local size=$1

  if [ "$(rx_fifo_has_data)" == 1 ] ; then
    devmem $RX_FIFO $size
  else
    echo "Receive FIFO is empty"
  fi
}

rx_reset() {
  # Set bit 1 to clear the receive FIFO
  local value=$(devmem $CTRL_REG 8)
  value=$(($value | 2))
  devmem $CTRL_REG 8 $value
}

tx_write() {
  local size=$1
  local value=$2

  devmem $TX_FIFO $size $value
}

usage() {
  echo "Usage: $(basename $0) echo|read|reset|write [size] [value]"
}

case $1 in
  echo)
    if [ -z "$3" ]; then
      usage
      exit $E_BADARGS
    fi

    rx_reset
    tx_write $2 $3
    until [ "$(rx_fifo_has_data)" == 1 ]; do
      sleep 1
    done
    rx_read $2
    ;;

  read)
    if [ -z "$2" ]; then
      usage
      exit $E_BADARGS
    fi

    rx_read $2
    ;;

  reset)
    rx_reset
    ;;

  write)
    if [ -z "$3" ]; then
      usage
      exit $E_BADARGS
    fi

    tx_write $2 $3
    ;;

  *)
    usage
    exit $E_BADARGS
    ;;

esac
