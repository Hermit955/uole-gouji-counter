# 多乐够级记牌器 - 构建指南

## 快速开始

由于项目文件较多，以下是核心代码的说明。完整项目需要你补充一些文件。

### 已创建的文件

```
duole_gouji_mobile/
├── pubspec.yaml          # 项目配置
├── README.md            # 项目说明
├── BUILD_GUIDE.md       # 本文件
└── lib/
    ├── main.dart        # 入口
    ├── models/
    │   └── card_model.dart      # 数据模型
    ├── providers/
    │   └── counter_provider.dart # 状态管理
    ├── screens/
    │   └── home_screen.dart     # 主界面
    └── services/
        └── ocr_service.dart     # OCR服务（部分）
```

### 需要补充的文件

创建以下缺失文件：

**1. lib/services/ocr_service.dart**（完整内容）
```dart
import 'dart:io';
import 'dart:typed_data';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  static final OCRService _instance = OCRService._internal();
  factory OCRService() => _instance;
  OCRService._internal();
  
  final TextRecognizer _textRecognizer = 
      TextRecognizer(script: TextRecognitionScript.chinese);
  
  Future<List<String>> recognizeCards(Uint8List imageBytes) async {
    try {
      final tempFile = File('${Directory.systemTemp.path}/ocr_temp.jpg');
      await tempFile.writeAsBytes(imageBytes);
      
      final inputImage = InputImage.fromFile(tempFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      final cards = _parseCards(recognizedText);
      await tempFile.delete();
      
      return cards;
    } catch (e) {
      print('OCR error: $e');
      return [];
    }
  }
  
  List<String> _parseCards(RecognizedText recognizedText) {
    final cards = <String>[];
    final patterns = {
      '大王': RegExp(r'大王|king', caseSensitive: false),
      '小王': RegExp(r'小王|joker', caseSensitive: false),
      '2': RegExp(r'^[2二]$'),
      'A': RegExp(r'^[Aa1一]$'),
      'K': RegExp(r'^[Kk]$'),
      'Q': RegExp(r'^[Qq]$'),
      'J': RegExp(r'^[Jj]$'),
      '10': RegExp(r'^[10十]$'),
      '9': RegExp(r'^[9九]$'),
      '8': RegExp(r'^[8八]$'),
      '7': RegExp(r'^[7七]$'),
      '6': RegExp(r'^[6六]$'),
      '5': RegExp(r'^[5五]$'),
      '4': RegExp(r'^[4四]$'),
      '3': RegExp(r'^[3三]$'),
    };
    
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final text = line.text.trim();
        for (final entry in patterns.entries) {
          if (entry.value.hasMatch(text)) {
            cards.add(entry.key);
            break;
          }
        }
      }
    }
    return cards;
  }
  
  void dispose() {
    _textRecognizer.close();
  }
}
```

**2. android/app/src/main/AndroidManifest.xml**（添加权限）
```xml
<manifest>
    <!-- 悬浮窗权限 -->
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    
    <application
        ...>
        <activity ...>
            ...
        </activity>
    </application>
</manifest>
```

**3. android/app/build.gradle**（确保minSdk）
```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

## 构建步骤

### 1. 初始化Flutter项目
```bash
# 创建新项目
flutter create duole_gouji_counter

# 进入项目
cd duole_gouji_counter

# 替换 lib/ 目录下的文件为上面提供的代码
# 替换 pubspec.yaml
```

### 2. 安装依赖
```bash
flutter pub add provider google_mlkit_text_recognition permission_handler shared_preferences
```

### 3. 构建Android APK
```bash
# 调试版
flutter build apk

# 发布版
flutter build apk --release
```

### 4. 构建iOS（需要Mac）
```bash
flutter build ios
```

## 运行

```bash
# 连接设备后
flutter run
```

## 注意事项

1. **Android悬浮窗权限**：首次使用需要手动在系统设置中开启
2. **iOS限制**：iOS不支持真正的悬浮窗，需要使用画中画或辅助功能
3. **OCR识别**：需要Google Play服务（Android）或相应框架（iOS）

## 替代方案

如果不想完整构建，可以考虑：

1. **使用现有App**：搜索"够级记牌器"看是否有现成应用
2. **网页版**：用Flutter Web构建，在浏览器中使用
3. **电脑版**：使用之前提供的Windows版本
