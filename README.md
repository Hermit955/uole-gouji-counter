# 多乐够级记牌器 - 移动端（Flutter）

跨平台移动端记牌器，支持 Android 和 iOS。

## 功能特性

- 悬浮窗显示（Android）/ 画中画（iOS）
- 手动记牌模式
- 自动OCR识别模式
- 实时统计剩余牌数
- 鹰牌（大小王、2）重点监控
- 智能出牌建议

## 技术栈

- **框架**: Flutter 3.x
- **状态管理**: Provider
- **OCR**: Google ML Kit
- **悬浮窗**: flutter_overlay_window (Android)

## 安装步骤

### 1. 环境准备
```bash
# 安装 Flutter
https://docs.flutter.dev/get-started/install

# 验证环境
flutter doctor
```

### 2. 克隆项目
```bash
cd duole_gouji_mobile
```

### 3. 安装依赖
```bash
flutter pub get
```

### 4. 运行
```bash
# Android
flutter run

# iOS (需要Mac)
flutter run -d ios
```

## 项目结构

```
lib/
├── main.dart                 # 入口文件
├── models/
│   └── card_model.dart       # 牌型数据模型
├── providers/
│   └── counter_provider.dart # 状态管理
├── screens/
│   ├── home_screen.dart      # 主界面
│   └── overlay_screen.dart   # 悬浮窗界面
├── services/
│   └── ocr_service.dart      # OCR识别服务
├── widgets/
│   ├── eagle_card_panel.dart # 鹰牌面板
│   ├── normal_card_panel.dart# 普通牌面板
│   └── suggestion_panel.dart # 建议面板
└── utils/
    └── constants.dart        # 常量定义
```

## 使用说明

1. 启动App后，点击"启动悬浮窗"
2. 在游戏中打开记牌器悬浮窗
3. 手动点击记录出牌，或开启自动识别
4. 观察颜色提示判断危险牌

## 注意事项

- Android 需要开启悬浮窗权限
- iOS 需要使用画中画模式
- 自动识别需要授予屏幕录制权限

## 开发计划

- [ ] 完善iOS画中画支持
- [ ] 优化OCR识别准确率
- [ ] 添加语音播报
- [ ] 支持更多够级玩法
