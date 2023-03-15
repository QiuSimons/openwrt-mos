#!/bin/sh
cp feeds.conf.default feeds.conf
echo "src-link QiuSimons /home/build/openwrt/QiuSimons" >> ./feeds.conf
sudo apt update
sudo apt install upx -y
cp /usr/bin/upx /home/build/openwrt/staging_dir/host/bin/
cp /usr/bin/upx-ucl /home/build/openwrt/staging_dir/host/bin/

./scripts/feeds update QiuSimons
./scripts/feeds update packages
make defconfig
./scripts/feeds install -a -p QiuSimons
./scripts/feeds install -a -p packages

make package/mosdns/download V=s
make package/mosdns/check V=s
make package/mosdns/compile V=s