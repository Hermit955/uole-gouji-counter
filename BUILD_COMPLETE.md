# 多乐够级记牌器 - 完整构建指南

## 当前状态

✅ **代码已完成**，包含：
- Dart 业务代码（记牌逻辑、UI界面、OCR识别）
- Android 配置文件（Gradle、Manifest）
- iOS 基础配置

❌ **需要你的环境**：
- Flutter SDK
- Android Studio / Xcode
- 用于构建的设备

---

## 快速开始（5分钟）

### 第一步：安装 Flutter

**Windows:**
```powershell
# 1. 下载 Flutter
https://docs.flutter.dev/get-started/install/windows

# 2. 解压到 C:\flutter

# 3. 添加环境变量
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\flutter\bin", "User")

# 4. 验证
flutter doctor
```

**Mac:**
```bash
brew install flutter
flutter doctor
```

### 第二步：配置项目

```bash
# 进入项目目录
cd E:\JYAI\duole_gouji_mobile

# 修改 Android SDK 路径
# 编辑 android/local.properties，改为你的实际路径：
# sdk.dir=C:\\Users\\你的用户名\\AppData\\Local\\Android\\Sdk

# 修改 Flutter 路径（如果不在 C:\flutter）
# flutter.sdk=你的Flutter路径
```

### 第三步：安装依赖

```bash
flutter pub get
```

### 第四步：构建 APK（Android）

```bash
# 调试版（快速测试）
flutter build apk --debug

# 发布版（正式使用）
flutter build apk --release
```

APK 位置：`build/app/outputs/flutter-apk/app-release.apk`

### 第五步：安装到手机

```bash
# 连接手机（开启USB调试）
flutter install

# 或手动安装
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## iOS 构建（需要 Mac）

```bash
# 1. 安装 CocoaPods
sudo gem install cocoapods

# 2. 进入 iOS 目录
cd ios
pod install
cd ..

# 3. 构建
flutter build ios --release

# 4. 用 Xcode 打开 Runner.xcworkspace 签名并发布
```

---

## 使用说明

### 首次使用

1. **开启权限**：
   - Android：设置 → 应用 → 多乐够级记牌器 → 悬浮窗权限 → 允许
   - iOS：受系统限制，悬浮窗功能受限

2. **启动记牌器**：
   - 打开 App
   - 点击"启动悬浮窗"
   - 返回游戏，悬浮窗会显示在屏幕上

3. **记牌操作**：
   - 点击鹰牌（大王/小王/2）记录出牌
   - 点击快捷按钮记录 A/K/Q
   - 点击撤销按钮撤销上一步

### 自动识别（实验性）

1. 切换到"自动识别"模式
2. 授予屏幕录制权限
3. 程序会自动识别屏幕上的牌面

---

## 常见问题

### Q: 构建失败，提示 "flutter.sdk not set"
A: 编辑 `android/local.properties`，添加：
```
flutter.sdk=C:\\flutter
```

### Q: 悬浮窗不显示
A: 检查是否开启了悬浮窗权限（Android 设置中手动开启）

### Q: iOS 无法使用悬浮窗
A: iOS 系统限制，建议使用画中画模式或切换到 Android

### Q: OCR 识别不准确
A: 受游戏界面样式影响，建议以手动记牌为主

---

## 文件清单

```
duole_gouji_mobile/
├── android/                    # Android 配置
│   ├── app/
│   │   ├── build.gradle       # ✅ 已配置
│   │   └── src/main/
│   │       └── AndroidManifest.xml  # ✅ 已配置
│   ├── build.gradle           # ✅ 已配置
│   ├── settings.gradle        # ✅ 已配置
│   ├── gradle/
│   │   └── wrapper/
│   │       └── gradle-wrapper.properties  # ✅ 已配置
│   └── local.properties       # ⚠️ 需修改路径
├── ios/                        # iOS 配置
│   └── Runner/
│       └── Info.plist         # ✅ 已配置
├── lib/                        # Dart 代码
│   ├── main.dart              # ✅ 入口
│   ├── models/
│   │   └── card_model.dart    # ✅ 数据模型
│   ├── providers/
│   │   └── counter_provider.dart  # ✅ 状态管理
│   ├── screens/
│   │   ├── home_screen.dart   # ✅ 主界面
│   │   └── overlay_screen.dart # ✅ 悬浮窗
│   └── services/
│       └── ocr_service.dart   # ✅ OCR识别
├── pubspec.yaml               # ✅ 依赖配置
└── BUILD_COMPLETE.md          # 本文件
```

---

## 需要帮助？

如果你无法自行构建，可以：

1. **找朋友帮忙**：把项目文件夹发给有 Flutter 环境的朋友
2. **使用云服务**：GitHub Actions / Codemagic 自动构建
3. **简化方案**：使用之前的 Windows 电脑版

---

**现在代码已经完整，只需要按上述步骤构建即可在手机上使用！**
