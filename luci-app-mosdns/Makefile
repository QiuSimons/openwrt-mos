# Copyright (C) 2018-2019 Lienol
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-MosDNS
PKG_VERSION:=1.1
PKG_RELEASE:=22

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-MosDNS
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI app for MosDNS
	PKG_MAINTAINER:=<https://github.com/dogbutcat/luci-app-MosDNS>
	PKGARCH:=all
	DEPENDS:= \
		+MosDNS \
		+!wget&&!curl:wget
endef

define Package/luci-app-MosDNS/description
	LuCI support for MosDNS
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/luci-app-MosDNS/conffiles
/usr/share/MosDNS/links.txt
/etc/config/MosDNS
endef

define Package/luci-app-MosDNS/install
    $(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh-cn/MosDNS.po $(1)/usr/lib/lua/luci/i18n/MosDNS.zh-cn.lmo
endef

define Package/luci-app-MosDNS/postinst
#!/bin/sh
	/etc/init.d/MosDNS enable >/dev/null 2>&1
	enable=$(uci get MosDNS.MosDNS.enabled 2>/dev/null)
	if [ "$enable" == "1" ]; then
		/etc/init.d/MosDNS reload
	fi
	rm -f /tmp/luci-indexcache
	rm -f /tmp/luci-modulecache/*
exit 0
endef

define Package/luci-app-MosDNS/prerm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
     /etc/init.d/MosDNS disable
     /etc/init.d/MosDNS stop
uci -q batch <<-EOF >/dev/null 2>&1
	delete ucitrack.@MosDNS[-1]
	commit ucitrack
EOF
fi
exit 0
endef

$(eval $(call BuildPackage,luci-app-MosDNS))
