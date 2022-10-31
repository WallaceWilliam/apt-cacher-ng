#!/bin/sh

set -e
echo "$@"

if [ "${1}" = "apt-cacher-ng" ] || [ "${1}" = "$(which apt-cacher-ng)" ]
then
   [ ! -f /etc/apt-cacher-ng/security.conf ] && echo "AdminAuth: admin:redhat" > /etc/apt-cacher-ng/security.conf
#  cat /etc/apt-cacher-ng/acng.conf | grep '^[^#]'
  chmod 0777 /var/cache/apt-cacher-ng /var/log/apt-cacher-ng
#  touch /var/log/apt-cacher-ng/apt-cacher.log && ln -s /dev/stdout /var/log/apt-cacher-ng/apt-cacher.log
#  touch /var/log/apt-cacher-ng/apt-cacher.err && ln -s /dev/stderr /var/log/apt-cacher-ng/apt-cacher.err
#        /etc/init.d/apt-cacher-ng start && \
#        tail -f /var/log/apt-cacher-ng/*
  exec "$@"
else
  exec "$@"
fi
