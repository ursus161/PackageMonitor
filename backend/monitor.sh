#!/bin/bash

#tema itbi branch backend 

csv_file="../data/packages.csv"

echo "timestamp, status, packet, version" > "$csv_file"

grep -E "status installed|status removed" /var/log/dpkg.log | awk '{print $1" "$2","$4","$5","$6}' | sed 's/:amd64//g; s/:i386//g; s/:all//g' >> "$csv_file"
#am luat doar liniie cu pachetele instalate sau sterse pt ca cel mai probabil la urmatoarea rulare se vor adauga si cele actualizate
#elimin arhitectura (amd64, intel, etc) cu sed
#aici in mod evident le dau append in fisierul CSV