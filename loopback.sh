#!/bin/bash
#turn NAT "Loopback" on and off

#Server IP
ip="192.168.0.5"

#Get SSID of current WiFi
ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')

echo "Connected to:" $ssid
#If home
if [ "$ssid" == "Internettet" ]; then
  if ! grep -Fq "israndom.win" /etc/hosts
    then
      echo "Home: setting /etc/hosts" >&2
      echo "#Domains for fake NAT loopback" >> /etc/hosts
      echo "$ip israndom.win" >> /etc/hosts
      echo "$ip nas.israndom.win" >> /etc/hosts
      echo "$ip cloud.israndom.win" >> /etc/hosts
    else
      echo "Home: /etc/hosts already set" >&2
  fi
else
#If away
  if grep -Fq "israndom.win" /etc/hosts
    then
      echo "Away: cleaning /etc/hosts" >&2
      sed -i '' "/$ip/d" /etc/hosts
      # cp /etc/hosts.bak /etc/hosts
    else
      echo "Away: /etc/hosts already clean" >&2
    fi
fi