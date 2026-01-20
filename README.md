# PackageMonitor

Un sistem de monitorizare pentru pachete software pe Ubuntu/Debian.

## Despre proiect

PackageMonitor urmareste ce pachete instalez si elimin din sistem, oferind un istoric complet al modificarilor. Am construit backend-ul sa parseze automat logurile dpkg si sa genereze date structurate pe care frontend-ul le poate folosi usor.


## De ce l-am facut

Cand lucrezi pe un sistem o perioada lunga, pierzi urma a ce ai instalat si cand. PackageMonitor rezolva asta, pastrand un istoric complet si oferind un snapshot al starii curente a sistemului.

## Fisiere generate

### Istoric complet - packages.csv

Contine fiecare instalare si eliminare cu timestamp exact:

```csv
timestamp,action,package,version
2025-08-05 16:48:12,installed,vim,8.2.3995-1
2025-08-05 17:00:00,removed,gimp,2.10.34-1
```

### Stare curenta - current_packages.csv

Un snapshot cu exact ce e instalat acum:

```csv
package,version
vim,8.2.3995-1
firefox,120.0-1
```

### Optimizare - .last_run

Memoreaza cand a rulat ultima data, ca sa proceseze doar intrarile noi.

## Quick start

```bash
git clone https://github.com/ursus161/PackageMonitor.git
cd PackageMonitor/backend

chmod +x monitor.sh setup_cron.sh
./monitor.sh
./setup_cron.sh
```

Gata. Scriptul ruleaza automat la fiecare 30 de minute.

## Cum il folosesc

Verific datele oricand vreau:

```bash
cat data/packages.csv | head -20
cat data/current_packages.csv | head -20
```

Sau rulez manual pentru update instant:

```bash
cd backend && ./monitor.sh
```

## Arhitectura

```
PackageMonitor/
├── backend/
│   ├── monitor.sh        - parseaza logurile si genereaza CSV-uri
│   └── setup_cron.sh     - configureaza automatizarea
└── data/
    ├── packages.csv
    ├── current_packages.csv
    └── .last_run
```

## Cum functioneaza

Prima rulare proceseaza tot fisierul dpkg.log. Rularile urmatoare proceseaza doar intrarile noi de la ultima executie, deci e rapid.

Am folosit path-uri absolute pentru ca scriptul sa functioneze corect din cron, care ruleaza din root directory.

Backend-ul elimina duplicate automat si curata numele pachetelor de sufixe arhitectura.

## Pentru frontend

CSV-urile sunt gata de folosit pentru:

- Afisarea pachetelor instalate cu data ultimei instalari
- Listarea pachetelor eliminate
- Vizualizarea istoricului complet pentru un pachet
- Filtrarea operatiilor pe intervale de timp

## Stack tehnic

Bash cu grep, awk, sed si sort pentru procesare text. dpkg-query pentru starea curenta. Cron pentru automatizare.

Datele vin din /var/log/dpkg.log si /var/lib/dpkg/status.

## Probleme comune

**Scriptul nu ruleaza?**

```bash
chmod +x monitor.sh
```

**CSV-urile nu apar?**

```bash
mkdir -p data
```

**Cron-ul nu merge?**

```bash
crontab -l
grep CRON /var/log/syslog
```
