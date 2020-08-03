#!/bin/bash

set -e

echo "### BUILD U-BOOT"
cd u-boot
./make.sh rk3399
cd ..

echo "### BUILD KERNEL"
cd kernel
make rockchip_defconfig
make rk3399-rockpi-4b.img -j$(nproc)
cd ..

echo "### BUILD AOSP"
source build/envsetup.sh
lunch rk3399_box-userdebug
make -j$(nproc)

echo "### GENERATE IMAGES"
./mkimage.sh
cd rockdev
#./mkupdate.sh
./android-gpt.sh
cp /mnt/rockpi4-android9/rockdev/Image/gpt.img /media/psf/git/ && sync
