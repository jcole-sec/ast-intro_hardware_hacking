# LAB 6 Linux SPI

This lab requires the Digilent SPI flash pmod (https://store.digilentinc.com/pmod-sf3-32-mb-serial-nor-flash/). If you don’t have the pmod, there are still some of the exercises you can do.

## 6.1 Where is the datasheet for this part?

https://media-www.micron.com/-/media/client/global/documents/products/data-sheet/nor-flash/serial-nor/n25q/n25q_256mb_3v.pdf?rev=cd8f3bb53a294ad897ff924f360be390

## 6.2 Why SPI driver was loaded in the kernel?

Spidev, discovered via dmesg grep

## 6.3 Look up the kernel docs for this driver, why would someone use this driver?

Some reasons you might want to use this programming interface include:

 * Prototyping in an environment that's not crash-prone; stray pointers
   in userspace won't normally bring down any Linux system.

 * Developing simple protocols used to talk to microcontrollers acting
   as SPI slaves, which you may need to change quite often.

Of course there are drivers that can never be written in userspace, because
they need to access kernel interfaces (such as IRQ handlers or other layers
of the driver stack) that are not accessible to userspace.

## 6.4 Let’s try to get the manufacturer ID from the spi flash. This flash, like others, has a command protocol. What is the command byte (datasheet calls it a code) for performing the READ ID command (look in the datasheet)?

0x9e

## 6.5 There are some SPI tools on the board, specifically spidev_test. We want to send this command to the flash and get the response, what parameters do you think you need?

-D, -s, -p

## 6.6 What is the /dev/spi device you need?

/dev/spidev1.0

## 6.7 The speed that seems to work best is 25Mhz (-s 25000000). Will your logic analyzer be able to record the signal?

NOPE

## 6.8 According to the datasheet, what is the expected result of the read ID command?

20h, BAh, 19h, 10h, <unique id>

## 6.9 Send the command byte, what did you get in return? (remember to prefix it with \x )

```
> spidev_test -D /dev/spidev1.0 -s 25000000 -p "\x9e"
spi mode: 0x0
bits per word: 8
max speed: 25000000 Hz (25000 KHz)
RX | FF __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __  | .
```

## 6.10 Is this what you expected?

NOPE, only one bye.

## 6.11 What do you have to do to get the SPI flash to keep sending more data?

Keep clocking the part.

## 6.12 What happens if you pad zeros after the command byte?

It returns more data

## 6.13 What’s the command to return the the ID?

`spidev_test -D /dev/spidev1.0 -s 25000000 -p "\x9e00000000000000000000"`

## 6.13aa Is the unique ID to be considered a secret or a good device identifier?

NOPE.

## 6.13a Take a look at the capture of the SPI ID, can you manually and/or programmatically decode it?

## 6.14 Now lets try flashrom. First we need some details about the flash. Run flashrom with the following parameters: flashrom -p linux_spi:dev=/dev/spidev1.0,spispeed=25000. How big is the flash size?

32768

## 6.15 Use the dd command and create a random file that’s is the exact size you need.

`dd if=/dev/urandom of=test.bin bs=1024 count=32768`

## 6.16 Write the contents of the file to the flash.

`flashrom -p linux_spi:dev=/dev/spidev1.0,spispeed=25000 -c N25Q256..3E/MT25QL256 -w test.bin`

## 6.17 Read back the flash into a new file.

`flashrom -p linux_spi:dev=/dev/spidev1.0,spispeed=25000 -c N25Q256..3E/MT25QL256 -r new.bin`

## 6.18 Are they the same?

OF COURSE

