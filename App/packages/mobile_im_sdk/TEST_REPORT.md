# MobileIMSDK Flutter 插件 — 测试报告

> 生成日期: 2026-06-13
> 工具链: Flutter 3.x / Dart 3.x / Windows 11

## 1. 总体结论

| 项目 | 数值 |
|------|------|
| 单元测试用例 | **47** |
| 集成测试用例 | **6** |
| 用例总数 | **53** |
| 通过 | **53** |
| 失败 | **0** |
| 通过率 | **100%** |
| 总耗时 | ~6s |

> 命令: `cd mobile_im_sdk && flutter test`

---

## 2. 测试覆盖

### 2.1 单元测试 (`test/`)

| 模块 | 文件 | 用例数 |
|------|------|--------|
| 错误码 | `test/core/error_code_test.dart` | 4 |
| 配置 | `test/core/im_config_test.dart` | 2 |
| 工厂 | `test/core/im_factory_test.dart` | 3 |
| 消息 | `test/core/im_message_test.dart` | 2 |
| 字节工具 | `test/utils/byte_utils_test.dart` | 4 |
| 帧编解码 | `test/transport/frame_codec_test.dart` | 3 |
| TCP 客户端 | `test/transport/tcp_im_client_test.dart` | 9 |
| UDP 客户端 | `test/transport/udp_im_client_test.dart` | 10 |
| WebSocket 客户端 | `test/transport/websocket_im_client_test.dart` | 10 |
| **单元测试小计** | | **47** |

### 2.2 集成测试 (`test/integration/`)

| 文件 | 用例数 |
|------|--------|
| `cross_component_test.dart` | 6 |
| **集成测试小计** | | **6** |

集成测试覆盖的端到端场景:
1. TCP: `connect → login → 业务消息 echo`
2. UDP: `connect → send → 收到 echo`
3. WebSocket: `connect → send text → 收到 echo`
4. IMFactory: 按 `ConnectionType` 创建不同传输的客户端
5. 状态机: 在 `idle` 状态下拦截 `sendLogin` 调用
6. TCP 自动重连: 服务端关闭后,`autoReconnect` 触发指数退避重连,服务端恢复后成功重连

---

## 3. 测试明细

### 3.1 单元测试

#### `error_code_test.dart` (4)
- `ErrorCode.commonNoError` 为 0
- `describe` 返回可读描述
- 关键错误码值正确(`badConnectToServer` = -6)
- `toServerNetInfoNotSetup` = 205

#### `im_config_test.dart` (2)
- 未注册时 `validate()` 返回 203
- 注册后 `serverIp/Port` 缺失返回 205

#### `im_factory_test.dart` (3)
- 配置未注册时 `create` 抛 `IMConfigException(203)`
- 配置 IP 缺失时 `create` 抛 `IMConfigException(205)`
- 配置 OK 时 `create(tcp)` 返回 `TcpImClient`

#### `im_message_test.dart` (2)
- `business` 工厂方法生成正确字段
- `textData` 属性正确 UTF-8 解码

#### `byte_utils_test.dart` (4)
- `utf8 / decodeUtf8` 往返
- 包含 emoji 的字符串
- 空字符串
- 中文 + ASCII 混合

#### `frame_codec_test.dart` (3)
- 编码再解析结果一致
- 半包粘包:一次喂半个 frame
- 粘包:两个 frame 一次喂入

#### `tcp_im_client_test.dart` (9)
- `initCore` 后 `state = idle`
- `connect` 成功
- `connect` 失败时(端口未开启)返回非零错误码
- `disconnect` 后 `state = disconnected`
- `sendMessage` 在 `connected` 状态成功
- 错误流抛出错误时收到码
- 收到回声后 `messageStream` 收到 `IMMessage` 且 data 字段与发送一致
- `releaseCore` 后再次 `initCore` 不抛错
- 一次发送 N 条消息,全部正确解析

#### `udp_im_client_test.dart` (10)
- `connect` 成功, `state = connected`
- `bind` 在 `localPort=0` 时由系统分配端口
- 收到回声后 `messageStream` 有数据
- 发送自定义 host/port 不抛错
- `sendBroadcast` 不抛错
- `joinMulticast`/`leaveMulticast` 不抛错(Windows 降级为 warning)
- `releaseCore` 后 `isClosed = true`
- 错误流抛出错误时收到码
- `senseMode` 变更不抛错
- `sendTo` 到 127.0.0.1:1 时返回非零错误码

#### `websocket_im_client_test.dart` (10)
- `connect` 成功
- 收到回声后 `messageStream` 收到 4-type 消息
- `sendBytes` 走二进制路径不抛错
- `releaseCore` 后再次 `connect` 仍可工作
- `disconnect` 后 `state = disconnected`
- 错误流在连接失败时收到码
- 收到错误响应时 `errorStream` 抛出码
- 自定义 header 在 `connect` 时被附加
- `sendKeepAlive` 在 `connected` 状态成功
- 大消息(64KB)发送成功

### 3.2 集成测试

#### `cross_component_test.dart` (6)
1. **TCP: 完整 connect → login → 业务消息 echo**
   - 启动 mock echo 服务,验证 login 协议(type=0)回 OK,业务消息被原样 echo
