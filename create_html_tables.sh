#!/bin/bash

for i in $(ls /data/zbackup); do
    echo "<table border=\"1\">"  
    while read INPUT ; do 
          echo "<tr><td>${INPUT//,/</td><td>}</td></tr>"  
    done < $i  
    echo "</table>"
done
