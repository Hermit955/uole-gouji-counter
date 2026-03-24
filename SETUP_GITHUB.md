# GitHub Actions 自动构建指南

## 使用步骤

### 第一步：创建 GitHub 仓库

1. 访问 https://github.com/new
2. 仓库名称：`duole-gouji-counter`
3. 选择 **Public**（免费）
4. 点击 **Create repository**

### 第二步：上传代码

```bash
# 进入项目目录
cd E:\JYAI\duole_gouji_mobile

# 初始化 git
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit"

# 添加远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/duole-gouji-counter.git

# 推送代码
git branch -M main
git push -u origin main
```

### 第三步：触发自动构建

推送代码后，GitHub Actions 会自动开始构建：

1. 打开 GitHub 仓库页面
2. 点击 **Actions** 标签
3. 等待构建完成（约 5-10 分钟）

### 第四步：下载 APK

构建完成后，有两种方式获取 APK：

#### 方式1：从 Actions 下载
1. 进入 **Actions** 页面
2. 点击最新的工作流运行
3. 滚动到底部，找到 **Artifacts**
4. 下载 `duole-gouji-counter-apk`

#### 方式2：从 Releases 下载
1. 进入仓库首页
2. 点击右侧的 **Releases**
3. 下载最新版本的 APK 文件

---

## 自动更新

每次你推送代码到 main 分支，都会自动触发构建：

```bash
# 修改代码后
git add .
git commit -m "更新说明"
git push

# 等待 5-10 分钟，新的 APK 就生成好了
```

---

## 项目结构说明

```
duole_gouji_mobile/
├── .github/
│   └── workflows/
│       └── build_apk.yml    # GitHub Actions 配置
├── android/                  # Android 配置
├── ios/                      # iOS 配置
├── lib/                      # Dart 代码
└── pubspec.yaml             # 依赖配置
```

---

## 常见问题

### Q: 构建失败怎么办？
A: 查看 Actions 页面的错误日志，通常是：
- 依赖版本问题 → 修改 `pubspec.yaml`
- 代码语法错误 → 本地先运行 `flutter analyze`

### Q: 如何修改应用名称/图标？
A: 
- 名称：修改 `android/app/src/main/AndroidManifest.xml` 中的 `android:label`
- 图标：替换 `android/app/src/main/res/mipmap-*` 目录下的图标文件

### Q: 可以构建 iOS 版本吗？
A: GitHub Actions 的免费版不支持 macOS，需要：
- 使用付费的 GitHub Actions macOS runner
- 或者本地用 Mac 构建

---

## 一键脚本（Windows）

创建 `upload_to_github.bat`：

```bat
@echo off
echo ========================================
echo   上传到 GitHub 并自动构建 APK
echo ========================================
echo.

set /p USERNAME="请输入你的 GitHub 用户名: "

cd /d "%~dp0"

echo [1/4] 初始化 Git...
git init
git add .
git commit -m "Initial commit"

echo [2/4] 添加远程仓库...
git remote add origin https://github.com/%USERNAME%/duole-gouji-counter.git

echo [3/4] 推送代码...
git branch -M main
git push -u origin main

echo [4/4] 完成！
echo.
echo 请访问: https://github.com/%USERNAME%/duole-gouji-counter/actions
echo 等待构建完成后即可下载 APK
echo.
pause
```

---

**现在你只需要创建一个 GitHub 仓库并上传代码，就能自动获得 APK 文件！**
