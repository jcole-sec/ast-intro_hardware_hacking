# LAB 4 UART

The UART peripheral we have is the XIlinx UART Lite hardware. The data sheet for it is here: https://www.xilinx.com/support/documentation/ip_documentation/axi_uartlite/v2_0/pg142-axi-uartlite.pdf

Make sure you are in the UART mode and reset your microblaze:

SW1	SW0	Description
ON	ON	Uart perhiperal
ON	OFF	SPI perhiperal
OFF	ON	I2C perhiperal
OFF	OFF	RFU

## 4.1 There are 4 registers, what are they, and what are the offsets?

0h RX fifo
04h Tx Fifo
08h STAT_REG
0Ch CTRL_REG

## 4.2 The base address for the UART hardware is 0x42c00000, what are the four addresses?

0x42c00000, 0x42c00004, 0x42c00008, 0x42c0000c

## 4.3 What happens when a read request is used to an empty RX FIFO?

A bus error occurs.

## 4.3 How can you perform a read operation without generating a fault?

First you need to check the status register, bit 0, and if it’s 1, go ahead and read

## 4.4 How do you send a byte over uart?

Write to the TX fifo register

## 4.5 Can the baud rate of the UART be changed via software (don't go into a rabbit hole search on this one)

No, it must be changed when designing the hardware

## 4.6 The way the UART peripheral works (on the microblaze) is that it will echo data back to you. Let's try to write a driver in forth. Write a byte to the TX fifo register.

0x42c00004 1 poke

## 4.7 Now read a byte from the RX register. What did it return?

0x42c00000 peek .

The same thing.

## 4.8 Read another byte, what happens?

We get a bus fault


## 4.9 The spearf0rth syntax for basic one-armed if statements is `: <value> if <if true> fi ;`  However, you have to use it in a definition. Try the following:

hex> : t if 2 . fi ;

hex> 1 t
0x2
hex> 0 t


## 4.10 We made the bitwise & operator in spearf0th. As well as the word bit-check. Give the following a try:

hex> 7 1 & .
0x1
hex> 7 1 bit-check .
0x1
hex> 7 3 bit-check .
0x0

## 4.11 Now, write a word that only reads from the RX buffer IF there is data in the buffer to read. Does this stop the crash?

`: ur 0x42c00008 peek 0x1 & if 0x42c00000 peek fi ;`

## 4.12 Write a word to send a byte to the tx fifo (remember the “swap” word)

`: uw 0x42c00004 swap poke ;`

## 4.13 Write a word that takes a value off the stack, sends it to the microblaze, and reads it back. Remember that we have independent processors, therefore if you try to read before there is any data, it might not be there. The word `nsleep ( n -- )` will sleep for n nano seconds.

`: lb uw 1000 nsleep ur . ;`

## 4.14 Send the byte 55 using your loopback word, did you receive the same byte back?

You should have :)

## 4.15 In a piece of paper, or in your head, draw out what the UART transaction should look like, what do you expect to see on the wire?

Start bit, alternating 1,0, stop bit

## 4.16 Open up pulse view with the default settings, connect your jumper wires to IO8 and IO9, start a capture and send your 0x55 with your loopback word. Does the capture look anything like you expected? Why?

No. Because the sample rate is too small.

## 4.17 What do you think the sample rate should be for a baud rate of 115200?

At least 2x. 500kHz works well for us at min.

## 4.18 Change the sample rate and try again, does that look better?

Yes

## 4.19 Add the UART protocol decoders (yellow and green button next to the sample rate). Does it decode as you’d expect?

Yes

## 4.20 What is the turnaround time from the stop bit to the first bit sent by the microblaze?

4.9uS



## 4.21 OPTIONAL BONUS. Create a word that sends a string.

There’s a few things you need to know. The word `s” <string> “` will compile a string into the dictionary. It returns the string length and the address in memory of the string. There’s a few ways to do loops in FORTH, here is one zforth example (https://github.com/zevv/zForth/blob/5b4c20c2351b72bc6a27203bd3c2a5f9f0f0ddc4/forth/mandel.zf). Here’s a more official one: https://www.forth.com/starting-forth/6-forth-do-loops/
But, you should know that if you use the do/loop style forth will create a loop iterator variable i for you for free and each loop iteration it will contain the loop count. Also the word “fetch” ( @) will retrieve data at this address.

```
: us 0 do dup i + @ uw loop ;
s" yo " us
```

## 4.22 Capture

Capture the uart with the logic analyzer
