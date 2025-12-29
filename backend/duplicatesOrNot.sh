#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CSV="$SCRIPT_DIR/../data/packages.csv"


echo "test duplicate..."
BEFORE=$(wc -l < "$CSV")
./monitor.sh > /dev/null 2>&1
AFTER=$(wc -l < "$CSV")
if [ "$BEFORE" -eq "$AFTER" ]; then
    echo "perfect"
else
    echo "duplicate: $BEFORE si $AFTER"
fi

#ideea scriptului: 
#rulez monitor.sh si verific daca numarul de linii din packages.csv a ramas acelasi