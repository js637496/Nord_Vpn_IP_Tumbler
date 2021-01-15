#!/bin/bash
OUTPUT=$(which nordvpn)
if ! [[ "$OUTPUT" =~ .*"nordvpn".* ]]; then
    sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh)
fi

INTERVAL="10s"

if [ "$1" ]
  then
    INTERVAL="$1s"
fi

echo "Interval set to ${INTERVAL}"

IFS=$'\r\n' GLOBIGNORE='*' command eval  'SERVERS=($(cat ./nordvpnservers.conf))'

echo "${#SERVERS[@]} US Nord VPN Servers"

while true; do 
    SERVERS=( $(shuf -e "${SERVERS[@]}") )
    for i in "${SERVERS[@]}"
    do
      OUTPUT=$(nordvpn connect us${i})
      echo "${OUTPUT}"
      #if the connection failed, try to get another one without waiting for the interval
      if [[ "$OUTPUT" =~ .*"You are connected".* ]]; then
        sleep ${INTERVAL}
      fi
    done
done