#!/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
monitor_script="$script_dir/monitor.sh"
cron_job="*/15 * * * * $monitor_script"

if crontab -l 2>/dev/null | grep -Fq "$monitor_script"; then
    echo "cron job exista!"
else
    (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
    #incarca lista curenta de cron jobs si adauga noul job
    #crontab - ia din stdin lista de cron jobs
    echo "cron job adaugat si ruleaza la fiecare 15 minute"
fi