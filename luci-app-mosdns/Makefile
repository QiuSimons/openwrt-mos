include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-mosdns
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-mosdns
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI Support for mosdns
	DEPENDS:=+mosdns
endef

define Package/luci-app-mosdns/description
	LuCI support for mosdns
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/luci-app-mosdns/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	cp -pR ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./root/etc/init.d/MosDNS $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/etc/config
	cp -pR ./root/etc/config/* $(1)/etc/config/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./po/zh-cn/mosdns.po $(1)/usr/lib/lua/luci/i18n/mosdns.zh-cn.lmo
	$(INSTALL_DIR) $(1)/etc/mosdns
	$(INSTALL_DATA) ./files/mosdns/* $(1)/etc/mosdns/
endef

define Package/luci-app-mosdns/postinst
#!/bin/sh
	/etc/init.d/MosDNS enable >/dev/null 2>&1
exit 0
endef

define Package/luci-app-mosdns/prerm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
     /etc/init.d/MosDNS disable
     /etc/init.d/MosDNS stop
fi
exit 0
endef

$(eval $(call BuildPackage,luci-app-mosdns))
