#!/bin/bash

# This function will start our JSON text.
startJSON() {
  echo '{'
  echo '  "service" : ['
}

# This function will return a single block of JSON for a single service.
exportService() {
  echo '  {'
  echo '    "name":"'$1'",'
  echo '    "ipaddress":"'${ip}'",'
  echo '    "macaddress":"'${mac}'",'
  echo '    "ssid":"'${ssid}'"'
  echo '  }'
}

# This function will finish our JSON text.
endJSON() {
  echo '  ]'
  echo '}'
}

# Start the JSON.
startJSON

# Output the Ethernet information.
ip=$(/usr/sbin/networksetup -getinfo 'usb ethernet' | grep -Ei '(^IP address:)' | awk '{print $3}')
mac=$(/usr/sbin/networksetup -getinfo 'usb ethernet' | grep -Ei '(^Ethernet address:)' | awk '{print $3}')
exportService "ethernet"

# Place a comma between services.
echo '  ,'

# Output the Wi-Fi information.
ip=$(/usr/sbin/networksetup -getinfo wi-fi | grep -Ei '(^IP address:)' | awk '{print $3}')
mac=$(/usr/sbin/networksetup -getinfo wi-fi | grep -Ei '(^Wi-Fi ID:)' | awk '{print $3}')
ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | egrep ' +SSID' | sed 's/.*SSID: //')
exportService "wi-fi"

# End the JSON
endJSON
