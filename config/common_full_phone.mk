# Inherit common stuff
$(call inherit-product, vendor/tesla/config/common.mk)
$(call inherit-product, vendor/tesla/config/common_apn.mk)

# Telephony 
PRODUCT_PACKAGES += \
    Stk \
    telephony-ext     

PRODUCT_BOOT_JARS += \
    telephony-ext

# SMS
PRODUCT_PACKAGES += \
	messaging
