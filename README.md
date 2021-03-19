# Reverse Engineering WitMotion BWT901CL Accelerometer

This project is concerned with reverse engineering the WitMotion BWT901CL accelerometer to enable its feed to be ingested through the kdb+ TICK architecture.
<br>

### Disclaimer

> This project was developed using:
> + `WitMotion BWT901CL accelerometer`
> + `Linux`
> + `kdb+/q`
> + `KX Dashboards`
<br>

The project was developed on Linux Ubuntu 16.04 LTS.

> *This software was last ran on 18/03/2021.*
<br>

## Introduction

This package allows users to display stream information including acceleration, angular velocity and angle from the WitMotion BWT901CL accelerometer through KX Dashboards.
<br>

## Getting Started

Follow the instructions below to display your accelerometer's data.
<br>

### Prerequisites

#### Download and configure kdb+/q

To download and configure kdb+/q, follow this [link](https://kx.com/developers/#download).
<br>

#### Download KX Dashboards

To download KX Dashboards, follow this [link](https://code.kx.com/dashboards/gettingstarted/).
<br>

#### Ensure Bluetoothd is running


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

git clone <HTTPS URL>/witmotion-bwt901cl-accelerometer-reverse-engineer.git /path/to/proj/

```
<br>

2. Turn on your accelerometer.
<br>


### Configuration

To configure this application follow these steps.
<br>


##### Discover your BWT901CL accelerometer's MAC address
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
*finally, search through the printed MAC addresses for the accelerometer's, it should look something like this*
```

[NEW] Device 20:20:08:24:49:23  HC-06

```
*or*
```

hcitool scan

```
*then search through the printed MAC addresses for the accelerometer's, it should look something like this*
```

[NEW] Device 20:20:08:24:49:23  HC-06

```

> **Note:** If the accelerometer was undetected, run the above command with lescan rather than scan.
<br>

##### Verify your BWT901CL accelerometer

This is an optional step to verify that our MAC address is correct by running the following:

```

hcitool info 20:20:08:24:49:23

```

You should get something similar to the following:

```

Requesting information ...
        Handle: 32 (0x0020)
        LMP Version: 4.2 (0x8) LMP Subversion: 0x22bb
        Manufacturer: Telink Semiconductor Co. Ltd (529)~
        Features: 0x39 0x00 0x00 0x00 0x00 0x00 0x00 0x00

```
<br>

##### Alter the script to point to your BWT901CL accelerometer's MAC address

In the `./init.sh` script change the placeholder MAC address with your accelerometer's:

```

rfcomm bind rfcomm0 20:20:08:24:49:23

picocom /dev/rfcomm0 -b 115200 > stream.txt

```
<br>

### Operation

> **Note**: The [stream scripts](#start-and-record-the-accelerometer's-stream) run in the background see can be ran in the same terminal, however the [kdb+ server](#bring-up-the-kdb+-server) and [KX Dashboards server](#bring-up-the-kx-dashboards-server) run in the foreground so 2 terminal tabs are required.

Follow the steps below to display your accelerometer's stream.
<br>

#### Start and record the accelerometer's stream

Run the corresponding script:
```

sh ./bin/init.sh &

```
<br>

#### Parse the accelerometer's stream

Run the corresponding script:
```

sh ./bin/parse.sh &

```
<br>

#### Bring up the kdb+ server

Run the corresponding script:
```

q ./q/init.q

```
<br>

#### Bring up the KX Dashboards server

Run the corresponding script:
```

q dash.q -p 10001 -u 1

```

> **Note**: This must be ran inside the [KX Dashboards folder](#download-kx-dashboards).
<br>

#### Configure a dashboard

To configure your data connection and UI components, follow this [video](https://www.youtube.com/watch?v=yKzFR2Knq3c).

> **Note**: The port used for the kdb server is 6010.
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