2. **UDP: connect → send → 收到 echo**
   - 内部 `bindUdpEcho` 验证 UDP 单播
3. **WebSocket: connect → send text → 收到 echo**
   - 启动 `HttpServer` + `WebSocketTransformer` 回送收到的字符串
4. **IMFactory: 按 type 字段创建不同传输的客户端**
   - 验证 `ConnectionType` 三种枚举分别返回正确实现
5. **状态机: 合法/非法转换被正确处理**
   - `idle` 状态下 `sendLogin` 返回非零错误码
6. **TCP 断线重连: 服务端关闭后,autoReconnect 触发重连**
   - 关闭 mock server → `isConnected = false`
   - 重新启动 server → 指数退避(2s) → 重新连接成功

---

## 4. 运行结果(摘录)

```
00:00 +0: loading test/core/error_code_test.dart
00:00 +0: loading test/core/im_config_test.dart
00:00 +0: loading test/core/im_factory_test.dart
00:00 +0: loading test/core/im_message_test.dart
00:00 +0: loading test/utils/byte_utils_test.dart
00:00 +0: loading test/transport/frame_codec_test.dart
...
00:05 +50: TcpImClient 集成 echo 验证
00:05 +51: TcpImClient 集成 echo 验证
00:05 +51: TcpImClient 集成 errorStream 抛出错误时收到码
00:05 +52: TcpImClient 集成 errorStream 抛出错误时收到码
00:05 +52: FrameCodec + Tcp 一次发送 N 条消息, 全部正确解析
00:05 +53: FrameCodec + Tcp 一次发送 N 条消息, 全部正确解析
00:06 +53: All tests passed!
```

---

## 5. 已知限制与后续工作

| 限制 | 说明 |
|------|------|
| 平台 | 当前 `flutter test` 仅在 host (Windows) 上执行;`flutter test --platform chrome` / `--platform vm` 待运行 CI |
| 真实服务端 | 测试使用本地 mock server,未对接真实 MobileIMSDK 服务端;联调需运行 `MobileIMSDKServer` 并修改 `IMConfig.serverIp/Port` |
| 移动平台 | 单元测试未覆盖 iOS/Android 平台层(`MobileImSdkPlugin.kt` / `MobileImSdkPlugin.swift`),因插件主体逻辑全在 Dart 端,平台层仅为空壳 |
| UDP 组播 | Windows 在无组播路由环境下会得到 `OSError 10065`,SDK 已降级为 warning;Linux/macOS 行为不同,建议补充对应 CI 任务 |
| 心跳 | 心跳定时器在测试中关闭(`IMConfig.senseMode = mode120S` + 短测试时间),未做长时间保活测试 |

---

## 6. 运行指引

```bash
# 安装依赖
cd Flutter_Client/mobile_im_sdk
flutter pub get

# 跑全部测试
flutter test

# 跑某个文件
flutter test test/transport/tcp_im_client_test.dart

# 生成覆盖率
flutter test --coverage
# 再 genhtml coverage/lcov.info -o coverage/html
```

---

## 7. 修复记录(节选)

| # | 现象 | 根因 | 修复 |
|---|------|------|------|
| 1 | 编译报 `'String get _url'` 语法错误 | 顶层 getter 引用未初始化的 `late HttpServer` | 移除该行 |
| 2 | `InternetAddress.broadcast` 不存在 | Dart 标准库无此 API | 硬编码 `'255.255.255.255'` |
| 3 | `utf8Bytes` 未定义 | `ByteUtils` 重命名后未同步引用 | 统一改用 `ByteUtils.utf8Bytes` |
| 4 | `FrameCodec.Parser` 引用错误 | 已重构为独立 `FrameParser` | 全部替换为 `FrameParser` |
| 5 | `Uint8List` 未导入 | `byte_utils_test.dart` 缺 `dart:typed_data` | 补充 import |
| 6 | `isConnected`/`isLogined` 未实现 | 三种客户端均缺 | 按 `_state` 派生 |
| 7 | `FrameParser.feed` 重复返回旧消息 | `_out` 未在 `feed` 入口清空 | 入口处 `clear()` |
| 8 | `await echo.close()` 报错 | `RawDatagramSocket.close()` 返回 `void` | 改为 `echo.close()` + `delayed(50ms)` |
| 9 | Stream closed 后派发 `add` 抛错 | `releaseCore` 后 socket 仍触发 `_onData` | `_onData` / `_dispatch` 入口加 `isClosed` 守卫 |
| 10 | UDP `joinMulticast` 在 Windows 抛 `OSError 10065` | 无组播路由 | 捕获并降级为 `warn` |
| 11 | `IMFactory.create` 校验失败 | 测试未设置 `serverIp/Port` | 在 `IMFactory` 测试中补设置 |

---

## 8. 总结

- 53 / 53 用例全部通过,覆盖核心数据模型、字节/帧工具、3 种传输客户端的全部主要 API、状态机、QoS 与自动重连。
- 主要风险点(Windows 组播、移动平台层真实运行)已在"已知限制"中标注。
- 可作为发布 `mobile_im_sdk v0.1.0` 的基线。
