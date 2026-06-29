import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraLive {
  String? appId;
  int? uid;
  String? token;
  Function(LiveMessage message)? onMessage;

  RtcEngineEx? _rtcEngine;
  String? channel;
  bool isJoined = false;

  /// 是否开启RTM连接
  bool isEnableRtm = false;

  /// 多频段连接信息
  List<RtcConnection> multiChannels = [];

  RtmClient? _rtmClient;

  // 1. 静态私有实例
  static AgoraLive? _instance;

  // 2. 私有构造函数（禁止外部直接实例化）
  AgoraLive._internal();

  // 3. 工厂构造方法
  factory AgoraLive() {
    _instance ??= AgoraLive._internal();
    return _instance!;
  }

  Future<AgoraLive> init({
    required appId,
    required int uid,
    String? token,
    Function(LiveMessage message)? onMessage,
    bool? enableRtm = true,
  }) async {
    this.appId = appId;
    this.uid = uid;
    this.token = token;
    this.onMessage = onMessage;
    this.isEnableRtm = enableRtm ?? true;
    if (this.appId == null || this.appId!.isEmpty) {
      throw '请传入 appId';
    }

    // 申请语言权限
    await [Permission.microphone].request();

    await initRtc();
    if (isEnableRtm) {
      await initRtm();
    }
    return this;
  }

  /// 初始化 RtcEngine
  Future<void> initRtc() async {
    if (_rtcEngine != null) return;

    // 创建 RtcEngine
    _rtcEngine = createAgoraRtcEngineEx();
    // 初始化 RtcEngine，设置频道场景为 channelProfileLiveBroadcasting（直播场景）
    await _rtcEngine!.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    // 添加回调事件
    _rtcEngine!.registerEventHandler(
      RtcEngineEventHandler(
        // 成功加入频道回调
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          isJoined = true;
          debugPrint("local user ${connection.localUid} joined");
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          debugPrint("onLeaveChannel ${connection.channelId}");
          isJoined = false;
        },
        // 远端用户或主播加入当前频道回调
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
        },
        // 远端用户或主播离开当前频道回调
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              debugPrint("remote user $remoteUid offline channel");
            },
        onError: (ErrorCodeType err, String message) {
          debugPrint('${err} $message');
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          // token即将过期
          debugPrint('token will expire in 30 seconds');
          // 调用 renewToken 来传入新的 Token。
          // 调用 leaveChannel 离开当前频道，然后在调用 joinChannel 时传入新的 Token 重新加入频道。
        },
      ),
    );
  }

  /// 初始化 RTM
  Future<void> initRtm() async {
    try {
      if (_rtmClient != null) return;
      final (status, client) = await RTM(appId!, uid.toString());
      if (status.error == true) {
        debugPrint(
          '${status.operation} failed due to ${status.reason}, error code: ${status.errorCode}',
        );
      } else {
        _rtmClient = client;

        _rtmClient!.addListener(
          // add message event handler
          message: (event) {
            print(
              'recieved a message from channel: ${event.channelName}, channel type : ${event.channelType}',
            );
            print(
              'message content: ${utf8.decode(event.message!)}, custome type: ${event.customType}',
            );
            handleRtmMessage(event);
          },
          // add link state event handler
          linkState: (event) {
            print(
              'link state changed from ${event.previousState} to ${event.currentState}',
            );
            print(
              'reason: ${event.reason}, due to operation ${event.operation}',
            );
          },
        );
      }
    } catch (e) {
      debugPrint('Initialize falid!:${e}');
    }
  }

  handleRtmMessage(MessageEvent event) {
    if (event.message?.isEmpty ?? true) return;
    String message = utf8.decode(event.message!);
    if (message.isEmpty) return;
    try {
      LiveMessage liveMessage = LiveMessage.fromJson(jsonDecode(message));

      if (event.channelType == RtmChannelType.message) {
        // 通过频道接收的消息
        onMessage?.call(liveMessage);
      } else if (event.channelType == RtmChannelType.user) {
        // 个人消息
        onMessage?.call(liveMessage);
      }
    } catch (e) {
      debugPrint('消息格式化错误${e.toString()}');
    }
  }

  /// 进入直播间
  ///
  /// [channel] 频道名称
  ///
  /// [clientRoleType] 用户角色 clientRoleBroadcaster（主播）或 clientRoleAudience（观众）
  joinChannel({
    required String channel,
    String? token,
    ClientRoleType clientRoleType = ClientRoleType.clientRoleAudience,
  }) async {
    final channelToken = token ?? this.token ?? '';
    this.channel = channel;
    this.token = channelToken;

    try {
      await joinRtcChannel(token: channelToken, clientRoleType: clientRoleType);
      if (isEnableRtm) await joinRtmChannel(token: channelToken);

      isJoined = true;
    } on AgoraRtcException catch (e) {
      debugPrint('${e.code} ${e.message}');
      _rtcEngine?.leaveChannel();
      throw '进入直播间失败';
    } catch (e) {
      debugPrint(e.toString());
      _rtcEngine?.leaveChannel();
      throw '进入直播间失败';
    }
  }

  joinRtcChannel({
    required String token,
    String? channel,
    ClientRoleType? clientRoleType,
  }) async {
    if (_rtcEngine == null) throw '未初始化';

    if (channel != null && channel != this.channel) {
      if (isJoined) {
        await leaveRtcChannel();
      }
    } else {
      if (isJoined) {
        return;
      }
    }
    await _rtcEngine!.joinChannel(
      token: token,
      channelId: channel ?? this.channel ?? '',
      uid: uid!,
      options: ChannelMediaOptions(
        // 自动订阅所有音频流
        autoSubscribeAudio: true,
        // 发布麦克风采集的音频
        publishMicrophoneTrack: true,
        // 设置用户角色为 clientRoleBroadcaster（主播）或 clientRoleAudience（观众）
        clientRoleType: clientRoleType ?? ClientRoleType.clientRoleAudience,
      ),
    );
    await _rtcEngine!.enableAudio();
  }

  joinRtmChannel({required String token}) async {
    if (_rtmClient == null) throw '未初始化';
    var (status, response) = await _rtmClient!.login(token);
    if (status.error == true) {
      print('login RTM error! ${status.errorCode}');
    } else {
      var (status, response) = await _rtmClient!.subscribe(channel!);
      if (status.error == true) {
        print(
          '${status.operation} failed due to ${status.reason}, error code: ${status.errorCode}',
        );
      } else {
        print('subscribe channel: ${channel} success!');
      }

      print('login RTM success!');
    }
  }

  /// 加入多频道直播间
  joinChannelEx({
    required String channel,
    String? token,
    ChannelMediaOptions? options,
  }) {
    final findConnect = multiChannels.firstWhereOrNull(
      (element) => element.channelId == channel,
    );
    if (findConnect != null) {
      return;
    }
    final rtcConnection = RtcConnection(channelId: channel, localUid: uid);
    _rtcEngine?.joinChannelEx(
      token: token!,
      connection: rtcConnection,
      options:
          options ??
          ChannelMediaOptions(
            // 自动订阅所有音频流
            autoSubscribeAudio: true,
            // 发布麦克风采集的音频
            publishMicrophoneTrack: true,
            // 设置用户角色为 clientRoleBroadcaster（主播）或 clientRoleAudience（观众）
            clientRoleType: ClientRoleType.clientRoleAudience,
          ),
    );
    multiChannels.add(rtcConnection);
  }

  /// 离开多频道
  leaveChannelEx({required String channel}) {
    final findConnect = multiChannels.firstWhereOrNull(
      (element) => element.channelId == channel,
    );
    if (findConnect == null) {
      return;
    }
    _rtcEngine?.leaveChannelEx(connection: findConnect);
    multiChannels.remove(findConnect);
  }

  /// 发送消息
  ///
  /// receive 可以填频道也可以填用户id，如果填用户id则需要将channelType设置为RtmChannelType.user
  /// 如果未填写则默认使用初始化时的频道
  Future<bool> publishMessage({
    String? receive,
    required LiveMessage message,
    channelType = RtmChannelType.message,
  }) async {
    message.senderUid ??= uid.toString();
    message.timestamp ??= DateTime.now();
    var (status, response) = await _rtmClient!.publish(
      receive != null && receive.isNotEmpty ? receive : channel!,
      message.toString(),
      channelType: channelType,
    );
    if (status.error == true) {
      print('send message error! ${status.errorCode}');
      return false;
    } else {
      print('send message success!');
      return true;
    }
  }

  /// 启动本地语音发布
  enableAudio() async {
    await _rtcEngine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    // await _rtcEngine?.enableAudio();

    //enableLocalAudio: 是否启动麦克风采集并创建本地音频流。
    await _rtcEngine?.enableLocalAudio(true);
    // muteLocalAudioStream: 是否停止发布本地音频流。true停止 false发布
    await _rtcEngine?.muteLocalAudioStream(false);

    // muteAllRemoteAudioStreams: 是否接收并播放所有远端音频流。
    // await _rtcEngine?.muteAllRemoteAudioStreams(false);
  }

  /// 停止本地语音发布
  disableAudio() async {
    await _rtcEngine?.setClientRole(role: ClientRoleType.clientRoleAudience);

    //enableLocalAudio: 是否启动麦克风采集并创建本地音频流。
    await _rtcEngine?.enableLocalAudio(false);

    // muteLocalAudioStream: 是否停止发布本地音频流。true停止 false发布
    await _rtcEngine?.muteLocalAudioStream(true);

    // await _rtcEngine?.muteAllRemoteAudioStreams(false);
  }

  /// 设置默认音频路由，true外放，false 听筒
  /// 加入频道前设置
  Future<void> setDefaultSpeakerphone(bool enabled) async {
    await _rtcEngine?.setDefaultAudioRouteToSpeakerphone(enabled);
  }

  /// 切换扬声器外放，true外放，false 听筒
  /// 加入频道后设置
  Future<void> setSpeakerphone(bool enabled) async {
    await _rtcEngine?.setEnableSpeakerphone(enabled);
  }

  /// 离开直播间
  leaveChannel() async {
    try {
      await _rtcEngine?.leaveChannel();
      await _rtmClient!.logout();
    } catch (e) {
      print('something went wrong with logout: $e');
    }
  }

  /// 离开 RtcChannel
  leaveRtcChannel() async {
    try {
      await _rtcEngine?.leaveChannel();
      isJoined = false;
    } catch (e) {
      print('something went wrong with logout: $e');
    }
  }

  /// 销毁 RtcEngine
  ///
  /// 注意：
  /// 离开频道后，RtcEngine 不再接收新的事件和回调。
  dispose() async {
    await _rtcEngine?.leaveChannel();
    await _rtcEngine?.release();
    _rtcEngine = null;

    await _rtmClient?.logout();
    await _rtmClient?.release();
    _rtmClient = null;
  }
}

class LiveMessage {
  final LiveMessageType type;
  final String message;
  String? senderUid;
  String? senderName;
  DateTime? timestamp;

  LiveMessage({
    required this.type,
    required this.message,
    this.senderUid,
    this.senderName,
    this.timestamp,
  });

  factory LiveMessage.fromJson(Map<String, dynamic> json) {
    return LiveMessage(
      type: LiveMessageType.values[json['type']],
      message: json['message'],
      senderUid: json['senderUid'],
      senderName: json['senderName'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }

  String toString() {
    return jsonEncode({
      'type': type.index,
      'message': message,
      'senderUid': senderUid,
      'senderName': senderName,
      'timestamp': timestamp?.millisecondsSinceEpoch,
    });
  }
}

enum LiveMessageType {
  /// 文本会话
  chat,

  /// 连麦申请
  voice,

  /// 提示
  notice,

  /// 加入
  join,

  /// 离开
  leave,
}
