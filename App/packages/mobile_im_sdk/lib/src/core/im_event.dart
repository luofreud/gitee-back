import 'im_message.dart';
import 'p_kickout_info.dart';

/// 基础事件回调(对齐 MobileIMSDK `ChatBaseEvent`).
///
/// 涵盖登录响应、连接关闭、被踢下线三类与连接生命周期强相关的事件.
class ChatBaseEvent {
  /// 登录响应回调.
  ///
  /// [errorCode] 为 0 表示登录成功,其余值参考 [ErrorCode].
  final void Function(int errorCode)? onLoginResponse;

  /// 连接关闭回调.
  ///
  /// 通常是 [ErrorCode.brokenConnectToServer] / 网络异常.
  final void Function(int errorCode)? onLinkClose;

  /// 被踢下线回调(带结构化信息).
  ///
  /// [info.code] 含义: 1=重复登录, 2=管理员踢.
  final void Function(PKickoutInfo kickoutInfo)? onKickout;

  /// 被踢下线回调(仅文本,已废弃,请使用 [onKickout]).
  @Deprecated('Use onKickout(PKickoutInfo) instead')
  final void Function(String reason)? onKickoutLegacy;

  /// 重连尝试回调(用于 UI 展示).
  final void Function(int attempt, int maxAttempts)? onReconnecting;

  const ChatBaseEvent({
    this.onLoginResponse,
    this.onLinkClose,
    this.onKickout,
    this.onKickoutLegacy,
    this.onReconnecting,
  });
}

/// 消息事件回调(对齐 MobileIMSDK `ChatMessageEvent`).
class ChatMessageEvent {
  /// 收到消息回调.
  ///
  /// - [fingerPrintOfProtocal] 消息指纹
  /// - [userId] 发送方 userId
  /// - [dataContent] 文本内容
  /// - [typeu] 协议类型
  final void Function(
    String fingerPrintOfProtocal,
    String userId,
    String dataContent,
    int typeu,
  )? onRecieveMessage;

  /// 服务端返回的错误.
  final void Function(int errorCode, String errorMsg)? onErrorResponse;

  /// 收到消息二进制版本(便于二进制业务;若服务端只发文本可仅实现 [onRecieveMessage]).
  final void Function(
    String fingerPrintOfProtocal,
    String userId,
    List<int> data,
    int typeu,
  )? onRecieveMessageBytes;

  const ChatMessageEvent({
    this.onRecieveMessage,
    this.onErrorResponse,
    this.onRecieveMessageBytes,
  });
}

/// 消息 QoS 事件(对齐 MobileIMSDK `MessageQoSEvent`).
class MessageQoSEvent {
  /// 消息成功送达(对方已 ack).
  final void Function(String fingerPrint)? onSendSuccess;

  /// 消息发送失败(超过重试次数,单条).
  final void Function(String fingerPrint, int errorCode)? onSendFailed;

  /// 批量消息发送失败(超过重试次数,对应原生 [messagesLost]).
  final void Function(List<String> fingerprints, int errorCode)? onMessagesLost;

  /// 收到对端的 ack 响应.
  final void Function(String fingerPrint)? onAckReceived;

  const MessageQoSEvent({
    this.onSendSuccess,
    this.onSendFailed,
    this.onMessagesLost,
    this.onAckReceived,
  });
}

/// 状态变更事件.
class ConnectionStateEvent {
  final void Function(String from, String to, IMMessage? lastMessage)?
      onStateChanged;

  const ConnectionStateEvent({this.onStateChanged});
}
