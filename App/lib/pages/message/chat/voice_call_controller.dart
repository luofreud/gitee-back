import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:freud/api/im/im_message.dart';
import 'package:freud/service/im_service.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/widgets/live/agora_live.dart';
import 'package:get/get.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

/// 语音通话控制器
/// 管理来电/去电逻辑、铃声播放、信令消息发送
class VoiceCallController extends GetxController {
  dynamic targetUid;

  final imService = Get.find<ImService>();

  final agoraLive = AgoraLive();
  final imMessageApi = ImMessageApi();

  /// 是否静音
  final isMuted = false.obs;

  /// 是否扬声器外放
  final isSpeakerOn = false.obs;

  /// 当前通话页面状态（复用 VoiceCallAction 作为页面状态标记）
  final callState = VoiceCallAction.calling.obs;

  /// 对方昵称
  final partnerName = ''.obs;

  /// 对方头像 URL
  final partnerAvatar = ''.obs;

  /// 音频播放器（来电铃声/去电回铃音共用）
  AudioPlayer? _player;

  /// 当前通话 ID
  String? _callId;

  /// 通话消息指纹（用于后续所有信令消息透传）
  String? _fingerprint;

  /// IM 消息订阅（用于监听远程通话信令）
  StreamSubscription<IMMessage>? _msgSubscription;

  /// 通话计时器（每秒 +1）
  Timer? _timer;

  /// 通话已持续秒数（>0 表示已接通）
  final callDuration = 0.obs;

  /// 格式化的通话时长（mm:ss）
  String get formattedDuration {
    final min = callDuration.value ~/ 60;
    final sec = callDuration.value % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map;
    targetUid = args['uid'] ?? 0;
    final isIncoming = args['incoming'] == true;
    _callId = args['callId'] as String?;
    _fingerprint = args['fingerprint'] as String?;
    _fingerprint ??= FingerprintGen.next();
    callState.value = isIncoming
        ? VoiceCallAction.ringing
        : VoiceCallAction.calling;

    if (targetUid > 0) {
      // 异步获取对方用户信息（昵称+头像）
      imService.getUserInfo(targetUid.toString()).then((info) {
        partnerName.value = info?.nickname ?? '';
        partnerAvatar.value = info?.headimg ?? '';
      });

      if (isIncoming) {
        // 来电 → 播放铃声
        _playRingtone();
      } else {
        // 去电 → 发送呼叫信令
        _callId = _callId ?? _fingerprint ?? FingerprintGen.next();
        _sendCallAction(VoiceCallAction.calling);
        // _initAgoraForCall();
        _playRingbackTone();
      }
    }

    // 订阅 IM 消息流，监听远程通话信令（挂断、拒绝等）
    _msgSubscription = imService.onNewMessage.listen(_handleCallMessage);
  }

  /// 初始化 Agora RTC 并加入通话频道
  Future<void> _initAgoraForCall() async {
    final tokenRes = await imMessageApi.getVoiceCallToken(channelName: _callId);
    if (tokenRes == null) return;
    final token = tokenRes["token"] as String;
    final appId = tokenRes["appid"] as String;
    final channelName = tokenRes["channelName"] as String;
    try {
      final uid = Get.find<UserService>().userinfo.value?.roomid ?? 0;
      await agoraLive.init(
        appId: appId,
        uid: uid,
        token: token,
        enableRtm: false,
      );
      await agoraLive.setDefaultSpeakerphone(isSpeakerOn.value);
      await agoraLive.joinRtcChannel(
        token: token,
        channel: channelName,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      );
    } catch (e) {
      debugPrint('Agora init failed: $e');
    }
  }

  /// 播放来电铃声（循环播放）
  Future<void> _playRingtone() async {
    _player ??= AudioPlayer();
    await _player!.setSource(AssetSource('audio/ringback.mp3'));
    _player!.setReleaseMode(ReleaseMode.loop);
    await _player!.resume();
  }

