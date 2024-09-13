#!/bin/bash

HOST_IP=''

while true; do
  ip=$(netstat -antp 2>/dev/null | awk '/anydesk/ && /SYN_SENT/ {print $5}' | cut -d: -f1)
  clear
  echo "Anydesk-Ipgrabber"
  echo "Esperando la conexion..."
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
  echo -e "\n${BGray}\tIP: ${On_Green}${BGreen}$IP${Color_Off}"
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
