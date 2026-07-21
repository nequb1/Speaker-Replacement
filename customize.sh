#!/bin/sh

[ -z "$ARCH" ] && ARCH=$(uname -m)

ANDROID_VERSION=$(getprop ro.build.version.release)
API_LEVEL=$(getprop ro.build.version.sdk)
BUILD_ID=$(getprop ro.build.display.id)
[ -z "$BUILD_ID" ] && BUILD_ID=$(getprop ro.build.id)

DEVICE_MODEL=$(getprop ro.product.model)
DEVICE_BRAND=$(getprop ro.product.manufacturer)
DEVICE_CODENAME=$(getprop ro.product.device)

KERNEL_RELEASE=$(uname -r)

ROOT_MANAGER="Unknown"
if [ "$KSUN" = "true" ] || [ "$KSU_NEXT" = "true" ] || [ -n "$KSUN_VER_CODE" ]; then
  ROOT_MANAGER="KernelSU Next"
elif [ "$KSU" = "true" ]; then
  ROOT_MANAGER="KernelSU (v$KSU_VER_CODE)"
elif [ "$APATCH" = "true" ]; then
  ROOT_MANAGER="APatch (v$APATCH_VER_CODE)"
elif [ -n "$MAGISK_VER" ]; then
  ROOT_MANAGER="Magisk ($MAGISK_VER)"
fi

[ -z "$API_LEVEL" ] && API_LEVEL=0
[ -z "$ANDROID_VERSION" ] && ANDROID_VERSION="unknown"
[ -z "$BUILD_ID" ] && BUILD_ID="unknown"

ui_print "-----------------------------------------------"
ui_print "- Model: $DEVICE_BRAND $DEVICE_MODEL [$DEVICE_CODENAME]"
ui_print "- Android OS: $ANDROID_VERSION (API $API_LEVEL)"
ui_print "- Build ID: $BUILD_ID"
ui_print "- Root Manager: $ROOT_MANAGER"
ui_print "- Kernel Release: $KERNEL_RELEASE"
ui_print "- Architecture: $ARCH"
ui_print "-----------------------------------------------"

ui_print "- Checking Android API level..."
if [ "$API_LEVEL" -lt 31 ] 2>/dev/null; then
  ui_print "  [FAIL] Android 12 / API 31 or higher required (found API: $API_LEVEL)"
  abort
else
  ui_print "  [OK] Android version supported (API $API_LEVEL)"
fi

ui_print "- Checking device model..."
if [ "$DEVICE_CODENAME" != "bluejay" ]; then
  ui_print "  [FAIL] Unsupported device ($DEVICE_CODENAME, expected bluejay)"
  abort
else
  ui_print "  [OK] Device matches (bluejay)"
fi

ui_print "- Checking CPU architecture..."
if [ "$ARCH" != "arm64" ] && [ "$ARCH" != "aarch64" ]; then
  ui_print "  [FAIL] Unsupported architecture ($ARCH)"
  abort
else
  ui_print "  [OK] Architecture supported ($ARCH)"
fi

SYS_XML="/vendor/etc/mixer_paths.xml"
MOD_XML="$MODPATH/system/vendor/etc/mixer_paths.xml"

ui_print "- Checking system file..."
if [ ! -f "$SYS_XML" ]; then
  ui_print "  [FAIL] System file missing: $SYS_XML"
  abort
else
  ui_print "  [OK] System file found"
fi

if [ -f "/vendor/etc/mixer_paths_cloud.xml" ]; then
  ui_print "  [INFO] Secondary mixer_paths_cloud.xml detected on system"
fi

ui_print "- Checking module file in ZIP..."
if [ ! -f "$MOD_XML" ]; then
  ui_print "  [FAIL] Module file missing in ZIP: $MOD_XML"
  abort
else
  ui_print "  [OK] Module file found in ZIP"
fi

ui_print "- Comparing system and module files..."
if cmp -s "$SYS_XML" "$MOD_XML"; then
  ui_print "  [INFO] Files are identical. No replacement needed."
else
  ui_print "  [INFO] Replacing stock file with modified file."
fi

ui_print "- Setting permissions and SELinux context..."
set_perm $MOD_XML 0 0 0644
chcon u:object_r:vendor_configs_file:s0 $MOD_XML 2>/dev/null
ui_print "  [OK] Permissions set successfully"

ui_print "-----------------------------------------------"
ui_print " Success! Reboot your device to apply changes."
ui_print "-----------------------------------------------"
