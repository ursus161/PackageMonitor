#!/bin/bash

CSV="../data/packages.csv"


echo "test duplicate..."
BEFORE=$(wc -l < "$CSV")
./monitor.sh > /dev/null 2>&1
AFTER=$(wc -l < "$CSV")
if [ "$BEFORE" -eq "$AFTER" ]; then
    echo "perfect"
else
    echo "duplicate: $BEFORE si $AFTER"
fi