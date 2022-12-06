btcom -b "20:20:08:24:49:23" -c

$port = new-Object System.IO.Ports.SerialPort ([System.IO.Ports.SerialPort]::GetPortNames()[0]),115200

$port.open()

while ($true) { $port.readexisting() > ../../log/stream_live.txt; sleep -seconds 5}