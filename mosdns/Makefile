# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2021 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=mosdns
PKG_VERSION:=5.1.3
PKG_RELEASE:=1

PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILE:=LICENSE
PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>

# OpenWrt ARCH: arm, aarch64, i386, x86_64, mips, mipsel
# Golang ARCH: armv[5-7], armv8, 386, amd64, mips, mipsle
PKG_ARCH:=$(ARCH)
ifeq ($(ARCH),mips)
	PKG_ARCH:=mips-softfloat
endif
ifeq ($(ARCH),mipsel)
	PKG_ARCH:=mipsle-softfloat
endif
ifeq ($(ARCH),x86_64)
	PKG_ARCH:=amd64
endif
ifeq ($(ARCH),arm)
	PKG_ARCH:=arm-6
	ifneq ($(BOARD),bcm53xx)
		PKG_ARCH:=arm-7
	endif
	ifeq ($(BOARD),kirkwood)
		PKG_ARCH:=arm-5
	endif
endif
ifeq ($(ARCH),aarch64)
	PKG_ARCH:=arm64
endif
PKG_SOURCE:=mosdns-linux-$(PKG_ARCH).zip
PKG_SOURCE_URL:=https://github.com/IrineSistiana/mosdns/releases/download/v$(PKG_VERSION)/
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_HASH:=skip

include $(INCLUDE_DIR)/package.mk

define Package/mosdns/Default
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=A plug-in DNS forwarder/splitter
  URL:=https://github.com/IrineSistiana/mosdns
endef

define Package/mosdns
  $(call Package/mosdns/Default)
endef

define Package/mosdns-v5
  $(call Package/mosdns/Default)
endef

define Package/mosdns/description
	A plug-in DNS forwarder/splitter
endef

define Build/Prepare
	unzip $(DL_DIR)/$(PKG_SOURCE) -d $(DL_DIR)/mosdns
endef

define Build/Compile
	echo "$(PKG_NAME) Compile Skiped!"
endef

define Package/mosdns/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(DL_DIR)/mosdns/mosdns $(1)/usr/bin
endef

define Package/mosdns-v5/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(DL_DIR)/mosdns/mosdns $(1)/usr/bin
endef

$(eval $(call BuildPackage,mosdns))
$(eval $(call BuildPackage,mosdns-v5))
