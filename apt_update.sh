#!/bin/sh

[ -f "./.env" ] && . ./.env

#echo "Acquire::http { Proxy \"http://${PROXY_GOST}:3142\"; };" > /etc/apt/apt.conf.d/00_proxy

echo "Acquire::http { Proxy \"http://${PROXY_HOST}:3142\"; };" | sudo tee /etc/apt/apt.conf.d/00_proxy

sudo find /etc/apt/sources.list /etc/apt/sources.list.d/ -type f -exec sed -e 's|^\([^#]* .*\)\(https://\)|\1http://https///|g' -i {} \;
