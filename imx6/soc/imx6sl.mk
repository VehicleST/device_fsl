#
# SoC-specific compile-time definitions.
#

BOARD_SOC_TYPE := IMX6SL
BOARD_HAVE_VPU := false
HAVE_FSL_IMX_GPU2D := true
HAVE_FSL_IMX_GPU3D := false
HAVE_FSL_IMX_IPU := false
HAVE_FSL_IMX_PXP := true
BOARD_KERNEL_BASE := 0x82800000
LOAD_KERNEL_ENTRY := 0x80008000
TARGET_KERNEL_DEFCONF := imx_v7_android_defconfig
-include external/fsl_imx_omx/codec_env.mk
TARGET_GRALLOC_VERSION := v3
TARGET_HIGH_PERFORMANCE := false
# HWComposer version depends on this.
TARGET_USES_HWC2 := true
TARGET_HWCOMPOSER_VERSION := v2.0
TARGET_HAVE_VIV_HWCOMPOSER = true
TARGET_FSL_IMX_2D := GPU2D
USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := false

