import 'dart:async';
import 'dart:convert';

import 'package:freud/api/im/im_message.dart';
import 'package:freud/models/user/userinfo.dart';
import 'package:freud/pages/message/chat/chat_controller.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/service/notification_service.dart';
import 'package:get/get.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

class ImService extends GetxService {
  // IM 客户端实例
  IMClient? _client;

  // 当前连接的服务器地址
  String? _serverIp;
  int? _serverPort;

  // 是否已初始化
  bool get isInitialized => _client != null;

  // 当前服务器 IP
  String? get serverIp => _serverIp;

  // 当前服务器端口
  int? get serverPort => _serverPort;

  //连接状态
  final Rx<ConnectionState> connectionState = ConnectionState.idle.obs;

  //收到的消息列表
  final RxList<IMMessage> messages = RxList<IMMessage>();

  //错误码
  final RxInt errorCode = 0.obs;

  //当前登录用户 ID
  String? currentUserId;

  //用户信息缓存 uid -> Userinfo（仅本次 app 生命周期内有效）
  final Map<String, Userinfo> _userInfoCache = {};

  /// 是否正在语音通话页面（用于防止重复来电跳转）
  bool _isCallPageActive = false;

  // 消息广播控制器，外部通过 onNewMessage 订阅新消息
  StreamController<IMMessage> _msgController = StreamController<IMMessage>.broadcast();

  /// 新消息事件流，外部监听此流即可接收 IM 消息
  Stream<IMMessage> get onNewMessage => _msgController.stream;

  ///
  /// 初始化 IM SDK
  /// [serverIp] 服务端 IP
  /// [serverPort] 服务端端口
  /// [type] 连接类型（默认 TCP）
  Future<void> init({
    required String serverIp,
    required int serverPort,
    ConnectionType type = ConnectionType.tcp,
  }) async {
    IMConfig.reset();
    IMConfig.register(appKey: 'freud-app');
    IMConfig.serverIp = serverIp;
    IMConfig.serverPort = serverPort;
    IMConfig.senseMode = SenseMode.mode5S;
    IMConfig.autoReconnect = true;
    IMConfig.debug = true;

    await _client?.releaseCore();
    _client = IMFactory.create(type);
    _serverIp = serverIp;
    _serverPort = serverPort;

    if (_msgController.isClosed) {
      _msgController = StreamController<IMMessage>.broadcast();
    }

    _client!.stateStream.listen((state) {
      connectionState.value = state;
    });

    _client!.messageStream.listen((msg) async {
      if (msg.type == IMMessageType.fromServerTypeOfResponseEcho) return;
      messages.add(msg);
      _msgController.add(msg);
      if (!_isVoiceCallMessage(msg.textData)) {
        await _checkShowNotification(msg);
      }
      _checkIncomingCall(msg);
    });

    _client!.errorStream.listen((code) {
      errorCode.value = code;
    });

    _client!.baseEvent = ChatBaseEvent(
      onLoginResponse: (code) {},
      onKickout: (info) {
        connectionState.value = ConnectionState.kicked;
      },
    );

    _client!.qosEvent = MessageQoSEvent(onAckReceived: (fp) {});

    await _client!.initCore();
  }

  ///
  /// 建立连接并登录
  /// [userId] 用户 ID
  /// [token] 登录凭证 JWT
  /// 返回 0 表示成功，非 0 为错误码
  Future<int> connectAndLogin({
    required String userId,
    required String token,
  }) async {
    currentUserId = userId;
    final rc = await _client!.connect();
    if (rc != 0) return rc;
    return await _client!.sendLogin(userId: userId, token: token);
  }

  ///
  /// 发送原始 JSON 消息
  /// [content] 原始 JSON 字符串
  /// [typeu] 业务子类型（默认单聊）
  Future<int> sendText({
    required String fromUserId,
    required String toUserId,
    required String content,
    bool qos = true,
    UserTypeU typeu = UserTypeU.privateMessage,
    String? fingerprint,
  }) async {
    return await _client!.sendText(
      fromUserId: fromUserId,
      toUserId: toUserId,
      content: content,
      qos: qos,
      typeu: typeu,
      fingerprint: fingerprint,
    );
  }

