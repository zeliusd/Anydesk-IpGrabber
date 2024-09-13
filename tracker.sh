#!/bin/bash

Black='\033[0;30m'  # Black
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
Purple='\033[0;35m' # Purple
Cyan='\033[0;36m'   # Cyan
White='\033[0;97m'  # White
Blink='\033[5m'     # Blink
Color_Off='\033[0m' # Text Reset

LGray='\033[0;90m'   # Ligth Gray
LRed='\033[0;91m'    # Ligth Red
LGreen='\033[0;92m'  # Ligth Green
LYellow='\033[0;93m' # Ligth Yellow
LBlue='\033[0;94m'   # Ligth Blue
LPurple='\033[0;95m' # Light Purple
LCyan='\033[0;96m'   # Ligth Cyan

BBlack='\033[1;30m'  # Black
BGray='\033[1;37m'   # Gray
BRed='\033[1;31m'    # Red
BGreen='\033[1;32m'  # Green
BYellow='\033[1;33m' # Yellow
BBlue='\033[1;34m'   # Blue
BPurple='\033[1;35m' # Purple
BCyan='\033[1;36m'   # Cyan
BWhite='\033[1;37m'  # White

IBlack='\033[3;30m'  # Black
IGray='\033[3;90m'   # Gray
IRed='\033[3;31m'    # Red
IGreen='\033[3;32m'  # Green
IYellow='\033[3;33m' # Yellow
IBlue='\033[3;34m'   # Blue
IPurple='\033[3;35m' # Purple
ICyan='\033[3;36m'   # Cyan
IWhite='\033[3;37m'  # White

UBlack='\033[4;30m'  # Black
UGray='\033[4;37m'   # Gray
URed='\033[4;31m'    # Red
UGreen='\033[4;32m'  # Green
UYellow='\033[4;33m' # Yellow
UBlue='\033[4;34m'   # Blue
UPurple='\033[4;35m' # Purple
UCyan='\033[4;36m'   # Cyan
UWhite='\033[4;37m'  # White
On_Black='\033[40m'  # Black
On_Red='\033[41m'    # Red
On_Green='\033[42m'  # Green
On_Yellow='\033[43m' # Yellow
On_Blue='\033[44m'   # Blue
On_Purple='\033[45m' # Purple
On_Cyan='\033[46m'   # Cyan
On_White='\033[47m'  # White

HOST_IP=''

echo "Anydesk | IPGRABBER "
echo "Esperando la conexion..."

while true; do
  ip=$(netstat -antp 2>/dev/null | awk '/anydesk/ && /SYN_SENT/ {print $5}' | cut -d: -f1)
  if [[ $(echo "$ip" | wc -l) -eq 1 && -n "$ip" ]]; then
    clear
    HOST_IP=$ip
    break
  fi

done

RESPONSE=$(curl -s "http://ip-api.com/json/$HOST_IP" --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31")

STATUS=$(echo "$RESPONSE" | grep -Po '(?<="status":)[^},]*' | tr -d '"')

if [[ $STATUS == "success" ]]; then
  IP=$(echo "$RESPONSE" | grep -Po '(?<="query":)[^},]*' | tr -d '"')
  COUNTRY=$(echo "$RESPONSE" | grep -Po '(?<="country":)[^},]*' | tr -d '"')
  CITY=$(echo "$RESPONSE" | grep -Po '(?<="city":)[^},]*' | tr -d '"')
  REGION=$(echo "$RESPONSE" | grep -Po '(?<="regionName":)[^},]*' | tr -d '"')
  LAT=$(echo "$RESPONSE" | grep -Po '(?<="lat":)[^},]*' | tr -d '"')
  LON=$(echo "$RESPONSE" | grep -Po '(?<="lon":)[^},]*' | tr -d '"')
  ISP=$(echo "$RESPONSE" | grep -Po '(?<="isp":)[^},]*' | tr -d '"')
  echo "========================================================"
  echo -e "\n${BGray}\tIP: ${On_Green}$IP${Color_Off}"
  echo -e "${BGray}\tPais: ${BGreen}$COUNTRY${Color_Off}"
  echo -e "${BGray}\tCiudad: ${BGreen}$CITY${Color_Off}"
  echo -e "${BGray}\tRegion: ${BGreen}$REGION${Color_Off}"
  echo -e "${BGray}\tLatitud: ${BGreen}$LAT${Color_Off}"
  echo -e "${BGray}\tLongitud: ${BGreen}$LON${Color_Off}"
  echo -e "${BGray}\tISP: ${BGreen}$ISP${Color_Off}\n"
  echo "========================================================"
  exit 0
else
  echo -e "\t\n${Cyan}[${BRed}✘${Cyan}] ${BRed}Error - No hay información de la IP${Color_Off}\n"
  exit 1
fi
