# Reverse Engineering WitMotion BWT901CL Accelerometer

This project is concerned with reverse engineering the WitMotion BWT901CL accelerometer to enable its feed to be ingested through the kdb+ TICK arhcitecture.
<br>

20:20:08:24:49:23       HC-06

### Disclaimer

> This project was developed using:
> + `WitMotion H6159 accelerometer`
> + `Linux`
> + `kdb+/q`
> + `piconet`
> + ``
<br>

bluetoothctl

pair device

radio freq communication (rfcomm)
|
--> runs on top of l2cap (logical link controller and adaption protocol)

rfcomm bind rfcomm0 20:20:08:24:49:23

verify - rfcomm
ls /dev/rfcomm0

picocom /dev/rfcomm0 -b 115200 > stream.txt

hexdump -b stream.txt > stream_octal.log

hexdump -C stream.txt > temp.log 

cut -d$" " -f 3-10,12-19 temp.log > stream_hex.log 


*in q*


file: "c"$read1 `:stream_hex.log

assume that all records start with 55, i.e. split on 55

file: ssr[file; "\n"; " "]

(first is picocom meta data -- 54 79 70 65 20 5b 43 2d 61 5d 20 5b 43 2d 68 5d 20 74 6f 20 73 65 65 20 61 76 61 69 6c 61 62 6c 65 20 63 6f 6d 6d 61 6e 64 73 0d 0a 0d 0a 54 65 72 6d 69 6e 61 6c 20 72 65 61 64 79 0d 0a)



cmds: ("55 ",) each trim 1 _ "55" vs ssr[file; "\n"; " "]

count each group (1 _) each (2#) each (" " vs) each cmds
"50"| 1212
"51"| 1212
"52"| 1212
"53"| 1212
""  | 4


hex_to_dec: {[dec] :16 sv "0123456789abcdef"?/:/:dec}



q)cmd_50_time
"55 50 15 01 13 16 02 34 64 00 7e"

0x55 0x50 YY MM DD hh mm ss msL msH SUM
YY：Year, 20YY Year
MM：Month
DD：Day
hh：hour
mm：minute
ss：Second
ms：Millisecond
Millisecond calculate formula：
ms=((msH<<8)|msL)
Sum=0x55+0x51+YY+MM+DD+hh+mm+ss+ms+VL


0x55 
0x50
0x15 - YY - hex_to_dec (" " vs cmd_50_time)[2] = 21 ./ (21)
0x01 - MM - hex_to_dec (" " vs cmd_50_time)[3] = 1 x (3)
0x13 - DD - 19 x (11)
0x16 - hh - 22 x (12/1)
0x02 - mm - 2 
0x34 - ss - 52
0x64 - msL - 100
0x00 - msH - 0
0x7e - sum - 126

calcs:

ms = ((msH << 8) | msL) = idk what | means
   = ((0 << 8) | 100)
   = idk what | means?


--------------------------------------------------------------------------------------------------------------------------------


q)cmd_51_acc
"55 51 80 00 e8 00 e2 07 e5 0c e8"

0x55 0x51 AxL AxH AyL AyH AzL AzH TL TH SUM

ax=((AxH<<8)|AxL)/32768*16g(g is Gravity acceleration, 9.8m/s2)
ay=((AyH<<8)|AyL)/32768*16g(g is Gravity acceleration, 9.8m/s2)
az=((AzH<<8)|AzL)/32768*16g(g is Gravity acceleration, 9.8m/s2)

Temperature calculated formula：
T=((TH<<8)|TL)/100 ℃

Checksum：
Sum=0x55+0x51+AxH+AxL+AyH+AyL+AzH+AzL+TH+T

0x55
0x51 
0x80 - axL - 128
0x00 - axH - 0
0xe8 - ayL - 232
0x00 - ayH - 0
0xe2 - azL - 226
0x07 - azH - 7
0xe5 - tempL - 229
0x0c - tempH - 12
0xe8 - sum - 232

ax = ((axH << 8) | axL) / 32768 * 16g(g is Gravity acceleration, 9.8m/s^2)
   = ((0 << 8) | 226) / 32768 * 156.8


Note：
1. The data is sent in hexadecimal, not ASCII code. Each data is transmitted in turn of low byte and high byte, and the two are
combined into a signed short type data. For example, X-axis acceleration data Ax, where AxL is low byte and AxH is
high byte. The conversion method is as follows:
Assuming that Data is actual data, DataH is its high byte, and DataL is its
low byte, then: Data = (short) (DataH << 8 | DataL). It must be noted that DataH needs to be coerced into a signed short data
and then shifted, and the data type of Data is also a signed short type, so
that it can represent negative numbers.


--------------------------------------------------------------------------------------------------------------------------------


q)cmd_52_av
"55 52 01 00 00 00 00 00 8f 01 38"


0x55 0x52 wxL wxH wyL wyH wzL wzH VL VH SUM

Calculated formula：
wx=((wxH<<8)|wxL)/32768*2000(°/s)
wy=((wyH<<8)|wyL)/32768*2000(°/s)
wz=((wzH<<8)|wzL)/32768*2000(°/s)

Battery Voltage calculated formula：
Battery Voltage=((VH<<8)|VL) /100 V
Checksum：
Sum=0x55+0x52+wxH+wxL+wyH+wyL+wzH+wzL+VH+VL

0x55
0x52 
0x01 - wxL - 1
0x00 - wxH - 0
0x00 - wyL - 0
0x00 - wyH - 0
0x00 - wzL - 0
0x00 - wzH - 0
0x8f - VL - 143
0x01 - VH - 1
0x38 - sum - 56

wx = ((wxH << 8) | wxL) / 32768 * 2000 (°/s)
   = ((0 << 8)) | 1) / 32768 * 2000
   = 

--------------------------------------------------------------------------------------------------------------------------------



q)cmd_53_ang
"55 53 a7 08 27 f9 a6 95 2c 29 07"


0x55 0x53 RollL RollH PitchL PitchH YawL YawH VL VH SUM

Roll(X axis)Roll=((RollH<<8)|RollL)/32768*180(°)
Pitch(Y axis)Pitch=((PitchH<<8)|PitchL)/32768*180(°)
Yaw(Z axis)Yaw=((YawH<<8)|YawL)/32768*180(°)

Version calculated formula：
Version=(VH<<8)|VL

Checksum：
Sum=0x55+0x53+RollH+RollL+PitchH+PitchL+YawH+YawL+VH+VL

0x55 
0x53
0xa7 - rollL - 167
0x08 - rollH - 8
0x27 - pitchL - 39
0xf9 - pitchH - 249
0xa6 - yawL - 166
0x95 - yamH - 149
0x2c - VL - 44
0x29 - VH - 41
0x07 - sum - 7


roll = ((rollH << 8) | rollL) / 32768 * 180(°)
     = ((8 << 8) | 167) / 32768 * 180(°)


Note：
1. The coordinate system used for attitude angle settlement is the
northeast sky coordinate system. Place the module in the positive
direction, as the figure shown in Chapter 3.3, direction left is the Y-axis, the direction forward is the X-axis, and direction upward is the Z-axis. Euler angle represents the rotation order of the coordinate system when
the attitude is defined as Z-Y-X, that is, first turn around the Z-axis, then
turn around the Y-axis, and then turn around the X-axis. 2. Although the range of the roll angle is ± 180 degrees, in fact, since the
coordinate rotation sequence is Z-Y-X, when expressing the attitude, the
range of the pitch angle (Y-axis) is only ± 90 degrees, and it will change
to less than 90 after exceeding 90 degrees Degrees while making the
X-axis angle greater than 180 degrees. For detailed principles, please
Google Euler angle and posture-related information. 3. Since the three axes are coupled, they will show independent changes
only at small angles, and the attitude angles will change at large angles. For example, when the Y-axis is close to 90 degrees, even if the attitude
only rotates around the Y-axis, the angle of the axis will also change
greatly, which is an inherent problem with Euler angles indicating
attitude.








from dataset.pdf - communication protocol
|
--> TTL level?
--> baud rate = 115200 (default, cannot change)
--> stop bit = 0
--> parity bit = 0

H = high, L = low
time output in hex:
0x55 0x50 YY MM DD hh mm ss msL msH SUM

ls = 55 in hex
0x50 = 50 in hex
YY = year = xxYY
MM = month = 12?
DD = day = 03?
hh = hour = 24hr
mm = minute = 02?
ss = second = 02?
ms = millisecond = ((msH<<8)|msL) [shifting bits - signed or not]
SUM = 0x55 + 0x50 + YY + MM + DD + hh + mm + ss + ms + VL?


The project was developed on Linux Ubuntu 16.04 LTS

> *This software was last ran on 05/03/2021.*
<br>

## Introduction

This package allows users to send basic commands to the Govee H6159 Wi-Fi and Bluetooth LED light strip through the CLI.
<br>

## Getting Started

Follow the instructions below to send commands to the light strip.
<br>

### Prerequisites

This project uses CLI commands which have been depreciated in later versions of Linux. This project assumes that these tools are installed on your local machine but it notes alternative commands that can be used when appropriate.
<br>

#### Elevate permissions to root

Run the super user command and enter your password when prompted:

```

