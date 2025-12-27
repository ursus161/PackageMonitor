csv_file="../data/packages.csv" #iau datele necesare din csv

istoric_pachet(){
    echo "Introdu numele pachetului:"
    read package_name

    echo "========================= Istoria pentru pachetul: $package_name ========================"
    echo ""
    rezultate=$(grep "$package_name" "$csv_file") #in rezultate am info bruta

    if [ -z "$rezultate" ]
    then
        echo "Nu am gasit informatii despre istoria pachetului '$package_name'"
    else
        #antet:
        printf "%-25s %-15s %-20s %-20s\n" "DATA" "ACTIUNE" "PACHET" "VERSIUNE" #prin printf pot aloca cate spatii vreau eu+aliniez la stanga
        echo "================================================================================"
        echo "$rezultate" | awk -F, '{printf "%-25s %-15s %-20s %-20s\n", $1, $2, $3, $4}' #basically rezultate.split(",")
        echo "================================================================================"
    fi


    echo ""
    echo "Apasa ENTER pentru a reveni la meniu"
    read
}






#main

while true
do
    clear
    echo "=== PACKAGE MONITOR ==="
    echo "Optiuni:"
    echo "1. Pachete instalate" #1 va contine functionalitatea 1 si 2. ulterior, se cere care dintre ele
    echo "2. Istoric pachet" #asta e functionalitatea 3
    echo "3. Interval timp pachet" #pachetele instalate/eliminate într-un interval de timp.
    echo "4. Iesire" #bye bye
    echo "======================="
    echo "Introduceti optiunea (1-4):"
    read optiune

    case $optiune in
        1) #whatever optiunea 1
            ;;
        2)
            istoric_pachet
            ;;
        3) 
            interval_pachet
            ;;
        4)
            echo "Bye!"
            exit 0
            ;;
        *) #placeholder for anything else
            echo "Optiune invalida. Try again."
            echo ""
            echo "Apasă ENTER pentru a reveni la meniu..."
            read
            ;;
    esac
done

