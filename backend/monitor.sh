#!/bin/bash

#tema itbi branch backend 

csv_file="../data/packages.csv"

fisier_de_lucru=$(mktemp)
#fisier temporar in care sa prelucrez date inainte de append la csv main

if [ ! -f "$csv_file" ]; then
    echo "timestamp, status, packet, version" > "$csv_file"
fi 


grep -E "status installed|status removed" /var/log/dpkg.log | awk '{print $1" "$2","$4","$5","$6}' | sed 's/:amd64//g; s/:i386//g; s/:all//g' >> "$csv_file"
#am luat doar liniie cu pachetele instalate sau sterse pt ca cel mai probabil la urmatoarea rulare se vor adauga si cele actualizate
#elimin arhitectura (amd64, intel, etc) cu sed

if [ -f "$csv_file" ]; then
    tail -n +2 "$csv_file" >> "$fisier_de_lucru"
fi

echo "timestamp,action,package,version" > "$csv_file"
sort -u "$fisier_de_lucru" >> "$csv_file" #flagul -u e pt unic

rm -f "$fisier_de_lucru"