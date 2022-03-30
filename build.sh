#!/bin/bash

display_usage() { 
    echo "usage: ./build.sh kernel1.bin rootfs0.bin" 
}

get_file_size() {
    wc -c "$1"  | awk '{print $1}'
}

kernel1="$1"
rootfs0="$2"

if [ -z "$kernel1" ] || [ -z "$rootfs0" ]; then
    display_usage
    exit 1
fi

if [ ! -f "$kernel1" ] || \
   [ $(get_file_size $kernel1) -gt 4194304 ]
then
    echo "error: invalid kernel1.bin"
    echo
    display_usage
    exit 1
fi

if [ ! -f "$rootfs0" ]; then
    echo "error: invalid rootfs0.bin"
    echo
    display_usage
    exit 1
fi


image=$(mktemp openwrt.bin.XXXXXX)
dd if=/dev/zero  of="$image" bs=4M count=2             > /dev/null 2>&1
dd if="$kernel1" of="$image" bs=4M seek=0 conv=notrunc > /dev/null 2>&1
dd if="$kernel1" of="$image" bs=4M seek=1 conv=notrunc > /dev/null 2>&1
dd if="$rootfs0" of="$image" bs=4M seek=2              > /dev/null 2>&1
mv "$image" "openwrt.bin"

echo "info: openwrt.bin for Breed bootloader was successfully build"
exit 0
