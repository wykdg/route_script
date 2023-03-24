# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2021 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=scut-unicom
PKG_RELEASE:=$(shell date "+%Y-%m-%d")

PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=wykdg <wykchina@gmail.com>

include $(INCLUDE_DIR)/package.mk

ROUTE_FILE:=scut_route.txt
define Download/route
  URL:=https://raw.githubusercontent.com/wykdg/route_script/master/
  URL_FILE:=scut_route.txt
  FILE:=$(ROUTE_FILE)
  HASH:=skip
endef

ROUTE_SCRIPT:=openwrt_route_add.sh
define Download/script
  URL:=https://raw.githubusercontent.com/wykdg/route_script/master/
  URL_FILE:=openwrt_route_add.sh
  FILE:=$(ROUTE_SCRIPT)
  HASH:=skip
endef

define Package/scut-unicom
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  URL:=https://www.v2fly.org
  PKGARCH:=all
  TITLE:=SCUT_UNICOM
  VERSION:=$(PKG_RELEASE)
  LICENSE:=CC-BY-SA-4.0
endef


define Build/Prepare
	$(call Build/Prepare/Default)
ifneq ($(CONFIG_PACKAGE_scut-unicom),)
	$(call Download,route)
	$(call Download,script)
endif
endef


define Build/Compile
endef

define Package/scut-unicom/install
	$(INSTALL_DIR) $(1)/usr/share/scut_unicom/
	$(INSTALL_DATA) $(DL_DIR)/$(ROUTE_FILE) $(1)/usr/share/scut_unicom/scut_route.txt
	$(INSTALL_BIN) $(DL_DIR)/$(ROUTE_SCRIPT) $(1)/usr/share/scut_unicom/add_route.sh
endef



$(eval $(call BuildPackage,scut-unicom))
