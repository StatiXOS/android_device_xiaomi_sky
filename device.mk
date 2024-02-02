#
# Copyright (c) 2014 The Android Open-Source Project
# Copyright (c) 2024 StatiXOS
#
# SPDX-License-Identifier: Apache-2.0
#

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/android_t_baseline.mk)

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

# Userdata Checkpointing OTA GC
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl-qti \
    android.hardware.boot@1.2-impl-qti.recovery \
    android.hardware.boot@1.2-service \
    checkpoint_gc \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

# ATrace
PRODUCT_PACKAGES += \
    android.hardware.atrace@1.0-service

# Audio
$(call soong_config_set,android_hardware_audio,run_64bit,true)

# Pick up split makefile
$(call inherit-product, hardware/qcom-caf/sm8450/audio/configs/parrot/parrot.mk)

PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.soundtrigger@2.3-impl \
    android.hardware.bluetooth.audio@2.0-impl

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Hardware
PRODUCT_USES_QCOM_HARDWARE := true
PRODUCT_BOARD_PLATFORM := parrot

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# IR
PRODUCT_PACKAGES += \
    android.hardware.ir@1.0-impl \
    android.hardware.ir@1.0-service

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/fstab.default:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom

PRODUCT_PACKAGES += \
    fstab.qcom \
    init.qcom.rc \
    init.recovery.qcom.rc \
    init.target.rc \
    ueventd.qcom.rc

# Media
PRODUCT_PACKAGES += \
    android.hardware.media.omx@1.0-service

# Overlays
PRODUCT_PACKAGES += \
    SkyCarrierConfigOverlay \
    SkyFrameworksOverlay \
    SkyGLSettingsProviderOverlay \
    SkyGLWifiOverlay \
    SkyINSettingsProviderOverlay \
    SkyINWifiOverlay \
    SkySettingsOverlay \
    SkySystemUIOverlay \
    SkyWifiOverlay \
    SkyWifiResTargetMainline \
    NoCutoutOverlay

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@2.1-service.multihal

# Shipping API
PRODUCT_SHIPPING_API_LEVEL := 33

# Kernel
TARGET_KERNEL_DIR ?= device/xiaomi/sky-kernel

PRODUCT_COPY_FILES += \
    $(TARGET_KERNEL_DIR)/Image:kernel

# Soong
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# WiFi
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml

PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    hostapd \
    wpa_supplicant

$(call inherit-product, vendor/xiaomi/sky/sky-vendor.mk)
