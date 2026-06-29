import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';

import '../../../../widgets/component/image_view.dart';

class ChatItemImage extends StatelessWidget {
  final String? content;

  const ChatItemImage({super.key, this.content});

  String? _parseLocalPath() {
    if (content == null) return null;
    try {
      if (content!.startsWith('{')) {
        final map = jsonDecode(content!) as Map<String, dynamic>;
        return map['localPath'] as String?;
      }
    } catch (_) {}
    return null;
  }

  String? _parseUrl() {
    if (content == null) return null;
    try {
      if (content!.startsWith('{')) {
        final map = jsonDecode(content!) as Map<String, dynamic>;
        return map['url'] as String?;
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localPath = _parseLocalPath();
    final url = _parseUrl();
    double maxWidth =
        MediaQuery.of(context).size.width - ((62 + AppConst.PAGE_PADDING) * 2);

    Widget imageWidget;
    if (localPath != null) {
      imageWidget = Stack(
        alignment: Alignment.center,
        children: [
          ImageView.file(
            localPath,
            borderRadius: BorderRadius.circular(6),
            isPreview: false,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      imageWidget = ImageView.network(
        url ?? '',
        borderRadius: BorderRadius.circular(6),
        isPreview: true,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: min(maxWidth * 0.8, 300)),
          child: imageWidget,
        ),
      ],
    );
  }
}
