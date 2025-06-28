# H5Swift - SwiftUI WebView 模块

![Swift Version](https://img.shields.io/badge/Swift-5.6+-orange.svg) 
![Platform](https://img.shields.io/badge/iOS-11+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)

一个高性能的 SwiftUI WebView 组件，支持加载本地 HTML 文件及相对资源引用，完美适配 iOS 安全区域。

## 功能特性

✅ **本地 HTML 加载** - 直接从应用资源加载 HTML 文件  
✅ **CSS/JS/图片相对路径支持** - 完美支持同目录下的资源引用  
✅ **自动移除安全区域** - 全屏显示网页内容  
✅ **完整的加载状态处理** - 提供加载中/成功/失败回调  
✅ **错误提示与重试机制** - 自动显示错误信息并提供重试按钮  
✅ **WebKit 最新特性支持** - 兼容 iOS 11+，优化 iOS 14+ 体验  

## 快速开始

### 1. 安装

#### 通过 Swift Package Manager 安装

在 Package.swift 文件的 dependencies 数组中添加：

```swift
.package(url: "https://github.com/DannielYu219/H5Swift.git", from: "1.0.0")
```

#### 手动集成

1. 下载项目中的 `WebView.swift` 和 `WebViewExample.swift` 文件
2. 将它们拖拽到你的 Xcode 项目中
3. 确保在添加文件时勾选 "Copy items if needed"

### 2. 基本使用

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        WebView(
            htmlFileName: "index",    // HTML 文件名(不带扩展名)
            contentFolder: "WebContent" // 资源文件夹名称
        )
        .edgesIgnoringSafeArea(.all)  // 移除安全区域
    }
}
```

### 3. 项目结构配置

在项目中创建名为 "WebContent" 的文件夹，并按以下结构组织文件：

```
WebContent/
├── index.html            # 主HTML文件
├── style.css             # 样式表
├── script.js             # JavaScript
└── images/               # 图片资源
    └── logo.png          # 示例图片
```

**重要提示**：在 Xcode 中添加文件夹时，必须选择 **Create folder references** 选项（蓝色文件夹图标），这样才能保持原始目录结构。

## 高级用法

### 自定义加载状态处理

```swift
WebView(
    htmlFileName: "index",
    contentFolder: "WebContent",
    onLoadStateChange: { state in
        switch state {
        case .loading:
            print("⏳ 开始加载网页")
        case .success:
            print("✅ 网页加载成功")
        case .failure(let error):
            print("❌ 加载失败: \(error.localizedDescription)")
        }
    }
)
```

### 强制暗黑模式

```swift
let config = WKWebViewConfiguration()
if #available(iOS 14.0, *) {
    config.defaultWebpagePreferences.preferredColorScheme = .dark
}

WebView(
    configuration: config,
    htmlFileName: "index",
    contentFolder: "WebContent"
)
```

### 自定义错误视图

```swift
EnhancedWebView(
    htmlFileName: "index",
    contentFolder: "WebContent"
) {
    // 自定义加载中视图
    ProgressView("加载中...")
        .scaleEffect(1.5)
} errorView: { error in
    // 自定义错误视图
    VStack {
        Image(systemName: "exclamationmark.triangle")
            .font(.largeTitle)
        Text(error.localizedDescription)
            .padding()
        Button("重试") {
            // 自动触发重试逻辑
        }
    }
}
```

## 技术细节

### 兼容性支持

| iOS 版本 | 支持情况 | 特性说明 |
|----------|----------|----------|
| iOS 11-13 | ✅ 基本功能 | 使用传统 WebKit API |
| iOS 14+ | 🚀 增强功能 | 启用现代网页偏好设置 |

### 注意事项

1. **资源目录设置**：
   - 必须使用文件夹引用（蓝色文件夹图标）
   - HTML 中的相对路径应相对于资源文件夹根目录

2. **安全区域处理**：
   - 默认会忽略底部安全区
   - 可通过 `.edgesIgnoringSafeArea()` 自定义

3. **大文件处理**：
   - 如需包含大文件（>100MB），建议使用 Git LFS

## 示例项目

查看完整实现：

```bash
git clone https://github.com/DannielYu219/H5Swift.git
cd H5Swift
open H5Swift.xcodeproj
```

## 贡献指南

欢迎通过 Issue 或 PR 贡献代码！提交时请注意：

1. 遵循项目代码风格
2. 为新功能添加测试用例
3. 更新相关文档

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

---

📧 联系维护者：DannielYu219@github.com 或者 yubolinqwer@163.com
🐦 关注更新：[@YourTwitterHandle](https://twitter.com/YourTwitterHandle)  
💻 更多项目：https://github.com/DannielYu219
