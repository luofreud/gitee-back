import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class ChatItemVoiceCall extends StatelessWidget {
  final String? content;
  final bool isSend;

  const ChatItemVoiceCall({super.key, this.content, this.isSend = true});

  @override
  Widget build(BuildContext context) {
    String label = '语音通话';
    if (content != null && content!.isNotEmpty) {
      try {
        final map = jsonDecode(content!) as Map<String, dynamic>;
        final action = map['action'] as String?;
        final duration = map['duration'] as int?;
        switch (action) {
          case 'ended':
            if (duration != null && duration > 0) {
              final min = duration ~/ 60;
              final sec = duration % 60;
              label =
                  '通话时长 ${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
            }
            break;
          case 'rejected':
            label = isSend ? '对方已拒绝' : '已拒绝';
            break;
          case 'canceled':
            label = '已取消';
            break;
          case 'missed':
            label = '未接听';
            break;
          case 'busy':
            label = '对方忙线中';
            break;
        }
      } catch (_) {}
    }

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: isSend ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Transform.rotate(
            angle: 135 * pi / 180,
            child: Icon(Icons.phone, size: 16, color: Color(0xff383838)),
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