  ///
  /// 发送文本消息
  /// [content] 文本内容
  /// [subtype] 可选子类型
  Future<int> sendTextMessage({
    required String fromUserId,
    required String toUserId,
    required String content,
    String? subtype,
    bool qos = true,
    String? fingerprint,
  }) async {
    final data = <String, dynamic>{'type': 'text', 'content': content};
    if (subtype != null) data['subtype'] = subtype;
    return await sendText(
      fromUserId: fromUserId,
      toUserId: toUserId,
      content: jsonEncode(data),
      qos: qos,
      fingerprint: fingerprint,
    );
  }

  ///
  /// 发送图片消息
  /// [fileId] 文件 ID
  /// [url] 图片地址
  /// [thumbnailUrl] 缩略图地址（可选）
  /// [width] 图片宽度（可选）
  /// [height] 图片高度（可选）
  /// [size] 文件大小（可选）
  /// [format] 图片格式（可选，如 jpg/png）
  Future<int> sendImageMessage({
    required String fromUserId,
    required String toUserId,
    required String fileId,
    required String url,
    String? thumbnailUrl,
    int? width,
    int? height,
    int? size,
    String? format,
    bool qos = true,
    String? fingerprint,
  }) async {
    final data = <String, dynamic>{
      'type': 'image',
      'file_id': fileId,
      'url': url,
    };
    if (thumbnailUrl != null) data['thumbnail_url'] = thumbnailUrl;
    if (width != null) data['width'] = width;
    if (height != null) data['height'] = height;
    if (size != null) data['size'] = size;
    if (format != null) data['format'] = format;
    return await sendText(
      fromUserId: fromUserId,
      toUserId: toUserId,
      content: jsonEncode(data),
      qos: qos,
      fingerprint: fingerprint,
    );
  }

  ///
  /// 发送文件消息
  /// [fileId] 文件 ID
  /// [url] 文件地址
  /// [name] 文件名
  /// [size] 文件大小（可选）
  /// [ext] 文件扩展名（可选，如 pdf/doc）
  Future<int> sendFileMessage({
    required String fromUserId,
    required String toUserId,
    required String fileId,
    required String url,
    required String name,
    int? size,
    String? ext,
    bool qos = true,
    String? fingerprint,
  }) async {
    final data = <String, dynamic>{
      'type': 'file',
      'file_id': fileId,
      'url': url,
      'name': name,
    };
    if (size != null) data['size'] = size;
    if (ext != null) data['ext'] = ext;
    return await sendText(
      fromUserId: fromUserId,
      toUserId: toUserId,
      content: jsonEncode(data),
      qos: qos,
      fingerprint: fingerprint,
    );
  }

  ///
  /// 发送语音消息
  /// [fileId] 文件 ID
  /// [url] 语音文件地址
  /// [duration] 语音时长（秒，可选）
  /// [size] 文件大小（可选）
  /// [format] 音频格式（可选，如 amr/mp3）
  Future<int> sendAudioMessage({
    required String fromUserId,
    required String toUserId,
    required String fileId,
    required String url,
    int? duration,
    int? size,
    String? format,
    bool qos = true,
    String? fingerprint,
  }) async {
    final data = <String, dynamic>{
      'type': 'audio',
      'file_id': fileId,
      'url': url,
    };
    if (duration != null) data['duration'] = duration;
    if (size != null) data['size'] = size;
    if (format != null) data['format'] = format;
    return await sendText(
      fromUserId: fromUserId,
      toUserId: toUserId,
      content: jsonEncode(data),
      qos: qos,
      fingerprint: fingerprint,
    );
  }

