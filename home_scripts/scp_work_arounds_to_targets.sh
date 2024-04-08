#!/bin/bash
ip1=$(cat ~/target1_ip.txt)
ip2=$(cat ~/target2_ip.txt)
# ip1="192.168.153.1"
# ip2="10.223.249.22"
lede="/mnt/2f085d66-eab7-49a7-9190-206bc3512f78/lede_wearables"
luci="/mnt/2f085d66-eab7-49a7-9190-206bc3512f78/luci_wearables"
# luci1="/mnt/2f085d66-eab7-49a7-9190-206bc3512f78/luci_hwinfo_to_model_files"
scp_cmd="scp -q -oStrictHostKeyChecking=no -r"

scp_to_both_target() {
    $scp_cmd $1 root@$ip1:$2
    $scp_cmd $1 root@$ip2:$2
}

scp_to_target1() {
    $scp_cmd $1 root@$ip1:$2
}

scp_to_target2() {
    $scp_cmd $1 root@$ip2:$2
}

# $scp_cmd $lede/package/dl-central-config/files/usr/lib/doodlelabs/central-config/0001-wireless.sh root@$ip1:/usr/lib/doodlelabs/central-config/0001-wireless.sh
# $scp_cmd $lede/package/dl-central-config/files/usr/lib/doodlelabs/central-config/0001-wireless.sh root@$ip2:/usr/lib/doodlelabs/central-config/0001-wireless.sh
# $scp_cmd $lede/package/dl-central-acs/files/usr/sbin/link-recovery* root@$ip1:/usr/sbin/
# $scp_cmd $lede/package/dl-central-acs/files/usr/sbin/link-recovery* root@$ip2:/usr/sbin/

# $scp_cmd $luci/modules/luci-mod-admin-full/luasrc/controller/admin/network.lua root@$ip1:/usr/lib/lua/luci/controller/admin/network.lua
# $scp_cmd $luci/modules/luci-mod-admin-mini/luasrc/controller/mini/network.lua root@$ip1:/usr/lib/lua/luci/controller/mini/network.lua
# $scp_cmd $luci/modules/luci-mod-admin-full/luasrc/controller/admin/network.lua root@$ip2:/usr/lib/lua/luci/controller/admin/network.lua
# $scp_cmd $luci/modules/luci-mod-admin-mini/luasrc/controller/mini/network.lua root@$ip2:/usr/lib/lua/luci/controller/mini/network.lua

# $scp_cmd $luci/applications/luci-app-simpleconfig/root/usr/share/simpleconfig/band_switching.sh root@$ip1:/usr/share/simpleconfig/band_switching.sh
# $scp_cmd $luci/applications/luci-app-simpleconfig/root/usr/share/simpleconfig/band_switching.sh root@$ip2:/usr/share/simpleconfig/band_switching.sh

# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/controller/admin/network.lua /usr/lib/lua/luci/controller/admin/network.lua
# scp_to_both_target $luci/modules/luci-mod-admin-mini/luasrc/controller/mini/network.lua /usr/lib/lua/luci/controller/mini/network.lua
# scp_to_both_target $luci/applications/luci-app-simpleconfig/luasrc/model/cbi/simpleconfig.lua /usr/lib/lua/luci/model/cbi/simpleconfig.lua
# scp_to_both_target $luci/applications/luci-app-simpleconfig/root/usr/share/simpleconfig/simpleconfig.sh /usr/share/simpleconfig/simpleconfig.sh
# scp_to_both_target $luci/applications/luci-app-simpleconfig/root/usr/share/simpleconfig/setup.sh /usr/share/simpleconfig/setup.sh
# scp_to_both_target $luci/applications/luci-app-central-acs/luasrc/controller/central-acs.lua /usr/lib/lua/luci/controller/central-acs.lua
# scp_to_both_target $luci/applications/luci-app-central-config/luasrc/controller/central-config.lua /usr/lib/lua/luci/controller/central-config.lua
# scp_to_both_target $luci/applications/luci-app-central-config/luasrc/view/central_status/status.htm /usr/lib/lua/luci/view/central_status/status.htm
# scp_to_both_target $luci/applications/luci-app-central-config/luasrc/model/cbi/central-config-sense.lua /usr/lib/lua/luci/model/cbi/
# scp_to_both_target $luci/applications/luci-app-central-config/luasrc/model/cbi/central-config-asm.lua /usr/lib/lua/luci/model/cbi/central-config-asm.lua
# scp_to_both_target $lede/package/doodlelabs/files/usr/sbin/sr_personality /usr/sbin/sr_personality

# scp_to_target2 $luci/applications/luci-app-simpleconfig/root/usr/share/simpleconfig/band_switching.sh /usr/share/simpleconfig/band_switching.sh
# scp_to_target1 $lede/package/doodlelabs/files/usr/sbin/sr_personality /usr/sbin/sr_personality
# scp_to_target2 $lede/package/doodlelabs/files/usr/sbin/sr_personality /usr/sbin/sr_personality

