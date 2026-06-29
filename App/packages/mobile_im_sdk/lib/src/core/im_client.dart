import 'connection_type.dart';
import 'im_event.dart';
import 'im_message.dart';
import 'user_type_u.dart';

/// 统一的 IM 客户端抽象接口(对应 MobileIMSDK `ClientCoreSDK`).
///
/// 三种传输(TCP / UDP / WebSocket)共享此接口,业务层无需关心底层实现.
abstract class IMClient {
  /// 当前传输类型(只读).
  ConnectionType get connectionType;

  /// 当前连接状态.
  ConnectionState get state;

  /// 状态变更流(广播给所有订阅者).
  Stream<ConnectionState> get stateStream;

  /// 收到的消息流(被动接收).
  Stream<IMMessage> get messageStream;

  /// 错误流.
  Stream<int> get errorStream;

  /// 当前登录 userId(已登录时).
  String? get currentLoginUserId;

  /// 是否已连接.
  bool get isConnected => state == ConnectionState.connected ||
      state == ConnectionState.logged ||
      state == ConnectionState.logining;

  /// 是否已登录.
  bool get isLogined => state == ConnectionState.logged;

  // region ===== 事件回调 =====

  /// 基础事件(登录/断线/被踢).
  set baseEvent(ChatBaseEvent? event);

  ChatBaseEvent? get baseEvent;

  /// 消息事件(收消息/错误响应).
  set messageEvent(ChatMessageEvent? event);

  ChatMessageEvent? get messageEvent;

  /// QoS 事件(已送达/失败/收到 ack).
  set qosEvent(MessageQoSEvent? event);

  MessageQoSEvent? get qosEvent;

  // endregion

  // region ===== 生命周期 =====

  /// 初始化 SDK,准备底层资源(对应 `initCore`).
  ///
  /// 必须在 [sendLogin] 之前调用.
  Future<void> initCore();

  /// 释放资源(对应 `releaseCore`).
  Future<void> releaseCore();

  // endregion

  // region ===== 连接控制 =====

  /// 建立到服务端的连接(对应 MobileIMSDK 内部"连接"步骤).
  ///
  /// - 返回 0 表示成功
  /// - 返回非 0 错误码参考 [ErrorCode]
  Future<int> connect();

  /// 断开连接.
  Future<void> disconnect();

  /// 发送登录请求,userId/token 交由服务端校验.
  Future<int> sendLogin({required String userId, required String token});

  /// 发送登出请求.
  Future<int> sendLogout();

  // endregion

  // region ===== 消息收发 =====

  /// 发送一条 IM 消息.
  ///
  /// - 返回 0 表示成功放入发送队列
  /// - 返回 [ErrorCode.commonNoLogin] 等非 0 表示失败
  ///
  /// 若 [msg].qos == true,SDK 内部会等待 ack,失败时触发 [MessageQoSEvent.onSendFailed].
  Future<int> sendMessage(IMMessage msg);

  /// 发送文本消息便捷方法.
  Future<int> sendText({
    required String fromUserId,
    required String toUserId,
    required String content,
    bool qos = true,
    UserTypeU typeu = UserTypeU.privateMessage,
    String? fingerprint,
  });

  /// 发送二进制消息便捷方法.
  Future<int> sendBytes({
    required String fromUserId,
    required String toUserId,
    required List<int> bytes,
    bool qos = true,
    UserTypeU typeu = UserTypeU.privateMessage,
    String? fingerprint,
  });

  /// 向 QoS 服务确认一条已收到的消息(返回 ack).
  ///
  /// 对应 MobileIMSDK `MessageQoSEvent.onMessagesLost` 反向逻辑.
  void ackMessage(String fingerprint);

  /// 发送 echo 测试消息(对应 MobileIMSDK type=5/53).
  Future<int> sendEcho({required String content});

  // endregion
}
