#
# Copyright (c) 2014 The Android Open-Source Project
# Copyright (c) 2024 StatiXOS
#
# SPDX-License-Identifier: Apache-2.0
#

# Hardware
PRODUCT_USES_QCOM_HARDWARE := true
PRODUCT_BOARD_PLATFORM := parrot

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/fstab.default:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom

PRODUCT_PACKAGES += \
    fstab.qcom

# Shipping API
PRODUCT_SHIPPING_API_LEVEL := 33

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/xiaomi/sky-kernel/kernel
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES := \
    $(LOCAL_KERNEL):kernel

# Soong
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

$(call inherit-product, vendor/xiaomi/sky/sky-vendor.mk)
