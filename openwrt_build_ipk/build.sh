#!/bin/bash
echo "add git"
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall" >> feeds.conf.default
echo "feeds update"
./scripts/feeds update -a
echo "feeds install"
./scripts/feeds install luci-app-passwall

make defconfig

make package/luci-app-passwall/{clean,compile} -j1 V=s