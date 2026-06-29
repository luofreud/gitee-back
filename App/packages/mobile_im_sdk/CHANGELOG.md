# Changelog

## [1.0.0] - 2026-06-13

### 新架构

- **DispatchCenter 消息路由** — 消除约 240 行 TCP/UDP/WebSocket 间的重复分发逻辑；按消息类型（登录/心跳/ACK/错误/回声/踢出/业务数据）统一路由
- **DispatchDelegate 桥接接口** — 连接 DispatchCenter 与各传输客户端，提供消息队列、QoS 触发、ACK 发送等能力
- **ProtocalFactory 协议工厂** — 统一解析/创建所有协议对象（PLoginInfo、PLoginInfoResponse、PErrorResponse、PKickoutInfo）
- **NetworkMonitor 网络监听单例** — 基于 `connectivity_plus`，通过 `ServicesBinding.instance` 守卫测试环境
- **NetworkMonitorMixin** — 可复用的网络状态 mixin，各传输客户端直接混入

### 传输层

- **TCP** (`TcpImClient`) — 重写为 `with NetworkMonitorMixin implements IMClient, QosTransport, DispatchDelegate`；集成 DispatchCenter、ProtocalFactory、心跳超时检测、自动重连
- **UDP** (`UdpImClient`) — 同上；新增 `_scheduleReconnect()` 自动重连（此前缺失）；支持单播/广播/组播
- **WebSocket** (`WebSocketImClient`) — 同上；基于 `web_socket_channel` 实现
- **FrameCodec** — TCP 粘包拆包解码器

### QoS 重传

- **QosDaemon 重写** — 发送端 3 秒容限 + 指数退避（3s/6s/12s/24s）；接收端 10 分钟 TTL 时间驱动清理
- **MessageQoSEvent.onMessagesLost** — 批量回调发送失败的消息指纹列表

### 领域模型

- **PKickoutInfo** — 被踢下线信息（code + reason 字段）
- **PLoginInfo** — 登录请求数据模型
- **PLoginInfoResponse** — 登录响应数据模型
- **PErrorResponse** — 服务端错误响应数据模型
- **IMMessage.clone()** — 消息克隆方法
- **IMClient.sendEcho()** — 回声消息发送
- **ChatBaseEvent.onKickout** — 回调参数从 `String reason` 改为 `PKickoutInfo`
- **SenseMode.timeoutMillis** — 心跳超时毫秒映射

### 平台支持

- **macOS/Windows/Linux 桩代码** — 新增 3 个平台的空插件注册类
- **Web 条件导出** — `mobile_im_sdk.dart` 使用 `export ... if (dart.library.io)` 实现 Web 平台安全编译
- **Web 桩** — `MobileImSdkWeb` 平台注册类
- **所有平台桩简化** — 清理无用的 Android/iOS 非空断言和泛型约束

### 配置

- **IMConfig.firstLoginTime** — 首次登录时间属性

### 测试

- **60 个测试** — 单元测试 54 个 + 跨组件集成测试 6 个
  - core/ — ErrorCode / IMConfig / IMFactory / IMMessage 领域对象
  - transport/ — FrameCodec / TCP / UDP / WebSocket 传输层
  - utils/ — ByteUtils / Fingerprint 工具
  - integration/ — 跨组件集成测试
- **NetworkMonitor 测试兼容** — 添加 `ServicesBinding.instance` 守卫，测试环境无 Flutter binding 时静默跳过

### Example

- **TCP/UDP/WebSocket 三页演示** — 完整 UI 操作示例
- **实时日志面板** — 滚动日志输出组件
- **修复 onKickout 回调签名** — 适配 PKickoutInfo 参数

### 依赖

- 新增 `web_socket_channel: ^2.4.0`
- 新增 `connectivity_plus: ^6.0.0`

### 开发者

- `flutter analyze lib/` 零错误零警告
- `flutter test` 全部通过
- Example Android APK (`flutter build apk --debug`) 编译通过
