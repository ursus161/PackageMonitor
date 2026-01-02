csv_file="../data/packages.csv" #iau datele necesare din csv

lista_pachete() {
  echo "=============================== Lista de pachete ============================== "
  echo "Optiuni:"
  echo "1. Pachete instalate si data ultimei instalari"
  echo "2. Pachete instalate, dar eliminate si data ultimei eliminari"
  echo "Introduceti optiunea (1/2):"
  read optiune
  case $optiune in
    1) pachete_instalate
      ;;
    2) pachete_eliminate
      ;;
    *)
      echo "Optiune invalida. Incearca din nou."
            echo ""
            echo "Apasă ENTER pentru a reveni la meniu..."
            read
            ;;
  esac
}

pachete_instalate() {
  echo "============================== Pachete instalate ============================== "
  echo ""
  tail -n +2 "$csv_file" | awk -F',' '
  {
    date = $1
    action = $2
    package = $3
    version = $4

    if (action == "installed") {
      is_installed[package] = 1
      install_date[package] = date
    } else if (action == "removed") {
      is_installed[package] = 0
    }
  }
  END {
    i = 0
    printf "%-25s %-20s\n", "DATA ULTIMEI INSTALARI", "PACHET"
    for (p in is_installed) {
      if(is_installed[p] == 1) {
        printf "%-25s %-20s\n", install_date[p], p
        i++
      }
    }
    print "============================================================================"
      print "Total pachete instalate : " i
  }'

  echo ""
  echo "Apasa ENTER pentru a reveni la meniu.."
  read
}

pachete_eliminate() {
  echo "============================= Pachete eliminate ============================="
  echo ""
  tail -n +2 "$csv_file" | awk -F',' '
    {
      date = $1
      action = $2
      package = $3

      last_action[package] = action

      if (action == "removed") {
        last_removed_date[package] = date
      }
    }
    END {
      i = 0
      printf "%-25s %-20s\n", "DATA ULTIMEI ELIMINARI", "PACHET"
      for (p in last_action) {
        if(last_action[p] == "removed") {
          printf "%-25s %-20s\n", last_removed_date[p], p
          i++
        }
      }
      print "============================================================================"
      print "Total pachete eliminate : " i
  }'

  echo ""
  echo "Apasa ENTER pentru a reveni la meniu.."
  read
}

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
    echo "1. Lista pachete" #1 va contine functionalitatea 1 si 2. ulterior, se cere care dintre ele
    echo "2. Istoric pachet" #asta e functionalitatea 3
    echo "3. Interval timp pachet" #pachetele instalate/eliminate într-un interval de timp.
    echo "4. Iesire" #bye bye
    echo "======================="
    echo "Introduceti optiunea (1-4):"
    read optiune

    case $optiune in
        1)  lista_pachete
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

