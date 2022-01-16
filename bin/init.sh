# find and pair is outside scope of this
sudo rfcomm bind rfcomm0 20:20:08:24:49:23

# Access to the port 'COM4' is denied -- start back here, remove com4 (bluetooth more options)
# System Error.  Code: 87. The parameter is incorrect -- look at Bluetooth advanced, COMn already setup
# The specified service does not exist as an installed service -- means Bluetooth is off
btcom -b "20:20:08:24:49:23" -c # advanced BT shows COMn outgoing

sudo picocom /dev/rfcomm0 -b 115200 > ../log/stream_live.txt

[System.IO.Ports.SerialPort]::GetPortNames() # COM4

$port = new-Object System.IO.Ports.SerialPort COM4,115200

# A device which does not exist was specified -- means COM port not setup, return to btcom
# Access to the port 'COMn' is denied -- means , remove COMn in more BT options, rerun
# "The port 'COM3' does not exist. -- means COM port isn't correct, run/check in BT options
$port.open() # flashing stops

while ($true) { $port.readexisting() > stream_live.txt; start-sleep -seconds 5}