while true; do
  hexdump -C stream.txt > temp.log 
  cut -d" " -f 3-10,12-19 temp.log | tail -n +4 > stream_hex.log 
done
