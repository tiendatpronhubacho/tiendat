#!/usr/bin/env bash
set -euo pipefail

echo "=== Bắt đầu build OGIOS unsigned ==="

# 1. Build app bằng xcodebuild
xcodebuild -project ThreeOneOSFive.xcodeproj \
           -scheme OGIOS \
           -configuration Release \
           -sdk iphoneos \
           -derivedDataPath ./build \
           CODE_SIGN_IDENTITY="" \
           CODE_SIGNING_REQUIRED=NO \
           CODE_SIGNING_ALLOWED=NO \
           build

# 2. Tìm file .app vừa build
APP_PATH=$(find ./build/Build/Products/Release-iphoneos -name "*.app" -maxdepth 1 | head -n 1)
if [ -z "$APP_PATH" ]; then
    echo "Lỗi: Không tìm thấy file .app"
    exit 1
fi
echo "Tìm thấy app tại: $APP_PATH"

# 3. Tạo thư mục Payload và copy .app vào
rm -rf Payload
mkdir -p Payload
cp -R "$APP_PATH" Payload/

# 4. Nhét thẳng file patch vào trong .app (Bỏ qua Xcode)
APP_NAME=$(basename "$APP_PATH")
PATCHES_SRC="ThreeOneOSFive/Patches"
PATCHES_DEST="Payload/$APP_NAME/Patches"

if [ -d "$PATCHES_SRC" ]; then
    echo "Đang copy file patch từ $PATCHES_SRC vào $PATCHES_DEST..."
    mkdir -p "$PATCHES_DEST"
    cp "$PATCHES_SRC"/*.3105 "$PATCHES_DEST/" 2>/dev/null || true
else
    echo "Cảnh báo: Không tìm thấy thư mục $PATCHES_SRC"
fi

# 5. Đóng gói thành file .ipa
IPA_NAME="OGIOS-unsigned.ipa"
rm -f "$IPA_NAME"
zip -r "$IPA_NAME" Payload > /dev/null
rm -rf Payload

echo "=== Build thành công: $IPA_NAME ==="