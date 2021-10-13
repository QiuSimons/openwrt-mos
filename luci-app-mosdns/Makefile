include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-mosdns
PKG_VERSION:=1.0
PKG_RELEASE:=1

LUCI_TITLE:=LuCI Support for mosdns
LUCI_DEPENDS:=+mosdns
LUCI_PKGARCH:=all


define Package/$(PKG_NAME)/conffiles
/etc/mosdns/config.yaml
endef

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/prerm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/MosDNS stop
fi
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature
