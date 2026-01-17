# Android APK 打包指南

本文档介绍如何编译和打包 Simple Live 的 Android 版本应用。

## 前置要求

在开始打包之前，请确保您的开发环境已安装以下工具：

### 必需工具

1. **Flutter SDK**
   - 版本: 3.38.x 或更高
   - 下载地址: https://flutter.dev/docs/get-started/install
   - 验证安装: `flutter --version`

2. **Java JDK**
   - 版本: JDK 17
   - 推荐使用 Zulu OpenJDK: https://www.azul.com/downloads/
   - 验证安装: `java -version`

3. **Android SDK**
   - 通过 Android Studio 安装，或使用 Flutter 自带的 SDK
   - 确保 `ANDROID_HOME` 环境变量已设置

4. **Git**
   - 用于克隆仓库和管理代码

## 快速开始

### 方法一：构建 Debug APK（推荐用于测试）

Debug APK 不需要签名密钥，适合快速测试。

```bash
# 1. 克隆仓库
git clone https://github.com/xiaoyaocz/dart_simple_live.git
cd dart_simple_live

# 2. 进入应用目录
cd simple_live_app

# 3. 获取依赖
flutter pub get

# 4. 构建 Debug APK
flutter build apk --debug

# 5. APK 文件位置
# simple_live_app/build/app/outputs/flutter-apk/app-debug.apk
```

### 方法二：使用 GitHub Actions 自动构建

本项目已配置 GitHub Actions 工作流，可以自动构建 Debug APK：

1. Fork 本仓库到您的 GitHub 账号
2. 进入您的仓库，点击 `Actions` 标签
3. 选择 `Build Android Debug APK` 工作流
4. 点击 `Run workflow` 按钮
5. 等待构建完成后，在 Artifacts 中下载 APK

### 方法三：构建 Release APK（需要签名密钥）

Release APK 需要签名才能在设备上安装。

#### 步骤 1：创建签名密钥

```bash
# 生成密钥库文件 (keystore)
keytool -genkey -v -keystore ~/simple_live_key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias simple_live

# 按照提示输入密钥库密码、密钥密码等信息
# 请妥善保管密钥库文件和密码！
```

#### 步骤 2：配置签名信息

在 `simple_live_app/android/` 目录下创建 `key.properties` 文件：

```properties
storeFile=/path/to/your/simple_live_key.jks
storePassword=您的密钥库密码
keyPassword=您的密钥密码
keyAlias=simple_live
```

**重要提示**: 
- 不要将 `key.properties` 和 `.jks` 文件提交到 Git 仓库
- 这些文件已在 `.gitignore` 中排除

#### 步骤 3：构建 Release APK

```bash
# 进入应用目录
cd simple_live_app

# 构建 Release APK (所有架构合并)
flutter build apk --release

# 或者构建分架构的 APK (文件更小)
flutter build apk --release --split-per-abi

# APK 文件位置：
# 合并版本: simple_live_app/build/app/outputs/flutter-apk/app-release.apk
# 分架构版本:
#   - app-armeabi-v7a-release.apk  (32位 ARM 设备)
#   - app-arm64-v8a-release.apk    (64位 ARM 设备，推荐)
#   - app-x86_64-release.apk       (x86_64 设备)
```

## APK 架构说明

| 架构 | 说明 | 适用设备 |
|------|------|---------|
| armeabi-v7a | 32位 ARM | 较旧的 Android 设备 |
| arm64-v8a | 64位 ARM | 现代 Android 设备（推荐） |
| x86_64 | x86 64位 | Android 模拟器和少数设备 |

**推荐**: 下载 `arm64-v8a` 版本，文件更小且性能更好。

## 常见问题

### 1. Flutter 版本不匹配

如果遇到 Flutter 版本相关错误：

```bash
# 切换到推荐的 Flutter 版本
flutter channel stable
flutter upgrade
flutter --version
```

### 2. 依赖下载失败

如果在中国大陆遇到依赖下载缓慢或失败：

```bash
# 使用 Flutter 中国镜像
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 然后重新获取依赖
flutter pub get
```

### 3. Gradle 构建失败

```bash
# 清理 Gradle 缓存
cd simple_live_app/android
./gradlew clean

# 返回上级目录重新构建
cd ..
flutter build apk --debug
```

### 4. 签名配置错误

如果构建 Release 版本时出现签名错误：

- 检查 `key.properties` 文件路径是否正确
- 确认密钥库密码和密钥密码是否正确
- 确保 `key.properties` 文件格式正确（无多余空格）

## 安装 APK

### 通过 ADB 安装

```bash
# 连接设备并启用 USB 调试
adb devices

# 安装 APK
adb install simple_live_app/build/app/outputs/flutter-apk/app-debug.apk

# 如果设备上已有旧版本
adb install -r simple_live_app/build/app/outputs/flutter-apk/app-debug.apk
```

### 直接在设备上安装

1. 将 APK 文件传输到 Android 设备
2. 在设备上启用"未知来源"应用安装权限
3. 使用文件管理器找到 APK 文件并点击安装

## 进阶选项

### 优化 APK 大小

```bash
# 启用代码混淆和资源压缩
flutter build apk --release --obfuscate --split-debug-info=./debug-info

# 分架构构建（推荐）
flutter build apk --release --split-per-abi
```

### 构建 App Bundle (AAB)

如果要上传到 Google Play：

```bash
flutter build appbundle --release
```

生成的 AAB 文件位置：
`simple_live_app/build/app/outputs/bundle/release/app-release.aab`

## 自动化构建

项目包含以下 GitHub Actions 工作流：

1. **build_android_debug.yml** - 自动构建 Debug APK
2. **publish_app_dev.yaml** - 开发版本发布
3. **publish_app_release.yml** - 正式版本发布（需要签名密钥）

## 相关资源

- [Flutter 官方文档](https://flutter.dev/docs)
- [Android 应用签名](https://developer.android.com/studio/publish/app-signing)
- [项目 README](./README.md)

## 技术支持

如遇到问题，请在 GitHub Issues 中反馈：
https://github.com/xiaoyaocz/dart_simple_live/issues

---

**注意**: 本项目仅供学习交流使用，严禁用于商业目的。
