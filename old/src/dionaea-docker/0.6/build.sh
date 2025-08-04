#!/bin/bash

DIONAEA_VERSION=0.6.0

BUILD_PKGS="autoconf automake build-essential check cython3 libcurl4-openssl-dev libemu-dev libev-dev libglib2.0-dev libloudmouth1-dev libnetfilter-queue-dev libpcap-dev libssl-dev libtool libudns-dev python3-dev wget"

RUN_PKGS="ca-certificates python3 python3-yaml"
LIB_PKGS="libcurl3 libemu2 libev4 libglib2.0-0 libnetfilter-queue1 libpcap0.8 libpython3.5 libudns0"

# Speedup
#echo 'force-unsafe-io' | tee /etc/dpkg/dpkg.cfg.d/02apt-speedup
#echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache
#echo 'Acquire::http {No-Cache=True;};' | tee /etc/apt/apt.conf.d/no-http-cache

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends $BUILD_PKGS $RUN_PKGS

mkdir -p /build/code
cd /build/code
wget -O - "https://github.com/DinoTools/dionaea/archive/${DIONAEA_VERSION}.tar.gz" | tar -xz
cd "dionaea-${DIONAEA_VERSION}/"
autoreconf -vi
./configure \
    --prefix=/opt/dionaea \
    --with-python=/usr/bin/python3 \
    --with-cython-dir=/usr/bin \
    --enable-ev \
    --with-ev-include=/usr/include \
    --with-ev-lib=/usr/lib \
    --with-emu-lib=/usr/lib/libemu \
    --with-emu-include=/usr/include \
    --with-nl-include=/usr/include/libnl3 \
    --with-nl-lib=/usr/lib \
    --enable-static
make
make install

apt-get purge -y $BUILD_PKGS
apt-get autoremove --purge -y
apt-get install -y $RUN_PKGS $LIB_PKGS
apt-get clean
rm -rf /build /var/lib/apt/lists/* /tmp/* /var/tmp/*
