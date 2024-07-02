#!/bin/bash
#
# Copyright (c) 2016 The CyanogenMod Project
# Copyright (c) 2017-2020 The LineageOS Project
# Copyright (c) 2024 StatiXOS
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=sky
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        vendor/bin/hw/android.hardware.security.keymint-service-qti)
            "${PATCHELF}" --add-needed android.hardware.security.rkp-V1-ndk_platform.so "${2}"
            ;;
        vendor/lib64/libhme.so)
            "${PATCHELF}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;
        # Use VNDK 32 libhidlbase
        vendor/lib64/libvendor.goodix.hardware.biometrics.fingerprint@2.1.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/etc/audio/sku_ravelin/audio_policy_configuration.xml)
            sed -i '/<devicePort tagName="BT A2DP \(Out\|Headphones\|Speaker\)"/,/<\/devicePort>/d' "${2}"
            sed -i '/<devicePort tagName="A2DP In" type="AUDIO_DEVICE_IN_BLUETOOTH_A2DP" role="source"/,/<\/devicePort>/d' "${2}"
            sed -i '/<route type="mix" sink="BT A2DP \(Out\|Headphones\|Speaker\)"/d' "${2}"
            sed -i '/sources="primary output,deep_buffer,direct_pcm,compressed_offload,voip_rx,haptics output"\/>/d' "${2}"
            sed -i 's/,A2DP In//g' "${2}"
            sed -i '/<!-- Remote Submix Audio HAL -->/i <!-- Bluetooth Audio HAL -->\n<xi:include href="/vendor/etc/bluetooth_audio_policy_configuration.xml"/>' "${2}"
            sed -i -e '/<!-- Bluetooth Audio HAL for hearing aid -->/d' -e '/<xi:include href="\/vendor\/etc\/bluetooth_qti_hearing_aid_audio_policy_configuration.xml"\/>/d' "${2}"
            ;;
        vendor/etc/audio/sku_ravelin_qssi/audio_policy_configuration.xml)
            sed -i '/<devicePort tagName="BT A2DP \(Out\|Headphones\|Speaker\)"/,/<\/devicePort>/d' "${2}"
            sed -i '/<devicePort tagName="A2DP In" type="AUDIO_DEVICE_IN_BLUETOOTH_A2DP" role="source"/,/<\/devicePort>/d' "${2}"
            sed -i '/<route type="mix" sink="BT A2DP \(Out\|Headphones\|Speaker\)"/d' "${2}"
            sed -i '/sources="primary output,deep_buffer,direct_pcm,compressed_offload,voip_rx,haptics output"\/>/d' "${2}"
            sed -i 's/,A2DP In//g' "${2}"
            sed -i '/<!-- Remote Submix Audio HAL -->/i <!-- Bluetooth Audio HAL -->\n<xi:include href="/vendor/etc/bluetooth_audio_policy_configuration.xml"/>' "${2}"
            sed -i -e '/<!-- Bluetooth Audio HAL for hearing aid -->/d' -e '/<xi:include href="\/vendor\/etc\/bluetooth_qti_hearing_aid_audio_policy_configuration.xml"\/>/d' "${2}"
            ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
