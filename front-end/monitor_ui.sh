#!/bin/bash

csv_file="../data/packages.csv" 


istoric_pachet(){
    echo "Introdu numele pachetului:"
    read -r package_name

    echo "======================= Istoria pentru pachetul: $package_name ======================="
    echo ""
    rezultate=$(grep -w "$package_name" "$csv_file")

    if [[ -z "$rezultate" ]]
    then
        echo "Nu am gasit informatii despre istoria pachetului '$package_name'"
    else
        printf "%-25s %-15s %-20s %-20s\n" "DATA" "ACTIUNE" "PACHET" "VERSIUNE" 
        echo "================================================================================"
        echo "$rezultate" | awk -F, '{printf "%-25s %-15s %-20s %-20s\n", $1, $2, $3, $4}' 
        echo "================================================================================"
    fi


    echo ""
    echo "Apasa ENTER pentru a reveni la meniu"
    read -r
}

interval_pachete(){
    echo "Formatul datei este YYYY-MM-DD (exemplu: 2025-11-08)"
    echo "Introdu data de inceput:"
    read -r start

    if ! echo "$start" | grep -E "^[0-9]{4}-[0-9]{2}-[0-9]{2}$" > /dev/null #1 daca nu gaseste, 0 daca gaseste => negare
    then   
        echo "Data de inceput este invalida. Try again."
        interval_pachete
        return
    fi

    echo "Introdu data de sfarsit:"
    read -r end
    if ! echo "$end" | grep -E "^[0-9]{4}-[0-9]{2}-[0-9]{2}$" > /dev/null #1 daca nu gaseste, 0 daca gaseste
    then   
        echo "Data de sfarsit este invalida. Try again."
        interval_pachete
        return
    fi

    s_complet="$start 00:00:00"  
    e_complet="$end 23:59:59" 
    
    
    if [[ "$s_complet" > "$e_complet" ]]
    then
        echo "Data de inceput nu poate fi mai mare decat data de sfarsit. Try again."
        interval_pachete
        return
    fi

    
    gasit=0
    while IFS=, read -r data_csv actiune pachet versiune 
    do 
        
        if [[ "$data_csv" == "timestamp" ]]
        then continue 
        fi
        
        if [[ "$data_csv" > "$s_complet" || "$data_csv" == "$s_complet" ]] && [[ "$data_csv" < "$e_complet" || "$data_csv" == "$e_complet" ]]
        then
            ((gasit++))
            if [ $gasit -eq 1 ]
            then
                echo "Rezultate intre $start si $end:"
                echo "================================================================================"
                printf "%-25s %-15s %-20s %-20s\n" "DATA" "ACTIUNE" "PACHET" "VERSIUNE" 
                echo ""
            fi
             printf "%-25s %-15s %-20s %-20s\n" "$data_csv" "$actiune" "$pachet" "$versiune"
        fi

    done < "$csv_file"

    if [ $gasit -eq 0 ]
    then    
        echo "Nu am gasit niciun rezultat pentru acest interval"
    fi
    echo "================================================================================"

    echo ""
    echo "Apasa ENTER pentru a reveni la meniu"
    read -r
}




#MAIN

csv_ok=1
if [ -z "$csv_file" ]
then 
    echo "Nu am putut primi nicio informatie din fisierul CSV"
    csv_ok=0
fi

if [ ! -f "$csv_file" ]
then
    echo "Fisierul CSV nu exista"
    csv_ok=0
fi

while [[ $csv_ok -eq 1 ]]
do
    clear
    echo "=== PACKAGE MONITOR ==="
    echo "Optiuni:"
    echo "1. Pachete instalate" #1 va contine functionalitatea 1 si 2. ulterior, se cere care dintre ele (iasmina)
    echo "2. Istoric pachet" 
    echo "3. Interval timp pachete" 
    echo "4. Iesire" 
    echo "======================="
    echo "Introduceti optiunea (1-4):"
    read -r optiune

    case $optiune in
        1) 
            ;;
        2)
            istoric_pachet
            ;;
        3) 
            interval_pachete
            ;;
        4)
            echo "Bye!"
            exit 0
            ;;
        *) #placeholder for anything else
            echo "Optiune invalida. Try again."
            echo ""
            echo "Apasa ENTER pentru a reveni la meniu..."
            read -r
            ;;
    esac
done

