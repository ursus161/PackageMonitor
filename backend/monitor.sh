#!/bin/bash

#tema itbi branch backend 

grep -E "status installed|status removed" /var/log/dpkg.log | \
#am luat doar liniie cu pachetele instalate sau sterse pt ca cel mai probabil la urmatoarea rulare se vor adauga si cele actualizate
awk '{print $1" "$2", "$4", "$5", "$6}' | \ 
sed 's/:amd64//g; s/:i386//g; s/:all//g'
#elimin arhitectura (amd64, intel, etc)
