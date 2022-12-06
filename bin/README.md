# Reverse Engineering WitMotion BWT901CL Accelerometer

## Getting Started

Follow the instructions below to display your accelerometer's data.
<br>

### Prerequisites

<br>

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

_or_

```

service bluetoothd start

```

To check bluetoothd is running, run the following:

```

systemctl status bluetoothd

```

_or_

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

---

In a Linux terminal run the following commands:

```

bluetoothctl

```

_then in the Bluetooth controller prompt_

```

scan on

```

_then after a few seconds_

```

scan off

```

_finally, search through the printed MAC addresses for the accelerometer's, it should look something like this_

```

[NEW] Device 20:20:08:24:49:23  HC-06

```

_or_

```

hcitool scan

```

_then search through the printed MAC addresses for the accelerometer's, it should look something like this_

```

[NEW] Device 20:20:08:24:49:23  HC-06

```

> **Note:** If the accelerometer was undetected, run the above command with lescan rather than scan.
> <br>

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

> **Note**: The [stream scripts](#start-and-record-the-accelerometer's-stream) run in the background so can be ran in the same terminal, however the [kdb+ server](#bring-up-the-kdb+-server) and [KX Dashboards server](#bring-up-the-kx-dashboards-server) run in the foreground so 2 terminal tabs are required.

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
> <br>

#### Configure a dashboard

To configure your data connection and UI components, follow this [video](https://www.youtube.com/watch?v=yKzFR2Knq3c).

> **Note**: The port used for the kdb server is 6010.
> <br>

## Issues

#### No Bluetooth adaptors detected

If running the following command:

```



```

Results in:

```

.

```

The specified service does not exist as an installed service -- means Bluetooth is off
<br>

#### Access to the port COMx is denied

If running the following command:

```



```

Results in:

```

.

```

Access to the port 'COM4' is denied -- start back here, remove com4 (bluetooth more options)
remove COMn in more BT options, rerun
<br>

#### System Error. Code: 87

If running the following command:

```



```

Results in:

```

.

```

System Error. Code: 87. The parameter is incorrect -- look at Bluetooth advanced, COMn already setup, otherwise restart BT and try again
<br>

#### The port 'COM3' does not exist

If running the following command:

```



```

Results in:

```

.

```

"The port 'COM3' does not exist. -- means COM port isn't correct, run/check in BT options -- if null check device manager for RFCOMM error, try unpairing and repairing device, otherwise seek online help
<br>

#### A device which does not exist was specified

If running the following command:

```



```

Results in:

```

.

```

A device which does not exist was specified -- means COM port not setup, return to btcom
<br>

#### The port is already open

If running the following command:

```

hcitool dev

```

Results in:

```

Devices:
        _____


```

The port is already open -- device has lost connection (computer locks, etc), port.close() and port.open
<br>

# advanced BT shows COMn outgoing

# $port = new-Object System.IO.Ports.SerialPort ([System.IO.Ports.SerialPort]::GetPortNames()[0]),115200 -- assumes only port opened is outgoing and 1 we want, can change to your port -- advanced BT
