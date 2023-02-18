# LAB 8 Linux I2c

For this you need the RTC plugged into JB. Please make sure to line up GND/VCC with GND/VCC on the connector. With the SPI flash pmod in, they both should fit together nicely on the board.

## 8.1 What i2c dev is enabled?

/dev/i2c-0

## 8.2 Here's the datasheet for the RTC. See, sometimes I'm nice.

 http://ww1.microchip.com/downloads/en/DeviceDoc/22266d.pdf?_ga=2.188600424.1156200237.1619713403-1021858564.1605903644

## 8.3 Use i2cdetect how may devices show up? And what are the addresses?

```
# i2cdetect -r -y 0
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- 57 -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- UU
70: -- -- -- -- -- -- -- --
```

## 8.4 Why are there that many devices?

Because one is the EEPROM one is the RTC

## 8.5 Remove the i2c pmod and run the command again how many are there?

1

## 8.6 Did you see any useful info in dmesg about i2c?

not really

## 8.7 What about for an "rtc" ?

yup

## 8.8 Why do you think "UU" is then in i2cdetect?

The kernel has the i2c address reserved for the RTC.

## 8.9 On an embedded device what is the linux technology that adds devices to the system that may not be hot swappable?

the device tree

## 8.10 Let's find the RTC in the device tree.

Run 

`find /proc/device-tree/ -type f -exec head {} + | grep rtc`

What is the memory mapped address? What is the i2c address?

i2c@41600000
rtc@6f

## 8.11 Do the address in Linux line up with what's in the datasheet?

No, you have to shift them.

0xAF and 0xDF

## 8.12 Using both the linux tools `date` and `hwclock` set and readback the RTC

hwlclock -s 

## 8.13 Now lets use the EEPROM section. What's the address of the EEPROM?

0x57

## 8.14 the tool we'll use for this is i2ctransfer, take a moment to look at the help on it

## 8.15 In addition to the i2c address, what other address do you have to keep in mind while writing to the eeprom?

the EEPROM address

## 8.16 How do you write 8 bytes to address 00 of the eeprom?

`i2ctransfer -y 0 w8@0x57 0x00 0x01 0x02 0x03 0x04 0x05 0x06 0x07`

## 8.17 How do you read those bytes back?

`i2ctransfer -y 0 w1@0x57 0x00 r7`

## 8.18 Were you able to capture any of this on your LA? If not, why not do you think?





