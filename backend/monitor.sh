#!/bin/bash

#tema itbi branch backend 

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#calea universala catre directorul scriptului --> bash_source[0] e calea catre scriptul curent 
csv_file="$SCRIPT_DIR/../data/packages.csv"
last_run_file="$SCRIPT_DIR/../data/.last_run"
fisier_de_lucru=$(mktemp)
#fisier temporar in care sa prelucrez date inainte de append la csv main

if [ -f "$last_run_file" ]; then
    last_timestamp=$(cat "$last_run_file")
    awk -v ts="$last_timestamp" '$1" "$2 > ts' /var/log/dpkg.log | grep -E "status installed|status removed" | awk '{print $1" "$2","$4","$5","$6}' | sed 's/:amd64//g; s/:i386//g; s/:all//g' > "$fisier_de_lucru" 
#prelucrez fisiere mai noi decat ultima rulare
else
    grep -E "status installed|status removed" /var/log/dpkg.log | awk '{print $1" "$2","$4","$5","$6}' | sed 's/:amd64//g; s/:i386//g; s/:all//g' >> "$fisier_de_lucru"
    #am luat doar liniie cu pachetele instalate sau sterse pt ca cel mai probabil la urmatoarea rulare se vor adauga si cele actualizate
    #elimin arhitectura (amd64, intel, etc) cu sed
fi
if [ -f "$csv_file" ]; then
    tail -n +2 "$csv_file" >> "$fisier_de_lucru"
fi #+2 ca sa sara headerul vechiului csv

echo "timestamp,action,package,version" > "$csv_file"
sed -i 's/ ,/,/g; s/, /,/g' "$fisier_de_lucru" #am observat spatii fara sens in csv si asa le sterg
sort -u "$fisier_de_lucru" >> "$csv_file" #flagul -u e pt unic


current_states="$SCRIPT_DIR/../data/current_packages.csv"

echo "package,version" > "$current_states" 
dpkg-query -W -f='${Package},${Version}\n' >> "$current_states"
#aici citesc din var/lib/dpkg/status in loc de var/log/dpkg.log, nu mai prezint tot istoricul precum in packages.csv
#se va afla in current_packages.csv doar statusul curent al pachetelor
date "+%Y-%m-%d %H:%M:%S" > "$last_run_file"

rm -f "$fisier_de_lucru"