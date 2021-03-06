#
# Product-specific compile-time definitions.
#

include device/fsl/imx8/soc/imx8qxp.mk
include device/fsl/arm2_8qxp/build_id.mk
include device/fsl/imx8/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include device/fsl-codec/fsl-codec64.mk
endif
# sabreauto_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx8/imx8_target_fs.mk

ifeq ($(BUILD_TARGET_FS),ubifs)
TARGET_RECOVERY_FSTAB = device/fsl/arm2_8qxp/fstab_nand.freescale
# build ubifs for nand devices
PRODUCT_COPY_FILES +=	\
	device/fsl/arm2_8qxp/fstab_nand.freescale:root/fstab.freescale
else
ADDITIONAL_BUILD_PROPERTIES += \
                        ro.internel.storage_size=/sys/block/mmcblk1/size
ifneq ($(BUILD_TARGET_FS),f2fs)
TARGET_RECOVERY_FSTAB = device/fsl/arm2_8qxp/fstab.freescale
# build for ext4
PRODUCT_COPY_FILES +=	\
	device/fsl/arm2_8qxp/fstab.freescale:root/fstab.freescale
else
TARGET_RECOVERY_FSTAB = device/fsl/arm2_8qxp/fstab-f2fs.freescale
# build for f2fs
PRODUCT_COPY_FILES +=	\
	device/fsl/arm2_8qxp/fstab-f2fs.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS

PRODUCT_COPY_FILES +=	\
	device/fsl/arm2_8qxp/fstab.freescale.sd:root/fstab.freescale.sd
# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions.bpt

endif # BUILD_TARGET_FS

TARGET_BOOTLOADER_BOARD_NAME := SABREAUTO

PRODUCT_MODEL := ARM2-MX8QXP

TARGET_BOOTLOADER_POSTFIX := bin

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx8
# UNITE is a virtual device support both atheros and realtek wifi(ar6103 and rtl8723as)
BOARD_WLAN_DEVICE            := UNITE
WPA_SUPPLICANT_VERSION       := VER_0_8_UNITE
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB_RTL               := lib_driver_cmd_rtl
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_RTL        := lib_driver_cmd_rtl
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

BOARD_MODEM_VENDOR := AMAZON

USE_ATHR_GPS_HARDWARE := false
USE_QEMU_GPS_HARDWARE := false

PHONE_MODULE_INCLUDE := flase
BOARD_USE_SENSOR_FUSION_64BIT := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
DM_VERITY_RUNTIME_CONFIG := true

UBOOT_POST_PROCESS := true

# camera hal v3
IMX_CAMERA_HAL_V3 := true

BOARD_HAVE_USB_CAMERA := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

BOARD_KERNEL_CMDLINE := console=ttyLP0,115200 earlycon=lpuart32,0x5a060000,115200,115200 init=/init video=imxdpufb1:off video=imxdpufb2:off video=imxdpufb3:off video=imxdpufb4:off androidboot.zygote=zygote64_32 androidboot.console=ttyLP0 consoleblank=0 androidboot.hardware=freescale cma=800M androidboot.watchdogd=disabled androidboot.storage_type=sd galcore.powerManagement=0 androidboot.serialno=150831d4e1fdfca7


ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

TARGET_BOARD_DTS_CONFIG := imx8qxp:fsl-imx8qxp-lpddr4-arm2.dtb
TARGET_BOOTLOADER_CONFIG := imx8qxp:mx8qxp_lpddr4_arm2_android_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx8/sepolicy \
       device/fsl/arm2_8qxp/sepolicy \
       device/fsl/common/sepolicy

BOARD_SECCOMP_POLICY += device/fsl/arm2_8qxp/seccomp

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
