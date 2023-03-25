#!/bin/bash

if [ ! -f feeds.conf.default ]; then
    echo "must run this script in the top of openwrt source dir"
    exit 1
fi

# clean first
echo "step 1: clean old build & tmp"
make clean
rm -rf .tmp

# feed update
echo "step 2: reset & update feeds"

./scripts/feeds update -af

# rm smartdns from offical feed, use moow_package one
if [ -d "$(pwd)/feeds/packages/net/smartdns" ];then
    rm -rf "$(pwd)/feeds/packages/net/smartdns"
fi

if [ -d "$(pwd)/feeds/luci/applications/luci-app-smartdns" ];then
    rm -rf "$(pwd)/feeds/luci/applications/luci-app-smartdns"
fi

./scripts/feeds update -ai
./scripts/feeds install -af

read -p 'continue to build world?(y/n)' answer

case "$answer" in 
    [yY]|[yY][eE][sS] )
        echo "step 3: build"
        cp -a makeconfig.d/x86_64.config .config
        make -j "$(nproc)" ||  make -j1 V=s
        ;;
    [nN]|[nN][oO] )
        ;;
    * )
        echo "please input y/n."
        ;;
esac
