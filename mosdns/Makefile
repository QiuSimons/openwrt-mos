include $(TOPDIR)/rules.mk

PKG_NAME:=mosdns
PKG_VERSION:=1.7.2
PKG_RELEASE:=1

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

PKG_SOURCE:=mosdns-linux-$(MOSDNS_ARCH).zip
PKG_SOURCE_URL:=https://github.com/IrineSistiana/mosdns/releases/download/v$(PKG_VERSION)/
UNZIP_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)/mosdns-unzip
PKG_HASH:=skip

define Build/Prepare
	mkdir -vp $(UNZIP_DIR)
	unzip -od $(UNZIP_DIR) $(DL_DIR)/$(PKG_SOURCE)
	chmod 755 $(UNZIP_DIR)/mosdns
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/extra_provides
    echo 'libc.so.6'; \
    echo 'libpthread.so.0';
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	mkdir $(1)/usr/bin/mosdns
	$(INSTALL_BIN) $(UNZIP_DIR)/mosdns $(1)/usr/bin/mosdns/mosdns
	$(INSTALL_DIR) $(1)/etc/mosdns
	$(INSTALL_DATA) ./files/mosdns/* $(1)/etc/mosdns/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
