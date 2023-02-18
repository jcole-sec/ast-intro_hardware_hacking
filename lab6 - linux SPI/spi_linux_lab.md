# LAB 6 Linux SPI

This lab requires the Digilent SPI flash pmod (https://store.digilentinc.com/pmod-sf3-32-mb-serial-nor-flash/). If you don’t have the pmod, there are still some of the exercises you can do.

## 6.1 Where is the datasheet for this part?


## 6.2 Why SPI driver was loaded in the kernel?


## 6.3 Look up the kernel docs for this driver, why would someone use this driver?


## 6.4 Let’s try to get the manufacturer ID from the spi flash. This flash, like others, has a command protocol. What is the command byte (datasheet calls it a code) for performing the READ ID command (look in the datasheet)?


## 6.5 There are some SPI tools on the board, specifically spidev_test. We want to send this command to the flash and get the response, what parameters do you think you need?


## 6.6 What is the /dev/spi device you need?


## 6.7 The speed that seems to work best is 25Mhz (-s 25000000). Will your logic analyzer be able to record the signal?


## 6.8 According to the datasheet, what is the expected result of the read ID command?


## 6.9 Send the command byte, what did you get in return? (remember to prefix it with \x )


## 6.10 Is this what you expected?


## 6.11 What do you have to do to get the SPI flash to keep sending more data?


## 6.12 What happens if you pad zeros after the command byte?


## 6.13 What’s the command to return the the ID?


## 6.13aa Is the unique ID to be considered a secret or a good device identifier?


## 6.13a Take a look at the capture of the SPI ID, can you manually and/or programmatically decode it?

## 6.14 Now lets try flashrom. First we need some details about the flash. Run flashrom with the following parameters: flashrom -p linux_spi:dev=/dev/spidev1.0,spispeed=25000. How big is the flash size?


## 6.15 Use the dd command and create a random file that’s is the exact size you need.


## 6.16 Write the contents of the file to the flash.

## 6.17 Read back the flash into a new file.

## 6.18 Are they the same?

