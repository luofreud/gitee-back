import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// 音频播放工具类（基于video_player封装）
/// 特性：
/// 1. 初始化/播放时传URL均可
/// 2. 播放新音频自动停止上一个
/// 3. 打断其他应用音频播放（禁用混合播放）
/// 4. 禁用后台播放
class AudioPlayerManager {
  // 单例模式（全局唯一播放器，确保互斥播放）
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();

  factory AudioPlayerManager() => _instance;

  AudioPlayerManager._internal();

  // 核心播放器控制器
  VideoPlayerController? _controller;

  // 当前播放的音频URL
  String? _currentUrl;

  // 播放状态监听
  ValueNotifier<bool> isPlaying = ValueNotifier(false);

  // 播放完成回调
  VoidCallback? _onComplete;

  /// 初始化播放器（可选：提前传入URL）
  /// [url] 音频地址（网络URL）
  Future<void> init({String? url}) async {
    if (url != null && url.isNotEmpty) {
      _currentUrl = url;
      await _createController(url);
    }
  }

  /// 播放音频
  /// [url] 可选：播放新的音频URL（不传则播放初始化时的URL）
  /// [onComplete] 播放完成回调
  Future<bool> play({String? url, VoidCallback? onComplete}) async {
    // 1. 有新URL则更新并停止旧播放器
    if (url != null && url.isNotEmpty && url != _currentUrl) {
      await stop(); // 停止上一个音频
      _currentUrl = url;
      await _createController(url);
    }

    // 2. 保存回调
    _onComplete = onComplete;

    // 2. 控制器未初始化则进行初始化
    if (_controller == null || !_controller!.value.isInitialized) {
      await init(url: url);
    }

    // 3. 开始播放（打断其他音频）
    await _controller!.play();
    isPlaying.value = true;
    return true;
  }

  /// 暂停播放
  void pause() {
    if (_controller?.value.isPlaying ?? false) {
      _controller?.pause();
      isPlaying.value = false;
    }
  }

  /// 停止播放（释放当前控制器）
  Future<void> stop() async {
    _onComplete = null;
    if (_controller != null) {
      await _controller!.pause();
      await _controller!.dispose();
      _controller = null;
      _currentUrl = null;
      isPlaying.value = false;
    }
  }

  /// 跳转到指定进度
  /// [seconds] 秒数
  void seekTo(int seconds) {
    if (_controller?.value.isInitialized ?? false) {
      _controller?.seekTo(Duration(seconds: seconds));
    }
  }

  /// 获取当前播放进度（秒）
  int get currentPosition {
    if (_controller?.value.isInitialized ?? false) {
      return _controller!.value.position.inSeconds;
    }
    return 0;
  }

  /// 获取音频总时长（秒）
  int get totalDuration {
    if (_controller?.value.isInitialized ?? false) {
      return _controller!.value.duration.inSeconds;
    }
    return 0;
  }

  /// 设置音量（0~1）
  void setVolume(double volume) {
    if (volume < 0) volume = 0;
    if (volume > 1) volume = 1;
    _controller?.setVolume(volume);
  }

  /// 创建播放器控制器（核心配置：禁用混合播放、打断其他音频）
  Future<void> _createController(String url) async {
    try {
      // 构建控制器（禁用mixWithOthers，确保打断其他音频）
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false, // 禁用混合播放，打断其他音频
        ),
      );

      // 初始化控制器
      await _controller!.initialize();
      // 监听播放状态（完成或出错均停止动画）
      _controller!.addListener(() {
        if (_controller!.value.hasError) {
          _onComplete?.call();
          return;
        }
        if (_controller!.value.position >= _controller!.value.duration &&
            _controller!.value.duration != Duration.zero) {
          pause(); // 播放完成后暂停
          _controller!.seekTo(Duration.zero); // 重置进度
          _onComplete?.call(); // 通知播放完成
        }
      });
    } catch (e) {
      _onComplete?.call();
      _onComplete = null;
      _controller?.dispose();
      _controller = null;
    }
  }

  /// 释放资源（页面销毁时调用）
  Future<void> dispose() async {
    await stop();
  }
}
