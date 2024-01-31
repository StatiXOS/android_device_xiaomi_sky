#
# Copyright 2014 The Android Open-Source Project
# Copyright 2024 StatiXOS
#
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/xiaomi/sky-kernel/kernel
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES := \
    $(LOCAL_KERNEL):kernel

$(call inherit-product, vendor/xiaomi/sky/sky-vendor.mk)
