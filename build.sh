#!/bin/sh
cp feeds.conf.default feeds.conf
echo "src-link QiuSimons /home/build/openwrt/QiuSimons" >> ./feeds.conf

./scripts/feeds update QiuSimons
./scripts/feeds update packages
make defconfig
./scripts/feeds install -a -p QiuSimons
./scripts/feeds install -a -p packages

make package/mosdns/download V=s
make package/mosdns/check V=s
make package/mosdns/compile V=s