  ///
  /// 发送视频消息
  /// [fileId] 文件 ID
  /// [url] 视频地址
  /// [coverUrl] 视频封面地址（可选）
  /// [duration] 视频时长（秒，可选）
  /// [size] 文件大小（可选）
  /// [width] 视频宽度（可选）
  /// [height] 视频高度（可选）
  /// [format] 视频格式（可选，如 mp4/avi）
  Future<int> sendVideoMessage({
    required String fromUserId,
    required String toUserId,
    required String fileId,
    required String url,
    String? coverUrl,
    int? duration,
    int? size,
    int? width,
    int? height,
    String? format,
    bool qos = true,
    String? fingerprint,
  }) async {
    final data = <String, dynamic>{
      'type': 'video',
      'file_id': fileId,
      'url': url,
    };
    if (coverUrl != null) data['cover_url'] = coverUrl;
    if (duration != null) data['duration'] = duration;
    if (size != null) data['size'] = size;
    if (width != null) data['width'] = width;
    if (height != null) data['height'] = height;
    if (format != null) data['format'] = format;
    return await sendText(
      fromUserId: fromUserId,
      toUserId: toUserId,
      content: jsonEncode(data),
      qos: qos,
      fingerprint: fingerprint,
    );
  }

  ///
  /// 发送位置消息
  /// [name] 位置名称
  /// [address] 详细地址
  /// [latitude] 纬度
  /// [longitude] 经度
  Future<int> sendLocationMessage({
    required String fromUserId,
    required String toUserId,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    bool qos = true,
    String? fingerprint,
  }) async {
    final data = <String, dynamic>{
      'type': 'location',
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
    return await sendText(
      fromUserId: fromUserId,
      toUserId: toUserId,
      content: jsonEncode(data),
      qos: qos,
      fingerprint: fingerprint,
    );
  }

  ///
  /// 发送系统通知消息
  /// [subtype] 通知子类型（如 friend_added）
  /// [content] 通知内容
  Future<int> sendSystemMessage({
    required String fromUserId,
    required String toUserId,
    required String subtype,
    required String content,
    bool qos = true,
    String? fingerprint,
  }) async {
    final data = <String, dynamic>{
      'type': 'system',
      'subtype': subtype,
      'content': content,
    };
    return await sendText(
      fromUserId: fromUserId,
      toUserId: toUserId,
      content: jsonEncode(data),
      qos: qos,
      fingerprint: fingerprint,
    );
  }

  ///
  /// 发送语音通话消息（信令）
  /// [callId] 通话唯一标识
  /// [action] 通话动作：calling/ringing/accepted/rejected/canceled/ended/missed/busy
  /// [sdp] WebRTC SDP 描述（可选）
  Future<int> sendVoiceCallMessage({
    required String fromUserId,
    required String toUserId,
    required String callId,
    required VoiceCallAction action,
    int? duration,
    bool qos = true,
    String? fingerprint,
  }) async {
    final data = <String, dynamic>{
      'type': 'voice_call',
      'caller_id': fromUserId,
      'callee_id': toUserId,
      'call_id': callId,
      'action': action.value,
    };
    if (duration != null) data['duration'] = duration;
    return await sendText(
      fromUserId: fromUserId,
      toUserId: toUserId,
      content: jsonEncode(data),
      qos: qos,
      fingerprint: fingerprint,
    );
  }

  /// 判断消息是否为语音通话呼叫信令
  /// 通过解析 JSON 判断 type=voice_call
  bool _isVoiceCallMessage(String raw) {
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map['type'] == 'voice_call' && map['action'] != 'canceled';
    } catch (_) {
      return false;
    }
  }

