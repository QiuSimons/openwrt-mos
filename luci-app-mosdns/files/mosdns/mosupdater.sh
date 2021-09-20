#!/bin/bash -e
set -o pipefail
rm -rf  /tmp/mosdns
mkdir /tmp/mosdns
wget https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat -nv -O /tmp/mosdns/geoip.dat
wget https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat -nv -O /tmp/mosdns/geosite.dat
find /tmp/mosdns/ -size -20k -exec rm {} \;
chmod -R  755  /tmp/mosdns
cp -rf /tmp/mosdns/* /etc/mosdns
exit 0
