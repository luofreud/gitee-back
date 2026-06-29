# MobileIMSDK Flutter 插件 - 示例项目

展示如何使用 `mobile_im_sdk` 插件,分别演示 TCP / UDP / WebSocket 三种连接方式.

## 运行

1. 确认 `flutter create` 已生成原生工程(已就绪)
2. 在此目录下执行:

```bash
flutter pub get
flutter run
```

> iOS 端需先 `cd ios && pod install`.

## 三个演示页

| 页面 | 文件 | 演示内容 |
|------|------|----------|
| 主页 | `lib/pages/home_page.dart` | 三种协议入口 |
| TCP | `lib/pages/tcp_page.dart` | 连接/登录/收发/日志 |
| UDP | `lib/pages/udp_page.dart` | 单播/广播/组播/日志 |
| WebSocket | `lib/pages/websocket_page.dart` | 文本/二进制/重连/日志 |

## 与服务端联调

启动 MobileIMSDK 仓库的演示服务端:

```bash
cd ../../../MobileIMSDK/demo_binary/Server/MobileIMSDKServerDemo_deploy_v6.5b240429
./run.sh   # 或 run.bat (Windows)
```

启动后,示例应用 IP 填 `127.0.0.1`,端口填 `7901`(WebSocket 版路径为 `/ws`).