  /// 播放回铃音（去电等待时循环播放嘟嘟声）
  Future<void> _playRingbackTone() async {
    _player ??= AudioPlayer();
    await _player!.setSource(AssetSource('audio/ringback.mp3'));
    _player!.setReleaseMode(ReleaseMode.loop);
    await _player!.resume();
  }

  /// 处理远程通话信令消息
  /// 解析 voice_call 类型的消息，根据 action 做对应处理
  void _handleCallMessage(IMMessage msg) {
    if (msg.fromUserId == null || msg.fromUserId == imService.currentUserId) {
      return;
    }
    try {
      final map = jsonDecode(msg.textData) as Map<String, dynamic>;
      if (map['type'] != 'voice_call' || map['call_id'] != _callId) return;
      final action = VoiceCallAction.values.firstWhere(
        (e) => e.value == map['action'],
        orElse: () => VoiceCallAction.ended,
      );
      switch (action) {
        case VoiceCallAction.ended:
        case VoiceCallAction.canceled:
          _handleRemoteHangUp();
        case VoiceCallAction.rejected:
          if (callState.value == VoiceCallAction.calling) {
            _handleRemoteHangUp();
          }
        case VoiceCallAction.accepted:
          if (callState.value == VoiceCallAction.calling) {
            _startCallSession();
          }
          break;
        default:
          break;
      }
    } catch (_) {}
  }

  /// 开始通话会话（停铃声 + 启动计时）
  void _startCallSession() async {
    await _initAgoraForCall();
    await agoraLive.enableAudio();
    callState.value = VoiceCallAction.accepted;
    _player?.stop();
    callDuration.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      callDuration.value++;
    });
  }

  /// 处理远端挂断/拒绝（不发信令，仅本地清理后关闭页面）
  void _handleRemoteHangUp() {
    callState.value = VoiceCallAction.ended;
    _timer?.cancel();
    _player?.stop();
    agoraLive.leaveChannel();
    Get.back();
  }

  /// 发送通话信令消息
  /// [action] 通话动作枚举
  void _sendCallAction(VoiceCallAction action, {int? duration}) {
    imService.sendVoiceCallMessage(
      fromUserId: imService.currentUserId ?? '',
      toUserId: targetUid.toString(),
      callId: _callId ?? '',
      action: action,
      duration: duration,
      fingerprint: _fingerprint,
      qos: action == VoiceCallAction.calling ? true : false,
    );
  }

  final isAnswering = false.obs;

  /// 接听来电：启动通话会话 + 发送接听信令
  Future<void> answerCall() async {
    isAnswering.value = true;
    try {
      _sendCallAction(VoiceCallAction.accepted);
      _startCallSession();
    } finally {
      isAnswering.value = false;
    }
  }

  /// 拒绝来电：停铃声 + 发送拒绝信令 + 返回
  void rejectCall() {
    _player?.stop();
    _sendCallAction(VoiceCallAction.rejected);
    if (_callId != null) agoraLive.leaveChannel();
    Get.back();
  }

  /// 挂断电话
  Future<void> hangUp() async {
    _timer?.cancel();
    _player?.stop();
    _sendCallAction(
      callState.value == VoiceCallAction.accepted
          ? VoiceCallAction.ended
          : VoiceCallAction.canceled,
      duration: callDuration.value,
    );
    await agoraLive.leaveChannel();
    Get.back();
  }

  /// 切换静音
  Future<void> toggleMute() async {
    isMuted.value = !isMuted.value;
    if (isMuted.value) {
      await agoraLive.disableAudio();
    } else {
      await agoraLive.enableAudio();
    }
  }

  /// 切换扬声器
  Future<void> toggleSpeaker() async {
    isSpeakerOn.value = !isSpeakerOn.value;
    await agoraLive.setSpeakerphone(isSpeakerOn.value);
  }

  @override
  void onClose() {
    _timer?.cancel();
    _msgSubscription?.cancel();
    _player?.dispose();
    agoraLive.leaveChannel();
    super.onClose();
  }
}
