while ($true) { 
  get-content ../../log/stream_live.txt | hexdump -C > ../../log/temp.log

  & { 
    foreach($line in get-content .././log/temp.log) { 
      ($line -split " ")[2..17] -join " " 
      } 
    } | out-file ../../log/stream_hex_live.log -append -force;

  sleep 2
    
}