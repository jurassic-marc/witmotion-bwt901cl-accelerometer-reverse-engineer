sudo rfcomm bind rfcomm0 20:20:08:24:49:23

sudo picocom /dev/rfcomm0 -b 115200 > ../log/stream_live.txt
