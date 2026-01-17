# Android APK 快速构建指南

## 🚀 快速开始（3 步构建）

### Windows 用户

```cmd
# 双击运行 build_android.bat
# 或者在命令行中：
build_android.bat
```

### Linux/Mac 用户

```bash
./build_android.sh
```

## 📋 详细文档

完整的构建指南请查看：[BUILD_ANDROID.md](./BUILD_ANDROID.md)

## 💡 最简单的方法

### 方法 1: 使用构建脚本（推荐）

1. 确保已安装 [Flutter SDK](https://flutter.dev/docs/get-started/install)
2. 运行构建脚本：
   - Windows: 双击 `build_android.bat`
   - Linux/Mac: 运行 `./build_android.sh`
3. 选择 `1` 构建 Debug APK（无需签名）
4. 在 `simple_live_app/build/app/outputs/flutter-apk/` 找到生成的 APK

### 方法 2: 使用 GitHub Actions

1. Fork 此仓库
2. 进入 Actions 标签
3. 运行 "Build Android Debug APK" 工作流
4. 从 Artifacts 下载构建好的 APK

### 方法 3: 命令行构建

```bash
# 进入项目目录
cd simple_live_app

# 获取依赖
flutter pub get

# 构建 Debug APK
flutter build apk --debug

# APK 位置: build/app/outputs/flutter-apk/app-debug.apk
```

## ❓ 常见问题

**Q: 我没有签名密钥怎么办？**  
A: 使用 Debug 模式构建，不需要签名密钥。运行构建脚本并选择选项 1。

**Q: 构建需要多长时间？**  
A: 首次构建约 5-10 分钟（需要下载依赖），后续构建约 2-3 分钟。

**Q: 构建的 APK 在哪里？**  
A: `simple_live_app/build/app/outputs/flutter-apk/` 目录下。

**Q: Debug APK 和 Release APK 有什么区别？**  
A: Debug APK 文件较大，但无需签名密钥，适合测试。Release APK 文件较小，性能更好，但需要签名密钥。

## 📦 APK 下载建议

构建完成后，推荐安装以下版本：

- **arm64-v8a** - 适用于大多数现代 Android 设备（推荐）
- **armeabi-v7a** - 适用于较旧的 32 位设备
- **x86_64** - 适用于模拟器或特殊设备

## 🔗 相关链接

- [完整构建文档](./BUILD_ANDROID.md)
- [Flutter 官方文档](https://flutter.dev/docs)
- [项目主页](./README.md)

---

如有问题，请提交 [Issue](https://github.com/xiaoyaocz/dart_simple_live/issues)