  /// 检测是否有来电并跳转到通话页面
  /// 忽略已接通话页面中和自己发送的消息
  void _checkIncomingCall(IMMessage msg) {
    if (_isCallPageActive) return;
    if (msg.fromUserId == null || msg.fromUserId == currentUserId) return;
    try {
      final map = jsonDecode(msg.textData) as Map<String, dynamic>;
      if (map['type'] != 'voice_call' || map['action'] != 'calling') return;
      _isCallPageActive = true;
      Get.toNamed(
        AppRoutes.VOICE_CALL,
        arguments: {
          'uid': int.tryParse(msg.fromUserId!) ?? 0,
          'incoming': true,
          'callId': map['call_id'] as String?,
          'fingerprint': msg.fingerprint,
        },
      )?.then((_) {
        _isCallPageActive = false;
        if (Get.isRegistered<ChatController>()) {
          Get.find<ChatController>().fetchAndInsertLatestVoiceCall();
        }
      });
    } catch (_) {}
  }

  /// 检查是否需要弹出消息通知
  /// 忽略自己发送的消息和已在聊天页中的会话
  Future<void> _checkShowNotification(IMMessage msg) async {
    if (msg.fromUserId == null || msg.fromUserId == currentUserId) return;
    final bool isInChat =
        Get.isRegistered<ChatController>() &&
        Get.find<ChatController>().uid.value.toString() == msg.fromUserId;
    if (isInChat) return;

    final name = await _getSenderName(msg.fromUserId!);
    final preview = _extractPreview(msg.textData);
    final uid = int.tryParse(msg.fromUserId!) ?? 0;

    final notifService = Get.find<NotificationService>();
    // Always show system notification (foreground + background)
    notifService.showMessageNotification(uid: uid, name: name, body: preview);
  }

  /// 获取用户信息（优先读缓存，缓存未命中再调 API）
  Future<Userinfo?> getUserInfo(String uid) async {
    if (_userInfoCache.containsKey(uid)) return _userInfoCache[uid];
    final userInfo = await ImMessageApi().getUserInfo(uid);
    if (userInfo != null) _userInfoCache[uid] = userInfo;
    return userInfo;
  }

  /// 获取发送者昵称（通过缓存 getUserInfo，不走 MessageController）
  Future<String> _getSenderName(String fromUserId) async {
    final userInfo = await getUserInfo(fromUserId);
    return userInfo?.nickname ?? fromUserId;
  }

  /// 从消息 JSON 中提取展示预览文本
  /// 根据 type 字段返回对应的摘要，如文本内容 / [图片] / [语音] 等
  String _extractPreview(String raw) {
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      switch (map['type'] as String?) {
        case 'text':
          return map['content'] as String? ?? raw;
        case 'image':
          return '[图片]';
        case 'audio':
          return '[语音]';
        case 'file':
          return '[文件]';
        case 'video':
          return '[视频]';
        case 'voice_call':
          return '[语音通话]';
        default:
          return '新消息';
      }
    } catch (_) {
      return raw.length > 50 ? '...' : raw;
    }
  }

  ///
  /// 登出并断开连接
  /// 发送登出请求 → 等待 200ms → 断开传输层
  Future<void> sendLogout() async {
    await _client?.sendLogout();
    await Future.delayed(const Duration(milliseconds: 200));
    await _client?.disconnect();
  }

  ///
  /// 释放 SDK 资源
  /// 调用后 IMClient 不可再用，需重新 init()
  void dispose() {
    _userInfoCache.clear();
    _msgController.close();
    _client?.releaseCore();
    _client = null;
    _serverIp = null;
    _serverPort = null;
  }
}

/// 语音通话信令动作枚举
enum VoiceCallAction {
  /// 发起呼叫（去电）
  calling,

  /// 被叫方响铃（通知主叫）
  ringing,

  /// 被叫方已接听
  accepted,

  /// 被叫方已拒绝
  rejected,

  /// 主叫方已取消（呼叫未接通前挂断）
  canceled,

  /// 通话已结束（接通后挂断）
  ended,

  /// 未接听（被叫方未操作）
  missed,

  /// 忙线（被叫方正在通话中）
  busy;

  /// 序列化为字符串（用于 JSON 信令消息）
  String get value => name;
}
