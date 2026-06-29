# 平台权限与配置

## Android

### 必需权限 (`android/src/main/AndroidManifest.xml`)

| 权限 | 用途 |
|------|------|
| `INTERNET` | TCP/UDP/WebSocket 连接 |
| `ACCESS_NETWORK_STATE` | 检测网络可用性 |
| `ACCESS_WIFI_STATE` | WiFi 信息 |
| `CHANGE_WIFI_MULTICAST_STATE` | UDP 组播锁 |
| `CHANGE_WIFI_STATE` | WiFi 切换时保留连接 |
| `WAKE_LOCK` | 后台保活（可选） |
| `FOREGROUND_SERVICE` | 前台服务保活（可选） |

### 示例工程额外配置 (`example/android/app/src/main/AndroidManifest.xml`)

- `android:usesCleartextTraffic="true"` 允许明文 HTTP（仅开发环境）
- `minSdkVersion 21`、`targetSdkVersion 33`

## iOS

### 必需配置 (`ios/Runner/Info.plist`)

| Key | 用途 |
|-----|------|
| `NSAppTransportSecurity.NSAllowsArbitraryLoads` | 允许 ws://（开发环境） |
| `NSAppTransportSecurity.NSAllowsLocalNetworking` | 允许局域网连接 |
| `NSLocalNetworkUsageDescription` | UDP 局域网发现的隐私说明 |
| `NSBonjourServices` | Bonjour 服务发现 |

### 平台要求

- iOS 11.0+
- Swift 5.0+
- Xcode 14.0+

## macOS

### 必需配置 (`macos/Runner/Info.plist`)

| Key | 用途 |
|-----|------|
| `com.apple.security.network.client` | 允许出站网络连接 |
| `com.apple.security.network.server` | 允许入站网络连接（UDP 监听） |
| `NSLocalNetworkUsageDescription` | UDP 局域网发现的隐私说明 |

### 平台要求

- macOS 10.14+
- Xcode 14.0+

## Windows

### 网络要求

- 防火墙放行应用可执行文件的 TCP/UDP 端口
- UDP 组播需在路由器/交换机启用 IGMP
- 无系统权限声明要求（`.exe` 无需额外 manifest）

### 已知问题

- 没有组播路由的 Windows 机器上调用 `joinMulticast()` 会返回 `OSError 10065`，SDK 已降级为 warning，业务层无感知

## Linux

### 网络要求

- 无系统权限声明要求
- TCP/UDP/WebSocket 默认可用
- UDP 组播需内核 `CONFIG_IP_MULTICAST` 支持（默认开启）

## Web

### 限制

- **仅支持 WebSocket** — TCP 和 UDP 在 Web 平台不可用
- `ConnectionType.tcp` / `ConnectionType.udp` 调用会在运行时报错
- 需服务端支持 WebSocket 协议（`ws://` 或 `wss://`）
- 条件导出自动处理编译时隔离，无需手动排除文件

## 平台桩说明

本插件采用 **纯 Dart 实现**，平台层只做：

- **Android** — `MobileImSdkPlugin.kt` 负责插件注册
- **iOS** — `MobileImSdkPlugin.swift` 负责插件注册
- **macOS** — `MobileImSdkPlugin.swift` 负责插件注册
- **Windows** — `MobileImSdkPlugin.cpp` 负责插件注册
- **Linux** — `MobileImSdkPlugin.cc` 负责插件注册
- **Web** — `MobileImSdkWeb` 负责插件注册

> 实际 TCP/UDP/WebSocket 通信完全在 Dart 层基于 `dart:io` 与 `web_socket_channel` 实现，确保跨端一致性。
