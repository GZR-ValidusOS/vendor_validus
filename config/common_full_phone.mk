# Inherit common stuff
$(call inherit-product, vendor/tesla/config/common.mk)
$(call inherit-product, vendor/tesla/config/common_apn.mk)

# Telephony 
PRODUCT_PACKAGES += \
    Stk 

# SMS
PRODUCT_PACKAGES += \
	messaging
