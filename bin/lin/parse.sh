while true; do
  hexdump -C ../../log/stream_live.txt > ../../log/temp.log
  cut -d" " -f 3-10,12-19 ../../log/temp.log >> ../../log/stream_hex_live.log
done