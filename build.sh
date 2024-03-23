#!/bin/sh
cp feeds.conf.default feeds.conf
echo "src-link QiuSimons /home/build/openwrt/QiuSimons" >>./feeds.conf

./scripts/feeds update QiuSimons
./scripts/feeds update packages
make defconfig
./scripts/feeds install -p QiuSimons -f mosdns

make package/mosdns/download V=s
make package/mosdns/check V=s
make package/mosdns/compile V=s
