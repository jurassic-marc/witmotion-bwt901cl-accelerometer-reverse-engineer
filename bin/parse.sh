while true; do
  hexdump -C ../log/stream_live.txt > ../log/temp.log
  cut -d" " -f 3-10,12-19 ../log/temp.log > ../log/stream_hex_live.log
done

# install hexdump, link in PATH
while ($true) { 
  $port.readexisting() > stream_live.txt; #init
  echo "hello there young one" > stream_live.txt;

  hexdump -C stream_live.txt > temp.log;
  foreach($line in Get-Content temp.log){($line -split " ")[2..17] -join " " > stream_hex_live.log};

  foreach($line in Get-Content stream_live.txt){$line -split " " -join "-"  > stream_hex_live.log}
  start-sleep -seconds 5
}

out-file : The process cannot access the file 
'C:\Users\m_tem\Documents\witmotion-bwt901cl-accelerometer-reverse-engineer\stream_hex_live.log' because it is being used by     
another process.
At line:5 char:42
+ ... t temp.log){($line -split " ")[2..17] -join " " > stream_hex_live.log ...
+                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : OpenError: (:) [Out-File], IOException
    + FullyQualifiedErrorId : FileOpenFailure,Microsoft.PowerShell.Commands.OutFileCommand