sudo su

```
<br>

#### Ensure Bluetoothd is running

Run the system command to bring up your Bluetooth daemon service:

```

systemctl start bluetoothd

```
*or*
```

service bluetoothd start

```

To check bluetoothd is running, run the following:

```

systemctl status bluetoothd

```
*or*
```

service bluetoothd status

```

You should get a read out like:

```

● bluetooth.service - Bluetooth service
   Loaded: loaded (/etc/systemd/system/bluetooth.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2020-11-06 21:38:45 CET; 6s ago
     Docs: man:bluetoothd(8)
 Main PID: 2434 (bluetoothd)
   Status: "Running"
    Tasks: 1 (limit: 4915)
   CGroup: /system.slice/bluetooth.service
           └─2434 /usr/lib/bluetooth/bluetoothd

```
<br>

#### Ensure Bluetooth adaptor is up

Run the command below to bring up your registered Bluetooth adaptor:

```

hcitool dev up

```

To verify your Bluetooth adaptor is up, run this command:

```

hcitool dev

```

You should get a read out like this:

```

Devices:
        hci0    74:DF:BF:37:DA:C0

```
<br>

### Installation

To install this project on your local machine, follow these instructions:

1. Clone this repo to your local machine:
```

git clone <HTTPS URL>/govee-h6159-light-strip-reverse-engineer.git /path/to/proj/

```
<br>

2. Turn on your H6159 light strip.
<br>


### Configuration

To configure this application follow these steps.
<br>


##### Discover your H6159 light strip's MAC address
___

In a Linux terminal run the following commands:

```

bluetoothctl

```
*then in the Bluetooth controller prompt*
```

scan on

```
*then after a few seconds*
```

scan off

```
*finally, search through the printed MAC addresses for the light strip's, it should look something like this*
```

[NEW] Device A4:C1:38:F5:02:DB ihoment_H6159_51324

```
*or*
```

hcitool scan

```
*then search through the printed MAC addresses for the light strip's, it should look something like this*
```

[NEW] Device A4:C1:38:F5:02:DB ihoment_H6159_51324

```

> **Note:** If the light strip was undetected, run the above command with lescan rather than scan.
<br>

##### Verify your H6159 light strip

This is an optional step to verify that our MAC address is correct by running the following:

```

hcitool info A4:C1:38:F5:02:DB

```

You should get something similar to the following:

```

Requesting information ...
        Handle: 32 (0x0020)
        LMP Version: 4.2 (0x8) LMP Subversion: 0x22bb
        Manufacturer: Telink Semiconductor Co. Ltd (529)
        Features: 0x39 0x00 0x00 0x00 0x00 0x00 0x00 0x00

```
<br>

##### Alter the script to point to your light's MAC address

In the scripts change the placeholder MAC address with your light's:

```

gatttool -b A4:C1:38:F5:02:DB --char-write-req --handle 0x0015 --value 3305020000FF00000000000000000000000000CB > /dev/null

```
<br>

### Operation

Follow the steps below to operate your lights.
<br>

#### Turn the lights on or off

Run the corresponding script:
```

sh ./bin/turn_lights_[on|off].sh
```
<br>

#### Change the lights colour to red, green or blue

Run the corresponding script:
```

sh ./bin/change_lights_colour_to_[red|green|blue].sh

```
<br>

## Issues

#### No Bluetooth adaptors detected

If running the following command:

```

hcitool dev

```

Results in:

```

Devices:
        _____


```

Your Linux OS does not recongise any Bluetooth adaptors. 
This is likely if you are running Linux non-natively, i.e. Virtual Machine, virtualisation, etc.
Install Linux natively as a dual-boot OS or seek online advice.
<br>

## Author

[Marc Templeton](https://github.com/jurassic-marc) | [LinkedIn](https://www.linkedin.com/in/marc-templeton/) | [Medium](https://medium.com/@marctempleton)