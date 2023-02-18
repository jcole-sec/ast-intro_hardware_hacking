# LAB 7 Bitbang SPI

First you need to know some things. The bit bang method uses GPIO. GPIO pins need to be configured such that they are outputs or inputs, like the Linux gpio we need way back in Lab 2. For this lab, that is taken care of for you already in the hardware.

Second thing you need to know is the address for the SPI bit bang GPIO perhipheral is at 0x41210000. Buy writing to this 32 bit word, you can toggle pins. The pins are assigned like this:

```
Gpio[0] = SS
Gpio[1] = mosi
Gpio[2] = miso
Gpio[3] = sclk
```

Therefore, writing a 1 to bit 0 will set SS high. However, you have to operate on the entire word, so you will have to use bit toggling words to manipulate just the bit you want without disturbing the others. If you were to set this word to 1 it would drive all other pins to 0 and that might not be what you want.

Remember the pins for monitoring SPI internals:


| IO13 | Internal SPI SS |
| IO12 | Internal SPI MOSI |
| IO11 | Internal SPI MISO |
| IO10 | Internal SPI SCLK |

Also, your switches need to be in the correct position:


| SW1 | SW0 |  Description |
| --- | --- | ----------- |
| ON | ON | Uart peripheral |
| ON | OFF | SPI peripheral |
| OFF | ON | I2C peripheral |
| OFF | OFF | RFU |

Lastly, it’s very likely that you will confuse the SPI peripheral. You can always (and you should) reset the microblaze by pushing BTN0 to return it to a clean state.

The internal SPI peripheral is modeled like a SPI flash memory. You send it 0x9e then keep clocking it to read out all the data.

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
```

Answers:


```
1 1 & .
0x1
2 1 & .
0x0
2 1 | .
0x3
1 1 << .
0x2
2 1 >> .
0x1
5 2 ^ .
0x7
 0 ~ .
0xffffffff
7 parity .
0x1
8 parity .
0x1
9 parity .
0x0
3 2 bit-set .
0x7
7 2 bit-clear .
0x3
0 0 bit-toggle .
0x1

0 0 bit-toggle 0 bit-toggle 0 bit-toggle .
0x1
1 0 bit-check .
0x1
1 1 bit-check .
0x0
5 1 1 bit-ntox .
0x7
7 2 0 bit-ntox .
0x3

1 1 bit-lrot .
0x2
2 1 bit-rrot .
0x1
1 1 bit-rrot .
0x80000000
```

## 7.2 Create a word that pushes the base address on the stack

`: gpiospiaddr ( -- n ) 0x41210000 ;`

## 7.3 Create a word that starts the SPI transaction. A pro-tip, first set SS high, then drive it low. Note that due to the natural delay of the interpreter, you generally don’t need sleeps in your code.

`: spistart ( -- ) gpiospiaddr 1 poke gpiospiaddr 0 poke ;`

## 7.4 Create a word that ends a SPI transaction: drive SS high.

`: spiend ( -- ) gpiospiaddr 1 poke ;`

## 7.5 Using your LA, perform the start and stop of SPI only and confirm it’s working. (remember about triggers)


## 7.6 what was the delay between start and stop?

3.4uS

## 7.7 Create a word that sets the clock high. Remember, you have to keep all the other bits the same, so first you have to read the bits, toggle the bit you want, then write back the bits.

`: sclkup ( -- ) gpiospiaddr peek 0x8 | gpiospiaddr swap poke ;`

## 7.8 Now, create a word that drives the clock down.

`: sclkdown ( -- ) gpiospiaddr peek 0x7 & gpiospiaddr swap poke ;`

## 7.9 Cycle the clock a few times, up, down, up, down, and confirm it’s working. What frequency is you clock running at?

53kHz

## 7.10 Now, make two words, one for mosiup one for mosidown that perform the similar operations but for the mosi signal. Confirm it’s working on the LA.

```
: mosiup ( -- ) gpiospiaddr peek 0x2 | gpiospiaddr swap poke ;
: mosidown ( -- ) gpiospiaddr peek 0xD & gpiospiaddr swap poke ;
```

## 7.11 Now you have to read MISO. But you have to shift the bit. So you need to read the bits, mask off MISO, and then shift it so that it ends up in bit 0 before you push it to the stack. If you read MISO now, there will be nothing there, so you can practice by pushing a test number on the stack to confirm your function is working.

`: misoget ( -- n ) gpiospiaddr peek 0x4 & 2 >> ;`

## 7.12 Now for the hardest part, putting this all together. First, I’m going to give you all the words up to now so you can check your answers. Note you don’t have to implement it just like this.

```
: gpiospiaddr ( -- n ) 0x41210000 ;
: spistart ( -- ) gpiospiaddr 1 poke gpiospiaddr 0 poke ;
: spiend ( -- ) gpiospiaddr 1 poke ;
: sclkup ( -- ) gpiospiaddr peek 0x8 | gpiospiaddr swap poke ;
: sclkdown ( -- ) gpiospiaddr peek 0x7 & gpiospiaddr swap poke ;
: mosiup ( -- ) gpiospiaddr peek 0x2 | gpiospiaddr swap poke ;
: mosidown ( -- ) gpiospiaddr peek 0xD & gpiospiaddr swap poke ;
: misoget ( -- n ) gpiospiaddr peek 0x4 & 2 >> ;
```

## 7.13 The loop is tricky so take your time. We implement this so the spistart and end are outside the byte transfer. So for example, here’s our final words with the data you should receive (the first byte may be 0x00 or 0xff)

```
: dummy 0x00 spixferbyte . ;
hex> spistart 0x9E spixferbyte . dummy dummy dummy dummy spiend
0x0 0x22 0x54 0x68 0x65
```

## 7.14 Loops in forth have a special syntax and can only be used in a defining word. Here’s an example. Note the variable i which forth provides for you as a convenience.

```
hex> : example 0x0a 0 do i . loop ;

hex> example
0x0 0x1 0x2 0x3 0x4 0x5 0x6 0x7 0x8 0x9 0xa
```

## 7.15 Conditionals in forth are also a bit different. The if statement uses the C truth table. Here’s an example:

```
hex> : odds 0xa 0 do i dup 1 & if 1 . else 0 . fi loop ;

hex> odds
0x0 0x1 0x0 0x1 0x0 0x1 0x0 0x1 0x0 0x1 0x0
```

## 7.16 Now try to write the spixferbyte ( n -- n ) word. Remember that time passes as you execute commands. There are a few ways to do this. One way is do make a loop that sends the bit of MOSI as appropriate. After you send MOSI, you need to read MISO. Meanwhile, you need to keep track of CLK.

Note: the LA may unfortunately not display the correct byte but your interrupter will. This is because SPI peripheral is running at 25MHz and it quickly transitions the first bit of MISO and the LA doesn’t catch it.

```
: spixferbyte ( n -- n ) mosidown 0 7 0 do swap dup sclkdown 1 7 i - << & if mosiup else mosidown fi swap misoget 7 i - << | sclkup loop sclkdown mosidown ;
```

## 7.17 Why does it not better that the clock is “stretched” after every byte? 

B/c SPI is the honey badger, it don’t care. It operates on the clock transitions.


