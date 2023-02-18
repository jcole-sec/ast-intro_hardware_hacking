# LAB 2

## Let's do some basic embedded Linux recon:


### 2.1 What version of uboot is running?

2019.01


### 2.2 What version of the kernel is running?

4.19.0


### 2.3 Why do you think the MAC address is randomly generated?

Digilent was like, YOLO, also they don’t have a dedicated memory device to store the ID.


### 2.4 What’s the init system in use?

systemd

### 2.5 How big is the rootfs partition?

512MB

## Blink an LED from Linux

We want to blink an LED from Linux and we’ll use the ARM core’s GPIO controller to toggle the 4 green LEDs. Documentation for any hardware is very hardware specific, for the Zynq 7000, the source documentation is here: https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842398/Linux+GPIO+Driver

The first step is we have to export the gpio with a command like:

`echo "XXX” > /sys/class/gpio/export`

Where XXX is the GPIO number, we need to figure this out.

### 2.6 What’s in your `/sys/class/gpio` directory?

The list of GPIO peripherals

### 2.7 The ARM’s GPIOs start at 900 (`gpiochip900`). We are using an Extended Mixed I/O pin that is at an offset of 54 from the base. The green LEDs are EMIO Pins 0, 1, 2, 3. What do you think are the four GPIO numbers you need to export?

954, 955, 956, 957

### 2.8 Go ahead and export those with the previous command, then you need to set the direction to output with the command like so:

`echo "out" > /sys/class/gpio/gpioXXX/direction`

### 2.9 How do you turn on and off the leds?

`echo 1 > /sys/class/gpio/gpio955/value`

## Now lets go FORTH

You can run spearf0rth by typing in spearf0rth

Let’s build a basic driver for the PWM controller so we can have nice RGB LEDs. There’s a few things we need to know.

## 2.10 What are the base addresses for the pwm0 and pwm1 controllers?

0x43c00000, 0x43c10000

If you are curious, the only documentation for this PWM controller is the C code (https://github.com/Digilent/vivado-library/blob/master/ip/PWM_2.0/drivers/PWM_v1_0/src/PWM.c). 

## 2.11 The period register is an offset of 8, what is the period register for pwm0, and pwm1?

0x43c00008, 0x43c10008


## 2.12 There are 3 Leds attached to each PWM controller, red (index 0), green (index 1), blue (index 2). The duty cycle register is at an offset of 64 decimal from the base. Each index is 4 bytes offset from the duty cycle registers. What are the register address for each of the LEDs?

0x43c00040, 0x43c00044, 0x43c00048, 0x43c10040, 0x43c10044, 0x43c10048, 


Now lets write some forth. The key to forth is writing very small words. The philosophy is, each word should be simple enough it can’t contain a mistake.

## 2.13 Define two new words, pwm0, and pwm1, each of which simply will push the address of the base of the pwm controller onto the stack.

```
: pwm0 0x43c00000 ;
: pwm1 0x43c10000 ;
```


## 2.14 Define the words to return the period register address for each controller

```
: pwm0p pwm0 8 + ;
: pwm1p pwm1 8 + ;
```


These should be very simple words. In forth you start very simply and slowly build up.

## 2.15 Define a word that takes one value and pokes it into the memory of the period controller. The definition of poke is `( addr value -- )`. The way that is read is the top of the stack is the value to enter, followed by the address and the poke word will not return anything to the stack.

```
 : setp0 pwm0p swap poke ;
 : setp1 pwm1p swap poke ;
```


## 2.16 Set the period to each to 0xff

```
0xff setp0

0xff setp1
```


## 2.17 Define a word, for each LED, that returns the address of the duty cycle register

```
hex> : doffset 0x40 ;

hex> : sd0r pwm0 doffset + ;

hex> : sd0g pwm0 doffset + 4 + ;

hex> : sd0b pwm0 doffset + 8 + ;
```



## 2.18 Now define a word that takes three inputs on the stack, the red hex value, the green, the blue and sets all duty cycles

`hex> : rgb0 sd0b swap poke sd0g swap poke sd0r swap poke ;`


## 2.19 Define words to turn on and off the led (the base address is the control register)

```
: on pwm0 1 poke ;
: off pwm0 0 poke ;
```

## 2.19 Turn on each LED confirm it’s working

`00 00 0xff rgb0`

## 2.20 Make a purple LED, think of this like hex color values

`: purple0 6f 00 ff rgb0 ;`


