import 'dart:convert';

import 'package:flutter/material.dart';

class ChatItemText extends StatelessWidget {
  final String? content;

  const ChatItemText({super.key, this.content});

  String? _parseText() {
    if (content == null) return null;
    try {
      if (content!.startsWith('{')) {
        final map = jsonDecode(content!) as Map<String, dynamic>;
        return map['content'] as String?;
      }
    } catch (_) {}
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        _parseText() ?? '',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }
}
