#!/usr/bin/python3

from serial import Serial
from os import system

def reset_se():
    if system("devmem 0x41230000 32 0xffffffff") and system("devmem 0x41230000 32 0x0"):
        print("Failed to reset SE")

for pin in range (0,10000):
    reset_se()
    pin_str = "{:04d}".format(pin)
    print(pin_str)
    dev = Serial(port='/dev/ttyUL1', baudrate=115200)
    dev.write(pin_str.encode())
    result = b""
    while b'PIN INCORRECT' not in result:
        result += dev.read(1)
        #print(repr(result))