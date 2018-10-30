#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/fsl/sabreauto_6q/build_id.mk
include device/fsl/imx6/BoardConfigCommon.mk
# sabreauto_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

# In userdebug, Enable adb logs from first boot
ifneq (,$(filter eng, $(TARGET_BUILD_VARIANT)))
    include device/fsl/sabreauto_6q/debug.mk
endif

ifeq ($(BUILD_TARGET_FS),ubifs)
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_6q/fstab_nand.freescale
# build ubifs for nand devices
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_6q/fstab_nand.freescale:root/fstab.freescale
else
ADDITIONAL_BUILD_PROPERTIES += \
                        ro.internel.storage_size=/sys/block/mmcblk2/size \
                        ro.frp.pst=/dev/block/by-name/presistdata
ifneq ($(BUILD_TARGET_FS),f2fs)
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_6q/fstab.freescale
# build for ext4
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_6q/fstab.freescale:root/fstab.freescale
else
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_6q/fstab-f2fs.freescale
# build for f2fs
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_6q/fstab-f2fs.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS
# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions.bpt

endif # BUILD_TARGET_FS

TARGET_BOOTLOADER_BOARD_NAME := SABREAUTO

PRODUCT_MODEL := Bluemoon

TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx6
# UNITE is a virtual device.
# BOARD_WLAN_DEVICE            := UNITE
# WPA_SUPPLICANT_VERSION       := VER_0_8_UNITE
# BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
# BOARD_HOSTAPD_DRIVER         := NL80211

#for intel vendor
ifeq ($(BOARD_WLAN_VENDOR),INTEL)
BOARD_HOSTAPD_PRIVATE_LIB                := private_lib_driver_cmd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB         := private_lib_driver_cmd
WPA_SUPPLICANT_VERSION                   := VER_0_8_X
HOSTAPD_VERSION                          := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB         := private_lib_driver_cmd_intel
WIFI_DRIVER_MODULE_PATH                  := "/system/lib/modules/iwlagn.ko"
WIFI_DRIVER_MODULE_NAME                  := "iwlagn"
WIFI_DRIVER_MODULE_PATH                  ?= auto
endif

# Connectivity - Wi-Fi
USES_TI_MAC80211 := true
ifeq ($(USES_TI_MAC80211),true)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB  := lib_driver_cmd_wl12xx
BOARD_HOSTAPD_PRIVATE_LIB         := lib_driver_cmd_wl12xx
BOARD_WLAN_DEVICE           := wl12xx_mac80211
BOARD_SOFTAP_DEVICE         := wl12xx_mac80211
COMMON_GLOBAL_CFLAGS += -DUSES_TI_MAC80211
COMMON_GLOBAL_CFLAGS += -DANDROID_P2P_STUB
endif

# TARGET_OUT_MODULES_DIR := $(OUT)/system/lib/modules/

# TARGET_KERNEL_MODULES += $(shell mkdir -p $(OUT)/system/lib) \
#     $(shell mkdir -p $(OUT)/system/lib/modules) \
#     $(shell cp -rf kernel_imx/net/mac80211/mac80211.ko $(TARGET_OUT_MODULES_DIR)) \
#     $(shell cp -rf kernel_imx/net/wireless/cfg80211.ko $(TARGET_OUT_MODULES_DIR)) \
#     $(shell cp -rf kernel_imx/drivers/net/wireless/ti/wl18xx/wl18xx.ko $(TARGET_OUT_MODULES_DIR)) \
#     $(shell cp -rf kernel_imx/drivers/net/wireless/ti/wlcore/wlcore_sdio.ko $(TARGET_OUT_MODULES_DIR)) \
#     $(shell cp -rf kernel_imx/drivers/net/wireless/ti/wlcore/wlcore.ko $(TARGET_OUT_MODULES_DIR)) \
#     $(shell cp -rf kernel_imx/drivers/net/wireless/ti/wl18xx/wl12xx.ko $(TARGET_OUT_MODULES_DIR))

# TARGET_KERNEL_MODULES += WLAN_MODULES

BOARD_HAVE_BLUETOOTH_TI := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/fsl/sabreauto_6q/bluetooth


BOARD_MODEM_VENDOR := AMAZON

BOARD_HAVE_HARDWARE_GPS := true
USE_ATHR_GPS_HARDWARE := true
USE_QEMU_GPS_HARDWARE := false

PHONE_MODULE_INCLUDE := flase
# for accelerometer and gyroscope
USE_IIO_SENSOR_HAL := true
NO_IIO_EVENTS := true
# USE_IIO_ACTIVITY_RECOGNITION_HAL := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
DM_VERITY_RUNTIME_CONFIG := true

# camera hal v3
IMX_CAMERA_HAL_V3 := true

BOARD_HAVE_USB_CAMERA := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

#LVDS
BOARD_KERNEL_CMDLINE := console=ttymxc3,115200 init=/init video=mxcfb0:dev=ldb,if=RGB24,fbpix=RGB32, bpp=32 video=mxcfb1:off video=mxcfb2:off video=mxcfb3:off vmalloc=128M androidboot.console=ttymxc3 consoleblank=0 androidboot.hardware=freescale cma=512M galcore.contiguousSize=201326592
#HDMI
#BOARD_KERNEL_CMDLINE := console=ttymxc3,115200 androidboot.console=ttymxc3 consoleblank=0 vmalloc=128M init=/init video=mxcfb0:dev=hdmi,1920x1080M@60,bpp=32 video=mxcfb1:off video=mxcfb2:off video=mxcfb3:off androidboot.hardware=freescale cma=512M galcore.contiguousSize=201326592
# A Few Security features Disabled
BOARD_KERNEL_CMDLINE +=  androidboot.selinux=permissive androidboot.dm_verity=disable

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
UBI_ROOT_INI := device/fsl/sabreauto_6q/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 8192 -e 1032192 -c 4096 -x none -F
TARGET_UBIRAW_ARGS := -m 8192 -p 1024KiB $(UBI_ROOT_INI)

# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:64m(bootloader),16m(bootimg),16m(recovery),1m(misc),-(root) ubi.mtd=5
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
TARGET_BOARD_DTS_CONFIG := imx6q-nand:imx6q-sabreauto-gpmi-weim.dtb  imx6dl-nand:imx6dl-sabreauto-gpmi-weim.dtb imx6qp-nand:imx6qp-sabreauto-gpmi-weim.dtb
TARGET_BOOTLOADER_CONFIG := imx6q-nand:mx6qsabreautoandroid_nand_config imx6dl-nand:mx6dlsabreautoandroid_nand_config  imx6qp-nand:mx6qpsabreautoandroid_nand_config
else 
TARGET_BOARD_DTS_CONFIG := imx6q:imx6q-sabreauto.dtb imx6dl:imx6dl-sabreauto.dtb imx6qp:imx6qp-sabreauto.dtb
TARGET_BOOTLOADER_CONFIG := imx6q:mx6qsabreautoandroid_config imx6dl:mx6dlsabreautoandroid_config imx6qp:mx6qpsabreautoandroid_config
endif

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx6/sepolicy \
       device/fsl/sabreauto_6q/sepolicy \
       device/fsl/common/sepolicy

BOARD_SECCOMP_POLICY += device/fsl/sabreauto_6q/seccomp

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
