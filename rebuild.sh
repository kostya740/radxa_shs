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
lunch rk3399-userdebug
make -j$(nproc)

echo "### GENERATE IMAGES"
[ ! -d "rockdev" ] && ln -s RKTools/linux/Linux_Pack_Firmware/rockdev rockdev
./mkimage.sh
cd rockdev
[ ! -d "rockdev" ] && ln -s Image-rk3399 Image
#./mkupdate.sh
./android-gpt.sh
