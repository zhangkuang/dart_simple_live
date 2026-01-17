# 📱 如何使用 GitHub Actions 构建 APK

如果你没有本地开发环境，可以使用 GitHub Actions 在云端自动构建 APK。

## 🎯 步骤

### 1. Fork 仓库

1. 访问项目主页: https://github.com/xiaoyaocz/dart_simple_live
2. 点击右上角的 `Fork` 按钮
3. 等待 Fork 完成

### 2. 启用 GitHub Actions

1. 进入你 Fork 的仓库
2. 点击顶部的 `Actions` 标签
3. 如果看到 "Workflows aren't being run on this forked repository" 提示，点击 `I understand my workflows, go ahead and enable them`

### 3. 运行构建工作流

1. 在 Actions 页面，左侧选择 `Build Android Debug APK` 工作流
2. 点击右侧的 `Run workflow` 下拉按钮
3. 保持默认选项（Branch: master），点击绿色的 `Run workflow` 按钮
4. 等待构建完成（大约 5-10 分钟）

### 4. 下载 APK

1. 构建完成后，点击工作流运行记录
2. 向下滚动到 `Artifacts` 部分
3. 点击 `android-debug-apk` 下载 ZIP 文件
4. 解压 ZIP 文件，得到 `app-debug.apk`

## 📋 注意事项

- Debug APK 文件较大（约 100-200 MB），但无需签名即可安装
- 构建的 APK 会保留 30 天，过期后会自动删除
- 每次修改代码后，需要重新运行工作流来构建新版本

## 🔄 自动触发构建

如果你修改了以下文件，推送到 master 或 dev 分支后会自动触发构建：
- `simple_live_app/` 目录下的任何文件
- `simple_live_core/` 目录下的任何文件

## ❓ 常见问题

**Q: 为什么我看不到 Run workflow 按钮？**  
A: 确保你在自己 Fork 的仓库中，而不是原始仓库。

**Q: 构建失败了怎么办？**  
A: 点击失败的工作流运行记录，查看错误日志。通常是依赖下载问题，重新运行即可。

**Q: 能构建 Release 版本吗？**  
A: Release 版本需要签名密钥，需要在仓库的 Secrets 中配置。详见 [BUILD_ANDROID.md](./BUILD_ANDROID.md)

## 🔗 相关文档

- [快速构建指南](./QUICK_BUILD.md)
- [完整构建文档](./BUILD_ANDROID.md)
- [GitHub Actions 文档](https://docs.github.com/en/actions)

---

**提示**: 如果你有本地开发环境，使用本地构建会更快。
