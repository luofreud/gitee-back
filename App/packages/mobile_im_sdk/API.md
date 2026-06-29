# MobileIMSDK Flutter 插件 — API 参考

> 适用版本: `mobile_im_sdk 1.0.0`

## 目录

1. [快速开始](#1-快速开始)
2. [核心类型](#2-核心类型)
3. [配置: IMConfig](#3-配置-imconfig)
4. [错误码: ErrorCode](#4-错误码-errorcode)
5. [消息: IMMessage](#5-消息-immessage)
6. [协议对象](#6-协议对象)
7. [客户端接口: IMClient / IMFactory](#7-客户端接口-imclient--imfactory)
8. [事件回调](#8-事件回调)
9. [连接管理](#9-连接管理)
10. [消息发送](#10-消息发送)
11. [QoS 重传](#11-qos-重传)
12. [心跳](#12-心跳)
13. [高级特性](#13-高级特性)
14. [日志](#14-日志)
15. [网络监听](#15-网络监听)
16. [平台权限](#16-平台权限)
17. [完整示例](#17-完整示例)
18. [版本兼容](#18-版本兼容)
19. [常见问题](#19-常见问题)

---

## 1. 快速开始

```dart
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

void main() async {
  IMConfig.register(appKey: 'your-app-key');
  IMConfig.serverIp = '127.0.0.1';
  IMConfig.serverPort = 7901;
  IMConfig.senseMode = SenseMode.mode5S;
  IMConfig.debug = true;

  final IMClient client = IMFactory.create(ConnectionType.tcp);

  client.baseEvent = ChatBaseEvent(
    onLoginResponse: (int code) => print('login: $code'),
    onLinkClose: (int code) => print('closed: $code'),
  );
  client.messageEvent = ChatMessageEvent(
    onRecieveMessage: (fp, uid, content, type) {
      print('msg: $content from $uid');
    },
  );

  await client.initCore();
  await client.sendLogin(userId: 'u1', token: 't1');
  await client.sendText(fromUserId: 'u1', toUserId: 'u2', content: 'hello');
}
```

---

## 2. 核心类型

| 类型 | 说明 |
|------|------|
| `ConnectionType` | 传输类型枚举: `tcp` / `udp` / `websocket` |
| `IMMessage` | 一条 IM 消息（Protocal） |
| `IMClient` | 抽象客户端接口 |
| `IMFactory` | 客户端工厂 |
| `IMConfig` | 全局配置（静态类） |
| `ErrorCode` | 错误码常量 |
| `ChatBaseEvent` | 基础事件回调（登录/掉线/被踢/重连） |
| `ChatMessageEvent` | 消息事件回调（收消息/收错误） |
| `MessageQoSEvent` | QoS 事件（发送成功/失败/收到 ack/批量失败） |
| `SenseMode` | 心跳模式枚举 |
| `ProtocalFactory` | 协议对象创建与解析 |
| `PKickoutInfo` | 被踢下线信息 |
| `PLoginInfo` | 登录请求数据 |
| `PLoginInfoResponse` | 登录响应数据 |
| `PErrorResponse` | 服务端错误响应 |
| `NetworkMonitor` | 网络监听单例 |
| `FrameCodec` | TCP 帧编解码 |
| `ByteUtils` | UTF-8 编解码工具 |
| `IMLogger` | 分级日志工具 |

---

## 3. 配置: IMConfig

`IMConfig` 是静态类，**所有客户端实例共享同一份配置**。

### 静态属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `appKey` | `String` | `''` | 已注册的 AppKey |
| `serverIp` | `String` | `''` | 服务端 IP |
| `serverPort` | `int` | `0` | 服务端端口 |
| `localPort` | `int` | `0` | 本地发送/监听端口（0=系统分配） |
| `senseMode` | `SenseMode` | `mode5S` | 心跳敏感度 |
| `ssl` | `bool` | `false` | 是否启用 SSL/TLS（TCP） |
| `autoReconnect` | `bool` | `true` | 断线是否自动重连（指数退避 2/4/8...30s） |
| `debug` | `bool` | `false` | 是否输出 DEBUG 日志 |
| `connectTimeout` | `Duration` | `10s` | 连接超时 |
| `sendTimeout` | `Duration` | `10s` | 单次发送超时 |
| `firstLoginTime` | `int?` | `null` | 首次登录时间（毫秒时间戳） |

### 静态方法

```dart
static void register({required String appKey});  // 注册 AppKey
static void reset();                              // 重置全部配置
static bool get isRegistered;                     // 是否已注册
static int validate();                            // 校验配置，返回错误码（0 表示通过）
```

### 校验错误码

| 错误码 | 含义 |
|--------|------|
| `203` `clientSdkNoInitialed` | 尚未调用 `register` |
| `205` `toServerNetInfoNotSetup` | `serverIp`/`serverPort` 未设置 |

---

## 4. 错误码: ErrorCode

与 MobileIMSDK 原生 `ErrorCode.h` 对齐。

| 常量 | 值 | 含义 |
|------|----|------|
| `commonNoError` | 0 | 成功 |
| `commonUnknownError` | -1 | 未知错误 |
| `commonDataSendFailed` | -2 | 数据发送失败 |
| `commonInvalidProto` | -3 | 无效的协议 |
| `badConnectToServer` | -4 | 连接服务端失败 |
| `connectionTimeout` | -5 | 连接超时 |
| `brokenConnectToServer` | -6 | 与服务端的连接已断开 |
| `sendTimeout` | -7 | 发送超时 |
| `protocalParseFailed` | -8 | 协议解析失败 |
| `illegalArgument` | -9 | 非法参数 |
| `toServerNetInfoNotSetup` | 205 | 服务端 ip/port 未设置 |
| `clientSdkNoInitialed` | 203 | 尚未调用 register |

> 0 表示成功，负数为可恢复错误，正数为配置/状态错误。

---

## 5. 消息: IMMessage

`IMMessage` 与 MobileIMSDK 原生 `Protocal` 一一对应。

### 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `type` | `int` | 协议类型（见协议常量表） |
| `data` | `List<int>` | 消息体（二进制）；对于 type=2 业务消息,data 为结构化 JSON 的 UTF-8 编码,可通过 `utf8.decode()` 获取 `dataContent` 字符串 |
| `fingerprint` | `String?` | 消息指纹（QoS 去重/确认） |
| `fromUserId` | `String?` | 发送方 userId |
| `toUserId` | `String?` | 接收方 userId |
| `qos` | `bool` | 是否需要 QoS ack |
| `timestamp` | `int` | 毫秒时间戳 |

### 构造

```dart
IMMessage({
  required int type,
  required List<int> data,
  String? fingerprint,
  String? fromUserId,
  String? toUserId,
  bool qos = false,
  int? timestamp,
});

IMMessage.business({
  required String fromUserId,
  required String toUserId,
  required String content,
  bool qos = true,
  String? fingerprint,
});

IMMessage.businessBinary({
  required String fromUserId,
  required String toUserId,
  required List<int> bytes,
  bool qos = true,
  String? fingerprint,
});
```

### 方法

```dart
String get textData;       // data 解释为 UTF-8 字符串,返回 dataContent 完整 JSON；需按 type 字段解析具体消息内容
IMMessage clone();         // 深拷贝
```

### 协议类型常量

定义在 `IMMessageType`（`im_factory.dart`）中：

| 常量 | 值 | 含义 |
|------|----|------|
| `fromClientTypeLogin` | 0 | 客户端发起的登录请求 |
| `fromClientTypeCommonData` | 2 | 客户端发起的业务数据 |
| `fromClientTypeRecieved` | 4 | 客户端收到的 QoS ack（仅内部路由） |
| `fromServerTypeOfResponseLogin` | 50 | 服务端登录响应 |
| `fromServerTypeOfResponseKeepAlive` | 51 | 服务端心跳响应 |
| `fromServerTypeOfResponseForError` | 52 | 服务端错误响应 |
| `fromServerTypeOfResponseEcho` | 53 | 服务端回声响应 |
| `fromServerTypeOfKickout` | 54 | 服务端踢出通知 |

> **类型 4 仅路由到 QosDaemon.markAcked()**，不会出现在 `messageStream` 中。

---

## 6. 协议对象

### PKickoutInfo

```dart
class PKickoutInfo {
  final int code;      // 踢出原因码
  final String reason; // 踢出原因描述
}
```

### PLoginInfo

```dart
class PLoginInfo {
  final String userId;  // 用户 ID
  final String token;   // 登录令牌
  final String? extra;  // 附加数据
}
```

### PLoginInfoResponse

```dart
class PLoginInfoResponse {
  final int code;    // 登录结果码（0=成功）
  final int userId;  // 服务端分配/返回的 userId
}
```

### PErrorResponse

```dart
class PErrorResponse {
  final int errorCode;   // 错误码
  final String errorMsg; // 错误描述
}
```

### ProtocalFactory

```dart
// 协议对象创建
PLoginInfo createPLoginInfo({required String userId, required String token, String? extra});
PLoginInfoResponse parsePLoginInfoResponse(IMMessage msg);
PErrorResponse parsePErrorResponse(IMMessage msg);
PKickoutInfo parsePKickoutInfo(IMMessage msg);

// 协议消息创建
IMMessage createLoginMsg(PLoginInfo info);
IMMessage createKeepAliveMsg();
IMMessage createCommonDataMsg({
  required String from, required String to, required List<int> data, int type, bool qos, String? fp,
});
IMMessage createReceivedBackMsg(String from, String to, String fp, int typeOrigin);
IMMessage createEchoBackMsg(String from, String to, List<int> data);
```

---

## 7. 客户端接口: IMClient / IMFactory

### IMClient 公共方法

| 方法 | 返回 | 说明 |
|------|------|------|
| `initCore()` | `Future<int>` | 初始化底层资源（端口绑定/通道创建） |
| `connect()` | `Future<int>` | 建立连接 |
| `disconnect()` | `Future<void>` | 主动断开 |
| `releaseCore()` | `Future<void>` | 释放全部资源（不可逆） |
| `sendLogin({userId, token})` | `Future<int>` | 发送登录消息 |
| `sendLogout()` | `Future<int>` | 发送登出消息 |
| `sendKeepAlive()` | `Future<int>` | 发送心跳 |
| `sendText({fromUserId, toUserId, content, qos, fp})` | `Future<int>` | 发送文本业务消息 |
| `sendBytes({fromUserId, toUserId, bytes, qos, fp})` | `Future<int>` | 发送二进制业务消息 |
| `sendEcho({fromUserId, toUserId, content, qos, fp})` | `Future<int>` | 发送回声消息（服务端原样返回） |
| `sendMessage(IMMessage msg)` | `Future<int>` | 底层：发送原始消息 |

### IMClient 公共属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `state` | `ConnectionState` | 当前连接状态 |
| `isConnected` | `bool` | 是否已建立底层连接 |
| `isLogined` | `bool` | 是否已登录（连接 + 鉴权通过） |
| `messageStream` | `Stream<IMMessage>` | 收到的业务消息流 |
| `errorStream` | `Stream<int>` | 错误码事件流 |
| `baseEvent` (set) | `ChatBaseEvent?` | 基础事件回调 |
| `messageEvent` (set) | `ChatMessageEvent?` | 消息事件回调 |
| `qosEvent` (set) | `MessageQoSEvent?` | QoS 事件回调 |

### 状态机: ConnectionState

```
idle -> connecting -> connected -> logining -> logged
                               ↓
                          disconnecting -> disconnected
```

### IMFactory

```dart
static IMClient create([ConnectionType type = ConnectionType.tcp]);  // 同步，非 async
```

`create` 内部调用 `IMConfig.validate()`，失败时抛出 `IMConfigException(code)`。

### 各传输特有方法

#### UdpImClient

```dart
Future<int> sendTo({required IMMessage msg, required String host, required int port});
Future<int> sendBroadcast(IMMessage msg, {int? port});
void joinMulticast(String group);
void leaveMulticast(String group);
```

---

## 8. 事件回调

### ChatBaseEvent

```dart
const ChatBaseEvent({
  void Function(int errorCode)? onLoginResponse,
  void Function(int errorCode)? onLinkClose,
  void Function(PKickoutInfo ki)? onKickout,
  void Function(int attempt, int maxAttempts)? onReconnecting,
});
```

### ChatMessageEvent

```dart
const ChatMessageEvent({
  void Function(String fp, String userId, String content, int type)? onRecieveMessage,
  void Function(int code, String msg)? onErrorResponse,
  void Function(String fp, String userId, List<int> data, int type)? onRecieveMessageBytes,
});
```

### MessageQoSEvent

```dart
const MessageQoSEvent({
  void Function(String fingerprint)? onSendSuccess,
  void Function(String fingerprint, int errorCode)? onSendFailed,
  void Function(String fingerprint)? onAckReceived,
  void Function(List<String> fingerprints, int errorCode)? onMessagesLost,
});
```

---

## 9. 连接管理

### 完整生命周期

```dart
final IMClient c = IMFactory.create(ConnectionType.tcp);
c.baseEvent = ChatBaseEvent(onLoginResponse: (code) {});
await c.initCore();
await c.sendLogin(userId: 'u1', token: 't1');
await c.disconnect();
await c.releaseCore();
```

### 异常与重连

- `autoReconnect = true` 时，断线后指数退避重连（2s/4s/8s...30s 上限）
- `ChatBaseEvent.onReconnecting(attempt, maxAttempts)` 用于 UI 提示
- 重连成功后自动用缓存凭据调用 `sendLogin`
- UDP 不进入已登录状态，`isLogined` 永远为 `false`

### 状态查看

```dart
c.state;            // 当前 ConnectionState
c.isConnected;      // 是否已建链
c.isLogined;        // 鉴权是否通过
c.messageStream;    // 业务消息流
c.errorStream;      // 错误流
```

---

## 10. 消息发送

```dart
// 文本（content 为结构化 JSON 字符串）
await c.sendText(fromUserId: 'u1', toUserId: 'u2', content: '{"type":"text","content":"hi"}', qos: true);

// 二进制
await c.sendBytes(fromUserId: 'u1', toUserId: 'u2', bytes: [0x01, 0x02], qos: true);

// 回声
await c.sendEcho(fromUserId: 'u1', toUserId: 'u2', content: 'ping');

// 原始
await c.sendMessage(IMMessage(type: 2, data: utf8.encode('custom'), fromUserId: 'u1', toUserId: 'u2'));
```

### 接收

```dart
final sub = c.messageStream.listen((IMMessage m) {
  print('from=${m.fromUserId} text=${m.textData}');
});
sub.cancel();
```

---

## 11. QoS 重传

`qos = true` 时：

- 发送端启动 3 秒容限期，未收到 ack 则按指数退避重传（3s/6s/12s/24s）
- 接收端 TTL 10 分钟时间驱动清理
- 最终通过 `MessageQoSEvent.onSendSuccess` / `onSendFailed` 通知业务层
- `onMessagesLost(List<String> fingerprints, int errorCode)` 批量回调发送失败的消息

---

## 12. 心跳

`connected` 状态后按 `SenseMode` 周期发送心跳。超时未收到心跳响应视为链路断开，触发重连。

| SenseMode | 心跳间隔 | 超时 |
|-----------|----------|------|
| `mode5S` | 5 秒 | 15 秒 |
| `mode15S` | 15 秒 | 45 秒 |
| `mode30S` | 30 秒 | 90 秒 |
| `mode60S` | 60 秒 | 180 秒 |
| `mode120S` | 120 秒 | 360 秒 |

---

## 13. 高级特性

### UDP 广播

```dart
final UdpImClient u = IMFactory.create(ConnectionType.udp) as UdpImClient;
await u.initCore();
await u.sendBroadcast(IMMessage.business(fromUserId: 'u1', toUserId: '*', content: 'hello'));
```

### UDP 组播

```dart
u.joinMulticast('224.0.0.1');
u.leaveMulticast('224.0.0.1');
```

> Windows 无组播路由时返回 `OSError 10065`，SDK 已降级为 warning。

### 切换传输层

```dart
await clientA.releaseCore();
final clientB = IMFactory.create(ConnectionType.websocket);
await clientB.initCore();
```

---

## 14. 日志

```dart
IMLogger.d('Tag', 'debug message');
IMLogger.i('Tag', 'info message');
IMLogger.w('Tag', 'warn message');
IMLogger.e('Tag', 'error message', error, stackTrace);
```

- `IMConfig.debug = true` 时输出 DEBUG 级别；否则只输出 INFO/WARN/ERROR
- 所有日志输出到 `flutter`/`dart:io` 标准输出

### 自定义

```dart
IMLogger.print = (String line) {
  // 自定义转发
};
```

---

## 15. 网络监听

`NetworkMonitor` 为单例，封装 `connectivity_plus`：

```dart
NetworkMonitor.instance.start();
NetworkMonitor.instance.addListener(callback);
NetworkMonitor.instance.removeListener(callback);
NetworkMonitor.instance.stop();
```

通常通过 `NetworkMonitorMixin` 混入到传输客户端，无需直接使用。

> 测试环境中若无 `WidgetsFlutterBinding`，`NetworkMonitor` 会静默跳过。

---

## 16. 平台权限

详见 [PLATFORMS.md](./PLATFORMS.md)。

| 平台 | 关键要求 |
|------|----------|
| Android | `INTERNET`、`ACCESS_NETWORK_STATE`、组播锁 |
| iOS | `NSAppTransportSecurity` 配置 |
| macOS | 网络沙箱权限 |
| Windows | 防火墙放行 |
| Linux | 无特殊要求 |
| Web | 仅 WebSocket，无 TCP/UDP |

---

## 17. 完整示例

参考 [example/](./example/) 目录：

- `home_page.dart` — 主页（连接方式选择）
- `tcp_page.dart` — TCP 演示
- `udp_page.dart` — UDP 演示
- `websocket_page.dart` — WebSocket 演示
- `widgets/log_console.dart` — 实时日志面板

运行：

```bash
cd example
flutter pub get
flutter run
```

---

## 18. 版本兼容

| Dart SDK | Flutter |
|----------|---------|
| >= 2.17.0 < 4.0.0 | >= 3.0.0 |

---

## 19. 常见问题

**Q: 收到 `badConnectToServer` 错误？**  
A: 检查 `IMConfig.serverIp`/`serverPort` 是否正确，服务端是否启动，防火墙是否放行。

**Q: `initCore()` 返回非 0？**  
A: 通常是端口被占用，尝试 `IMConfig.localPort = 0`（系统分配）。

**Q: WebSocket 一直连接不上？**  
A: 确认 URL 使用 `ws://` 或 `wss://` 协议前缀和正确的路径。

**Q: 心跳日志过于频繁？**  
A: 把 `SenseMode` 调到 `mode30S` 或更高。
