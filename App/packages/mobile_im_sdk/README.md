# MobileIMSDK Flutter 插件

MobileIMSDK 的 Flutter 插件实现，提供 **TCP / UDP / WebSocket** 三种网络连接方式，统一封装，API 风格对标 MobileIMSDK Android/iOS 官方版本。

## 特性

- **三协议统一接口** — TCP / UDP / WebSocket 共享同一 `IMClient` 抽象，业务层无感知切换
- **完整 IM 协议** — 登录/注销/心跳/收发消息/QoS 重传/被踢下线完整流程
- **DispatchCenter 消息路由** — 按消息类型统一分发，消除重复逻辑
- **QoS 重传机制** — 发送端 3s 容限 + 指数退避，接收端 10 分钟 TTL 清理
- **网络监听** — 基于 `connectivity_plus` 的网络状态变化感知
- **健全的错误处理** — 完整错误码体系（对齐 `ErrorCode.h`）与事件回调
- **纯 Dart 实现** — 基于 `dart:io` + `web_socket_channel`，平台桩仅为空壳注册
- **条件导出** — Web 平台自动降级，不编译 TCP/UDP 代码
- **分级日志** — DEBUG / INFO / WARN / ERROR 全级别日志
- **测试覆盖** — 60 个单元测试与集成测试
- **全平台支持** — Android / iOS / macOS / Windows / Linux / Web

## 平台支持

| 平台 | TCP | UDP | WebSocket | 说明 |
|------|:---:|:---:|:---------:|------|
| Android | ✅ | ✅ | ✅ | 需 `INTERNET` 等权限 |
| iOS | ✅ | ✅ | ✅ | 需配置 `NSAppTransportSecurity` |
| macOS | ✅ | ✅ | ✅ | 需配置联网权限 |
| Windows | ✅ | ✅ | ✅ | 防火墙放行 |
| Linux | ✅ | ✅ | ✅ | 无特殊要求 |
| Web | ❌ | ❌ | ✅ | 仅 WebSocket，无原生 socket |

## 安装

在 Flutter 项目的 `pubspec.yaml` 中添加：

```yaml
dependencies:
  mobile_im_sdk:
    path: ../mobile_im_sdk  # 或使用 git/pub 路径
```

## 快速开始

```dart
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

void main() async {
  // 1. 注册 AppKey
  await IMConfig.register(appKey: 'your-app-key');

  // 2. 配置服务器
  IMConfig.serverIp = '127.0.0.1';
  IMConfig.serverPort = 7901;
  IMConfig.senseMode = SenseMode.mode5S;
  IMConfig.debug = true;

  // 3. 创建客户端（支持 TCP / UDP / WebSocket）
  final IMClient client = IMFactory.create(ConnectionType.tcp);

  // 4. 设置事件回调
  client.baseEvent = ChatBaseEvent(
    onLoginResponse: (int code) {
      print('登录响应: $code');
    },
    onLinkClose: (int code) {
      print('连接断开: $code');
    },
    onKickout: (PKickoutInfo ki) {
      print('被踢: code=${ki.code} msg=${ki.reason}');
    },
  );

  client.messageEvent = ChatMessageEvent(
    onRecieveMessage: (fp, uid, content, type) {
      print('收到消息: $content from $uid');
    },
  );

  client.qosEvent = MessageQoSEvent(
    onSendSuccess: (String fp) => print('发送成功: $fp'),
    onSendFailed: (String fp, int code) => print('发送失败: $fp code=$code'),
  );

  // 5. 初始化
  await client.initCore();

  // 6. 登录
  final int rc = await client.sendLogin(userId: 'user123', token: 'token123');
  if (rc == 0) {
    print('登录成功');
  }

  // 7. 发送消息（content 为结构化 JSON 字符串）
  await client.sendText(
    fromUserId: 'user123',
    toUserId: 'user456',
    content: '{"type":"text","content":"你好"}',
  );
}
```

## 三种连接方式

| 类型 | 实现类 | 适用场景 |
|------|--------|----------|
| TCP | `TcpImClient` | 可靠长连接、移动网络、低功耗 |
| UDP | `UdpImClient` | 高实时性、局域网广播/组播 |
| WebSocket | `WebSocketImClient` | Web 互通、HTTPS 部署 |

通过 `IMFactory.create(ConnectionType.tcp/udp/websocket)` 切换。

## 消息发送

```dart
// 文本消息（结构化 JSON）
await client.sendText(fromUserId: 'u1', toUserId: 'u2', content: '{"type":"text","content":"hello"}');

// 二进制消息
await client.sendBytes(fromUserId: 'u1', toUserId: 'u2', bytes: [0x01, 0x02]);

// 回声测试（服务端原样返回）
await client.sendEcho(fromUserId: 'u1', toUserId: 'u2', content: 'ping');
```

## 自动重连

`IMConfig.autoReconnect = true`（默认）时，断线后以指数退避（2/4/8...30s 上限）自动重连。重连成功自动发送登录。

## 文档

- [API 参考](./API.md)
- [平台权限](./PLATFORMS.md)
- [示例项目](./example/)
- [变更日志](./CHANGELOG.md)
- [开发者指南](../AGENTS.md)

## 开发者命令

```shell
cd Flutter_Client/mobile_im_sdk
flutter analyze lib\           # 零错误要求
flutter test                   # 运行全部 60 个测试
flutter test test/transport/tcp_im_client_test.dart  # 单个测试
```

## License

Apache 2.0
