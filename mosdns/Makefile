#
# Copyright (C) 2015-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mosdns
PKG_VERSION:=1.6.5
PKG_RELEASE:=1

ifeq ($(ARCH),mipsel)
	MOSDNS_ARCH:=mipsle-softfloat
endif
ifeq ($(ARCH),mips)
	MOSDNS_ARCH:=mips64-hardfloat
endif
ifeq ($(ARCH),x86_64)
	MOSDNS_ARCH:=amd64
endif
ifeq ($(ARCH),arm)
	MOSDNS_ARCH:=arm-7
endif
ifeq ($(ARCH),aarch64)
	MOSDNS_ARCH:=arm64
endif

PKG_LICENSE:=Apache-2.0
PKG_BUILD_DIR:=$(BUILD_DIR)/mosdns-$(PKG_VERSION)
PKG_URL:=https://github.com/IrineSistiana/mosdns/releases/download/v$(PKG_VERSION)/mosdns-linux-$(MOSDNS_ARCH).zip
PKG_FILE:=mosdns-linux-$(MOSDNS_ARCH)-$(PKG_VERSION).zip

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=mosdns is a programmable DNS forwarder
	DEPENDS:=
	URL:=https://github.com/IrineSistiana/mosdns/releases
endef

define Package/$(PKG_NAME)/description
mosdns is a "programmable" DNS forwarder.
endef

define Build/Download
	if [ ! -f $(DL_DIR)/$(PKG_FILE) ] ; then \
		wget -c -t 5 -O $(DL_DIR)/$(PKG_FILE) $(PKG_URL); \
	fi
endef

define Build/Prepare
	$(Build/Download)
	unzip $(DL_DIR)/$(PKG_FILE) -d $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	mkdir $(1)/usr/bin/MosDNS
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mosdns $(1)/usr/bin/MosDNS/MosDNS
	$(INSTALL_DATA) ./files/mosdns/* $(1)/usr/bin/MosDNS/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
