PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/tesla/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/tesla/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/tesla/prebuilt/common/bin/50-tesla.sh:system/addon.d/50-tesla.sh

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/tesla/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/tesla/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# Tesla-specific init file
PRODUCT_COPY_FILES += \
    vendor/tesla/prebuilt/common/etc/init.local.rc:root/init.tesla.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/tesla/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/tesla/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/tesla/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/tesla/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/tesla/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/tesla/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/tesla/prebuilt/common/bin/sysinit:system/bin/sysinit

# Required packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    Development \
    SpareParts \
    su

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

# AudioFX
PRODUCT_PACKAGES += \
    AudioFX

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra Optional packages
PRODUCT_PACKAGES += \
    SlimLauncher \
    LatinIME \
    BluetoothExt \
    SlimOTA \
    LockClock \
    DashClock \
    OmniSwitch \
    Snap \
    OmniStyle \
    KernelAdiutor \
    masquerade

#    SlimFileManager removed until updated

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# SuperSU
PRODUCT_COPY_FILES += \
   vendor/tesla/prebuilt/common/etc/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
   vendor/tesla/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# Adaway
PRODUCT_COPY_FILES += \
vendor/tesla/prebuilt/common/app/adaway.apk:system/app/adaway.apk

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# easy way to extend to add more packages
-include vendor/extra/product.mk

-include vendor/tesla/config/dtc.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/tesla/overlay/common

# Viper4Android
PRODUCT_COPY_FILES += \
   vendor/tesla/prebuilt/common/bin/audio_policy.sh:system/audio_policy.sh \
   vendor/tesla/prebuilt/common/addon.d/95-LolliViPER.sh:system/addon.d/95-LolliViPER.sh \
   vendor/tesla/prebuilt/common/su.d/50viper.sh:system/su.d/50viper.sh \
   vendor/tesla/prebuilt/common/app/Viper4Android/Viper4Android.apk:system/priv-app/Viper4Android/Viper4Android.apk

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/tesla/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_COPY_FILES += \
    vendor/tesla/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
else
PRODUCT_COPY_FILES += \
    vendor/tesla/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif
endif

# Versioning System
# Tesla first version.
PRODUCT_VERSION_MAJOR = 6.0.1
PRODUCT_VERSION_MINOR = RC-1
PRODUCT_VERSION_MAINTENANCE = v2.2
ifdef TIPSY_BUILD_EXTRA
    TESLA_POSTFIX := -$(TESLA_BUILD_EXTRA)
endif

ifndef TESLA_BUILD_TYPE
    TESLA_BUILD_TYPE := OMS
    TESLA_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif

# Set all versions
TESLA_VERSION := Tesla-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TESLA_BUILD_TYPE)$(TESLA_POSTFIX)
TESLA_MOD_VERSION := Tesla-$(TESLA_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TESLA_BUILD_TYPE)$(TESLA_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    tesla.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.tesla.version=$(TESLA_VERSION) \
    ro.modversion=$(TESLA_MOD_VERSION) \
    ro.tesla.buildtype=$(TESLA_BUILD_TYPE)

EXTENDED_POST_PROCESS_PROPS := vendor/tesla/tools/tesla_process_props.py

