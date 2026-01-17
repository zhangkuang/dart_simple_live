@echo off
REM Simple Live Android 构建脚本 (Windows)
REM 此脚本用于快速构建 Android APK

setlocal enabledelayedexpansion

echo ======================================
echo Simple Live Android 构建脚本
echo ======================================
echo.

REM 检查 Flutter 是否安装
where flutter >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [错误] 未找到 Flutter。请先安装 Flutter SDK。
    echo 下载地址: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo [√] Flutter 已安装
flutter --version
echo.

REM 询问构建类型
echo 请选择构建类型:
echo 1^) Debug APK ^(快速，无需签名密钥^)
echo 2^) Release APK ^(需要签名密钥^)
echo 3^) Release APK - 分架构 ^(推荐，文件更小^)
echo.
set /p BUILD_TYPE="请输入选项 [1-3]: "

REM 进入应用目录
cd /d "%~dp0simple_live_app"

REM 获取依赖
echo.
echo [正在获取 Flutter 依赖...]
call flutter pub get

echo.
if "%BUILD_TYPE%"=="1" (
    echo [构建 Debug APK...]
    call flutter build apk --debug
    if !ERRORLEVEL! equ 0 (
        echo.
        echo [√] 构建成功!
        echo.
        echo APK 文件位置:
        echo   %CD%\build\app\outputs\flutter-apk\app-debug.apk
    ) else (
        echo.
        echo [×] 构建失败
        pause
        exit /b 1
    )
) else if "%BUILD_TYPE%"=="2" (
    REM 检查签名密钥
    if not exist "android\key.properties" (
        echo [错误] 未找到签名配置文件 android\key.properties
        echo 请参考 BUILD_ANDROID.md 文档配置签名密钥
        pause
        exit /b 1
    )
    
    echo [构建 Release APK ^(所有架构合并^)...]
    call flutter build apk --release
    if !ERRORLEVEL! equ 0 (
        echo.
        echo [√] 构建成功!
        echo.
        echo APK 文件位置:
        echo   %CD%\build\app\outputs\flutter-apk\app-release.apk
    ) else (
        echo.
        echo [×] 构建失败
        pause
        exit /b 1
    )
) else if "%BUILD_TYPE%"=="3" (
    REM 检查签名密钥
    if not exist "android\key.properties" (
        echo [错误] 未找到签名配置文件 android\key.properties
        echo 请参考 BUILD_ANDROID.md 文档配置签名密钥
        pause
        exit /b 1
    )
    
    echo [构建 Release APK ^(分架构^)...]
    call flutter build apk --release --split-per-abi
    if !ERRORLEVEL! equ 0 (
        echo.
        echo [√] 构建成功!
        echo.
        echo APK 文件位置:
        echo   %CD%\build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk  ^(32位 ARM^)
        echo   %CD%\build\app\outputs\flutter-apk\app-arm64-v8a-release.apk    ^(64位 ARM，推荐^)
        echo   %CD%\build\app\outputs\flutter-apk\app-x86_64-release.apk       ^(x86_64^)
    ) else (
        echo.
        echo [×] 构建失败
        pause
        exit /b 1
    )
) else (
    echo [无效的选项]
    pause
    exit /b 1
)

echo.
echo [文件大小:]
dir /b build\app\outputs\flutter-apk\*.apk 2>nul
if %ERRORLEVEL% equ 0 (
    for %%f in (build\app\outputs\flutter-apk\*.apk) do (
        echo   %%~nf%%~xf - %%~zf bytes
    )
)

echo.
echo ======================================
echo 构建完成!
echo ======================================
pause
