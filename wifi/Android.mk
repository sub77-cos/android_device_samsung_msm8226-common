BUILD_ROOT=/2and/cos/

LOCAL_PATH:= $(call my-dir)

#-----------------------------------------------------------------------------
# Copy additional target-specific files
#-----------------------------------------------------------------------------

ifeq ($(strip $(BOARD_HAS_QCOM_WLAN)),true)

include $(CLEAR_VARS)
LOCAL_MODULE       := hostapd_default.conf
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH  := $(TARGET_OUT_ETC)/hostapd
LOCAL_SRC_FILES    := hostapd_default.conf
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := p2p_supplicant_overlay.conf
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_ETC)/wifi
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := wpa_supplicant_overlay.conf
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_ETC)/wifi
include $(BUILD_PREBUILT)

#-----------------------------------------------------------------------------
# Get WIFI Firmware from device if exists, else from kernel staging driver dir
#-----------------------------------------------------------------------------

include $(CLEAR_VARS)
LOCAL_MODULE       := WCNSS_cfg.dat
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
$(call inherit-product-if-exists, /../../matisse3g/wifi/$(LOCAL_MODULE).mk)
ifdef DEVICE_SRC_FILES
LOCAL_SRC_FILES    := $(DEVICE_SRC_FILES)
else
LOCAL_SRC_FILES    := /../../../../kernel/samsung/msm8226/drivers/staging/prima/firmware_bin/$(LOCAL_MODULE)
endif
LOCAL_MODULE_PATH  := $(TARGET_OUT)/etc/firmware/wlan/prima
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := WCNSS_qcom_cfg.ini
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
$(call inherit-product-if-exists, /../../matisse3g/wifi/WCNSS_qcom_cfg.ini.mk)
ifdef DEVICE_SRC_FILES
LOCAL_SRC_FILES    := $(DEVICE_SRC_FILES)
else
LOCAL_SRC_FILES    := /../../../../kernel/samsung/msm8226/drivers/staging/prima/firmware_bin/$(LOCAL_MODULE)
endif
LOCAL_MODULE_PATH  := $(TARGET_OUT)/etc/firmware/wlan/prima
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := WCNSS_qcom_wlan_nv.bin
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
$(call inherit-product-if-exists, /../../matisse3g/wifi/$(LOCAL_MODULE).mk)
ifdef DEVICE_SRC_FILES
LOCAL_SRC_FILES    := $(DEVICE_SRC_FILES)
else
LOCAL_SRC_FILES    := /../../../../kernel/samsung/msm8226/drivers/staging/prima/firmware_bin/$(LOCAL_MODULE)
endif
LOCAL_MODULE_PATH  := $(TARGET_OUT)/etc/firmware/wlan/prima
include $(BUILD_PREBUILT)

#-----------------------------------------------------------------------------
# Get SYMLINK from /persist partition
#-----------------------------------------------------------------------------

include $(CLEAR_VARS)
LOCAL_MODULE := WCNSS_qcom_wlan_factory_nv.bin
LOCAL_MODULE_CLASS := FAKE
LOCAL_MODULE_TAGS := optional
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE): TARGET := /persist/$(LOCAL_MODULE)
$(LOCAL_BUILT_MODULE): SYMLINK := $(TARGET_OUT)/etc/firmware/wlan/prima/$(LOCAL_MODULE)
$(LOCAL_BUILT_MODULE):
	$(hide) echo "Symlink: $(SYMLINK) -> $(TARGET)"
	$(hide) mkdir -p $(dir $@)
	$(hide) mkdir -p $(dir $(SYMLINK))
	$(hide) rm -rf $@
	$(hide) rm -rf $(SYMLINK)
	$(hide) ln -sf $(TARGET) $(SYMLINK)
	$(hide) touch $@

endif
