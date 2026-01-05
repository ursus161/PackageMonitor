#!/bin/bash

fisier_mare=$(pwd) #sa ma intorc cand vreau

chmod +x backend/*.sh 2>/dev/null
chmod +x front-end/*.sh 2>/dev/null

if [ -d "backend" ]
    then 
    cd backend 
    if [ $? -ne 0 ]
    then
        echo "Nu am putut intra in backend"
        exit 1
    fi
    ./monitor.sh
    if [ $? -ne 0 ]
    then
        echo "monitor.sh a esuat"
        exit 1
    fi

    cd "$fisier_mare"
    if [ $? -ne 0 ]
    then
        echo "Nu ma pot intoarce in directorul initial"
        exit 1
    fi
else
    echo "Nu am putut gasi folderul backend"
    exit 1
fi

if [ -d "front-end" ]
    then
    cd front-end
    if [ $? -ne 0 ]
    then
        echo "Nu pot intra in front-end"
        exit 1
    fi
    ./monitor_ui.sh
    if [ $? -ne 0 ]
    then
        echo "monitor_ui.sh a esuat"
        exit 1
    fi


    cd "$fisier_mare"
    if [ $? -ne 0 ]
    then
        echo "Nu ma pot intoarce in directorul initial"
        exit 1
    fi
else
    echo "Nu am putut gasi folderul front-end"
    exit 1
fi

exit 0

    
