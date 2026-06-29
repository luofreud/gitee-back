import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chat_controller.dart';

class ChatItemVoice extends StatefulWidget {
  final String? content;

  const ChatItemVoice({super.key, this.content});

  @override
  State<ChatItemVoice> createState() => _ChatItemVoiceState();
}

class _ChatItemVoiceState extends State<ChatItemVoice> {
  final _chatController = Get.find<ChatController>();
  final _playController = _VoicePlayController();
  StreamSubscription? _voiceSub;

  String? get _url {
    if (widget.content == null) return null;
    try {
      final map = jsonDecode(widget.content!) as Map<String, dynamic>;
      final localPath = map['localPath'] as String?;
      if (localPath != null) return null;
      return map['url'] as String?;
    } catch (_) {
      return null;
    }
  }

  int get _duration {
    if (widget.content == null) return 1;
    try {
      final map = jsonDecode(widget.content!) as Map<String, dynamic>;
      final localPath = map['localPath'] as String?;
      if (localPath != null) return 0;
      return map['duration'] as int? ?? 1;
    } catch (_) {
      return 1;
    }
  }

  bool get _isLocal {
    if (widget.content == null) return true;
    try {
      final map = jsonDecode(widget.content!) as Map<String, dynamic>;
      return map['localPath'] != null;
    } catch (_) {
      return false;
    }
  }

  bool get _isPlaying => _chatController.playingVoiceUrl.value == _url;

  @override
  void initState() {
    super.initState();
    if (_isPlaying) _playController.play();
    _voiceSub = _chatController.playingVoiceUrl.listen((_) {
      if (!mounted) return;
      if (_isPlaying) {
        _playController.play();
      } else {
        _playController.stop();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _voiceSub?.cancel();
    _playController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voiceSeconds = _duration.toDouble();
    final voiceWidth = voiceSeconds / 60 * 150;
    return GestureDetector(
      onTap: () {
        final url = _url;
        if (url == null || _isLocal) return;
        _chatController.playVoice(url);
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: math.max(math.min(voiceWidth, 150), 80),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            _VoicePlayAnimation(controller: _playController),
            Text(
              '${_duration}\'\'',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff383838),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoicePlayAnimation extends StatefulWidget {
  final _VoicePlayController? controller;

  const _VoicePlayAnimation({super.key, this.controller});

  @override
  State<_VoicePlayAnimation> createState() => _VoicePlayAnimationState();
}

class _VoicePlayAnimationState extends State<_VoicePlayAnimation> {
  int _currentIndex = 0;
  bool playing = false;
  var icon = Icons.wifi;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(listener);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (widget.controller?.playing == true) {
      playing = true;
      _playAnimation();
    } else {
      playing = false;
    }
  }

  void _playAnimation() {
    if (!playing) {
      icon = Icons.wifi;
      setState(() {});
      return;
    }
    if (_currentIndex >= 3) {
      _currentIndex = 0;
    }
    switch (_currentIndex) {
      case 0:
        icon = Icons.wifi_1_bar;
        break;
      case 1:
        icon = Icons.wifi_2_bar;
        break;
      case 2:
        icon = Icons.wifi;
        break;
    }
    if (mounted) setState(() {});
    Future.delayed(const Duration(milliseconds: 300), () {
      _currentIndex++;
      _playAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 90 * math.pi / 180.00,
      child: Icon(icon, size: 16),
    );
  }
}

class _VoicePlayController extends ChangeNotifier {
  bool _playing = false;

  bool get playing => _playing;

  void play() {
    _playing = true;
    notifyListeners();
  }

  void stop() {
    _playing = false;
    notifyListeners();
  }
}
