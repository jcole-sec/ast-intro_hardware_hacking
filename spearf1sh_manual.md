# Spearf1sh notes

Unless otherwise specified, all uart baud rates are 115200

# Hardware 

## Pins

| Pin | Description |
| --- | ----------- |
| SCL | Internal I2C SCL |
| SDA | Internal I2C SDA |
| IO13 | Internal SPI SS |
| IO12 | Internal SPI MOSI |
| IO11 | Internal SPI MISO |
| IO10 | Internal SPI SCLK |
| IO9 | Internal Uart Tx |
| IO8 | Internal Uart Rx |
| IO7 | Red PWM for LD4 |
| IO6 | Green PWM for LD4 |
| IO5 | Blue PWM for LD4 |
| IO4 | Red PWM for LD5 |
| IO3 | Green PWM for LD5 |
| IO2 | Blue PWM for LD5 |
| IO1 | MB debug Uart Rx |
| IO0 | MB debug Uart Tx |

## Switches

| SW1 | SW0 |  Description |
| --- | --- | ----------- |
| ON | ON | Uart perhiperal |
| ON | OFF | SPI perhiperal |
| OFF | ON | I2C perhiperal |
| OFF | OFF | RFU |

## Buttons

| Button | Description |
| --- | ----------- |
| BTN0 | Microblaze reset |

## PMODs

| Connector | Description |
| ---- | ----------- |
|  JA  | AXI QSPI, standard mode, 25MHz for SF3 PMOD |
|  JB  | AXI IIC master, 100khz for RTC PMOD |

## Address

| Description | Base |  High |
| --- | --- | ----------- |
| AXI Gpio I2C | 0x41200000 | 0x4120ffff |
| AXI Gpio SPI | 0x41210000 | 0x4121ffff |
| AXI Uart | 0x42c00000 | 0x42c0ffff |
| PWM 0 | 0x43c00000 | 0x43c0ffff |
| PWM 1 | 0x43c10000 | 0x43c1ffff |

# Software

## How to login

`root` no passwd. YOLO.

## How to run spearf0rth

Type `spearf0rth`

## Forth examples

This Forth is based on zforth (https://github.com/zevv/zForth) so if you want the source, there it is.

( Forth is space deliminated. Everything in forth is either a word or a number )
( Forth is stack based, there is a built in stack, try the following )
2 2 + .
( What this did is push 2 on the stack, 2 on the stack, add them and then print them out . )
( the key to forth is to write very short words. You defined them with : and end with ; )
: add2 ( n n -- n ) 2 + ;
4 add2 . 
( if you type `words` youll see this in the dictionary )
( the comment reads: if there are 2 numbers on the stack this function will return 1 )


The following is a nice little tutorial on forth:
https://skilldrick.github.io/easyforth/

There are some differences in zForth though. For example `variable` is just `var`

### Bit manipulation

## 7.1 Bit warmup. Perform the following bit exercises:

```
1 1 & .

2 1 & .

2 1 | .

1 1 << .

2 1 >> .

5 2 ^ .

 0 ~ .

7 parity .

8 parity .

9 parity .

3 2 bit-set .

7 2 bit-clear .

0 0 bit-toggle .


0 0 bit-toggle 0 bit-toggle 0 bit-toggle .

1 0 bit-check .

1 1 bit-check .

5 1 1 bit-ntox .

7 2 0 bit-ntox .

1 1 bit-lrot .

2 1 bit-rrot .

1 1 bit-rrot .

1 bit-reverse .

```