#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# Function to apply common patches
apply_common_patches() {
  local dir=$1
  if [ -d "$dir" ]; then
    sed -i '1i#include <linux/completion.h>' "$dir/include/osdep_service_linux.h"
    sed -i '/thread_exit()/a return 0;' "$dir/core/rtw_cmd.c"
  fi
}

# List of directories to apply patches (add more directories as needed)
dirs=(
  "/workdir/openwrt/package/kernel/rtl8812au-ct/src"
  "/workdir/openwrt/package/kernel/mt76/src" # Example for mt76 driver
  # Add other directories here
)

# Apply patches to all listed directories
for dir in "${dirs[@]}"; do
  apply_common_patches "$dir"
done

echo '修改dts'
rm -rf target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3588-armsom-sige7.dts
cp -f $GITHUB_WORKSPACE/imb3588.dts target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3588-armsom-sige7.dts