# scp_to_target2 $luci/modules/luci-mod-admin-full/luasrc/controller/admin/system.lua /usr/lib/lua/luci/controller/admin/system.lua
# scp_to_target2 $luci/modules/luci-mod-admin-full/luasrc/view/admin_system/applyreboot.htm /usr/lib/lua/luci/view/admin_system/applyreboot.htm

# scp_to_target1 $lede/package/doodlelabs/files/etc/uci-defaults/40_doodlelabs
# scp_to_both_target $luci/applications/luci-app-central-config/luasrc/model/cbi/central-config-asm.lua /usr/lib/lua/luci/model/cbi/central-config-asm.lua
# scp_to_both_target $luci/applications/luci-app-central-config/luasrc/view/central_status/multi_dynamic_list_options.htm /usr/lib/lua/luci/view/cbi/
# scp_to_both_target $luci/applications/luci-app-simpleconfig/luasrc/model/cbi/simpleconfig.lua /usr/lib/lua/luci/model/cbi/simpleconfig.lua
# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/model/cbi/admin_network/wifi.lua /usr/lib/lua/luci/model/cbi/admin_network/wifi.lua
# scp_to_target1 $luci0/applications/luci-app-simpleconfig/luasrc/model/cbi/simpleconfig.lua /usr/lib/lua/luci/model/cbi/simpleconfig.lua
# scp_to_target2 $luci1/applications/luci-app-simpleconfig/luasrc/model/cbi/simpleconfig.lua /usr/lib/lua/luci/model/cbi/simpleconfig.lua
# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/controller/admin/network.lua /usr/lib/lua/luci/controller/admin/network.lua
# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/view/admin_network/wifi_overview.htm /usr/lib/lua/luci/view/admin_network/wifi_overview.htm
# scp_to_both_target $luci/applications/luci-app-simpleconfig/luasrc/model/cbi/simpleconfig.lua /usr/lib/lua/luci/model/cbi/simpleconfig.lua
# scp_to_both_target $luci/applications/luci-app-simpleconfig/root/usr/share/simpleconfig/setup.sh /usr/share/simpleconfig/setup.sh
# scp_to_both_target $luci/applications/luci-app-simpleconfig/luasrc/model/cbi/simpleconfig.lua /usr/lib/lua/luci/model/cbi/simpleconfig.lua
# scp_to_both_target $luci/applications/luci-app-simpleconfig/root/usr/share/simpleconfig/simpleconfig.sh /usr/share/simpleconfig/simpleconfig.sh
# scp_to_both_target $luci/applications/luci-app-hotspot-wizard/root/usr/sbin/hotspot_wizard /usr/sbin/hotspot_wizard
# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/controller/admin/network.lua /usr/lib/lua/luci/controller/admin/network.lua
# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/view/admin_network/wifi_join.htm /usr/lib/lua/luci/view/admin_network/wifi_join.htm
# scp_to_both_target $luci/applications/luci-app-simpleconfig/root/etc/config/simpleconfig /etc/config/simpleconfig
# scp_to_both_target $luci//applications/luci-app-simpleconfig/root/usr/share/simpleconfig/simpleconfig.sh /usr/share/simpleconfig/simpleconfig.sh
# scp_to_both_target $luci/applications/luci-app-simpleconfig/luasrc/model/cbi/simpleconfig.lua /usr/lib/lua/luci/model/cbi/simpleconfig.lua
# scp_to_target1 $luci/applications/luci-app-central-config/luasrc/model/cbi/central-config-asm.lua /usr/lib/lua/luci/model/cbi/central-config-asm.lua
# scp_to_target1 $luci/modules/luci-base/luasrc/view/cbi/tblsection1.htm /usr/lib/lua/luci/view/cbi/tblsection1.htm
# scp_to_both_target $luci//applications/luci-app-simpleconfig/root/usr/share/simpleconfig/simpleconfig.sh /usr/share/simpleconfig/simpleconfig.sh
# scp_to_both_target $lede/package/doodlelabs/files/usr/sbin/wearable-ctrld.sh /usr/sbin/wearable-ctrld.sh
# scp_to_both_target $luci/applications/luci-app-simpleconfig/luasrc/model/cbi/simpleconfig.lua /usr/lib/lua/luci/model/cbi/simpleconfig.lua
# scp_to_target2 $luci/applications/luci-app-simpleconfig/luasrc/model/cbi/simpleconfig.lua /usr/lib/lua/luci/model/cbi/simpleconfig.lua


# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/model/cbi/admin_network/wifi.lua /usr/lib/lua/luci/model/cbi/admin_network/wifi.lua
# scp_to_both_target $lede/package/acs_multiband/files/usr/sbin/iw_band /usr/sbin/iw_band
# scp_to_both_target $lede/package/doodlelabs/files/usr/sbin/fes_update.sh /usr/sbin/fes_update.sh
# scp_to_both_target $lede/package/network/config/netifd/files/etc/init.d/network /etc/init.d/network
# scp_to_both_target $luci/applications/luci-app-simpleconfig/root/usr/share/simpleconfig/band_switching.sh /usr/share/simpleconfig/band_switching.sh
# scp_to_both_target $lede/package/doodlelabs/files/usr/sbin/rpcd_mapi.sh /usr/sbin/rpcd_mapi.sh
# scp_to_both_target $lede/staging_dir/target-mips_24kc_musl/root-ar71xx/usr/sbin/dl-license-manager /usr/sbin/dl-license-manager
# scp_to_both_target $luci/applications/luci-app-license-manager/luasrc/model/cbi/license-manager/license-manager.lua /usr/lib/lua/luci/model/cbi/license-manager.lua
# scp_to_both_target $luci/applications/luci-app-license-manager/luasrc/controller/license-manager.lua /usr/lib/lua/luci/controller/license-manager.lua
# scp_to_both_target $luci/applications/luci-app-license-manager/luasrc/view/license-upload.htm /usr/lib/lua/luci/view/license-upload.htm
# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/view/admin_system/license_manager.htm /usr/lib/lua/luci/view/admin_system/license_manager.htm
# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/controller/admin/system.lua /usr/lib/lua/luci/controller/admin/system.lua
# scp_to_both_target $lede/package/doodlelabs/files/etc/init.d/startup_complete /etc/init.d/startup_complete
# scp_to_both_target $luci/applications/luci-app-simpleconfig/luasrc/model/cbi/simpleconfig.lua /usr/lib/lua/luci/model/cbi/simpleconfig.lua
# scp_to_both_target $luci/applications/luci-app-simpleconfig/root/usr/share/simpleconfig/simpleconfig.sh /usr/share/simpleconfig/simpleconfig.sh
# scp_to_both_target $luci/applications/luci-app-simpleconfig/root/etc/config/simpleconfig /etc/config/simpleconfig
# scp_to_both_target $lede/package/doodlelabs/files/usr/sbin/wearable /usr/sbin/wearable
# scp_to_target2 $lede/package/dl-prism-ctrl/files/dl-prism-ctrl.sh /usr/bin/dl-prism-ctrl
# scp_to_both_target $luci/modules/luci-mod-admin-mini/luasrc/view/mini/overview.htm /usr/lib/lua/luci/view/mini/overview.htm
# scp_to_both_target $luci/modules/luci-mod-admin-mini/luasrc/view/mini_status/index.htm /usr/lib/lua/luci/view/mini_status/index.htm
# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm /usr/lib/lua/luci/view/admin_status/index.htm
# scp_to_both_target $luci/applications/luci-app-simpleconfig/luasrc/model/cbi/simpleconfig.lua /usr/lib/lua/luci/model/cbi/simpleconfig.lua
# scp_to_both_target $luci/applications/luci-app-simpleconfig/root/etc/config/simpleconfig /etc/config/simpleconfig
# scp_to_both_target $luci/applications/luci-app-simpleconfig/root/usr/share/simpleconfig/simpleconfig.sh /usr/share/simpleconfig/simpleconfig.sh
# scp_to_both_target $luci/applications/luci-app-diffserv/root/etc/init.d/diffserv /etc/init.d/diffserv
# scp_to_both_target $lede/package/network/config/netifd/files/etc/init.d/network /etc/init.d/network

# scp_to_both_target $lede/package/dl-license-manager/files/dl-license-manager.sh /usr/sbin/dl-license-manager.sh
# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/controller/admin/system.lua /usr/lib/lua/luci/controller/admin/system.lua
# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/view/admin_system/license_manager.htm /usr/lib/lua/luci/view/admin_system/license_manager.htm
# scp_to_both_target $lede/staging_dir/target-mips_24kc_musl/root-ar71xx/usr/sbin/dl-license-manager /usr/sbin/dl-license-manager
# scp_to_both_target $lede/package/dl-license-manager/files/dl-license-manager.sh /usr/sbin/dl-license-manager.sh

# scp_to_both_target $luci/modules/luci-mod-admin-full/luasrc/model/cbi/admin_network/wifi.lua /usr/lib/lua/luci/model/cbi/admin_network/wifi.lua
# scp_to_both_target $lede/package/acs_multiband/files/usr/sbin/iw_band /usr/sbin/iw_band
# scp_to_both_target $luci/applications/luci-app-simpleconfig/root/usr/share/simpleconfig/band_switching.sh /usr/share/simpleconfig/band_switching.sh
# scp_to_both_target $lede/package/dl-central-config/files/usr/lib/doodlelabs/doodle_lib.sh /usr/lib/doodlelabs/doodle_lib.sh
# scp_to_both_target $lede/package/dl-central-config/files/usr/lib/doodlelabs/central-config/0007-acs_multiband.sh /usr/lib/doodlelabs/central-config/0007-acs_multiband.sh
# scp_to_both_target $lede/package/message-system/files/usr/lib/doodlelabs/ms/acs_multiband.sh /usr/lib/doodlelabs/ms/acs_multiband.sh
# scp_to_both_target $lede/package/acs_multiband/files/usr/sbin/scan_bands.sh /usr/sbin/scan_bands.sh

scp_to_both_target $lede/package/wearables/files/etc/init.d/wearable-ctrld /etc/init.d/wearable-ctrld
