#!/bin/bash

# Simple Live Android 构建脚本
# 此脚本用于快速构建 Android APK

set -e  # 遇到错误立即退出

echo "======================================"
echo "Simple Live Android 构建脚本"
echo "======================================"
echo ""

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 Flutter 是否安装
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}错误: 未找到 Flutter。请先安装 Flutter SDK。${NC}"
    echo "下载地址: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo -e "${GREEN}✓${NC} Flutter 已安装"
flutter --version
echo ""

# 询问构建类型
echo "请选择构建类型:"
echo "1) Debug APK (快速，无需签名密钥)"
echo "2) Release APK (需要签名密钥)"
echo "3) Release APK - 分架构 (推荐，文件更小)"
echo ""
read -p "请输入选项 [1-3]: " BUILD_TYPE

# 进入应用目录
cd "$(dirname "$0")/simple_live_app"

# 获取依赖
echo ""
echo -e "${YELLOW}正在获取 Flutter 依赖...${NC}"
flutter pub get

echo ""
case $BUILD_TYPE in
    1)
        echo -e "${YELLOW}构建 Debug APK...${NC}"
        flutter build apk --debug
        echo ""
        echo -e "${GREEN}✓ 构建成功!${NC}"
        echo ""
        echo "APK 文件位置:"
        echo "  $(pwd)/build/app/outputs/flutter-apk/app-debug.apk"
        ;;
    2)
        # 检查签名密钥
        if [ ! -f "android/key.properties" ]; then
            echo -e "${RED}错误: 未找到签名配置文件 android/key.properties${NC}"
            echo "请参考 BUILD_ANDROID.md 文档配置签名密钥"
            exit 1
        fi
        
        echo -e "${YELLOW}构建 Release APK (所有架构合并)...${NC}"
        flutter build apk --release
        echo ""
        echo -e "${GREEN}✓ 构建成功!${NC}"
        echo ""
        echo "APK 文件位置:"
        echo "  $(pwd)/build/app/outputs/flutter-apk/app-release.apk"
        ;;
    3)
        # 检查签名密钥
        if [ ! -f "android/key.properties" ]; then
            echo -e "${RED}错误: 未找到签名配置文件 android/key.properties${NC}"
            echo "请参考 BUILD_ANDROID.md 文档配置签名密钥"
            exit 1
        fi
        
        echo -e "${YELLOW}构建 Release APK (分架构)...${NC}"
        flutter build apk --release --split-per-abi
        echo ""
        echo -e "${GREEN}✓ 构建成功!${NC}"
        echo ""
        echo "APK 文件位置:"
        echo "  $(pwd)/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk  (32位 ARM)"
        echo "  $(pwd)/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk    (64位 ARM，推荐)"
        echo "  $(pwd)/build/app/outputs/flutter-apk/app-x86_64-release.apk       (x86_64)"
        ;;
    *)
        echo -e "${RED}无效的选项${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${YELLOW}文件大小:${NC}"
ls -lh build/app/outputs/flutter-apk/*.apk

echo ""
echo -e "${GREEN}======================================"
echo "构建完成!"
echo "======================================${NC}"
