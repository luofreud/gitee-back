import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freud/api/live/question_api.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/pages/main/astrolabe/widgets/xingpan_svg.dart';
import 'package:freud/pages/message/chat/chat_controller.dart';
import 'package:get/get.dart';

/// 合盘内容
class ChatItemComposite extends StatefulWidget {
  final String? content;

  const ChatItemComposite({super.key, this.content});

  @override
  State<ChatItemComposite> createState() => _ChatItemCompositeState();
}

class _ChatItemCompositeState extends State<ChatItemComposite> {
  Map<String, dynamic>? _dataMap;
  var _loading = false;
  String? _svgContent;

  String? get _questionText => _dataMap?['content'] as String?;

  int? get _questionId => (_dataMap?['question_id'] as num?)?.toInt();

  Archive? get _archive1 {
    if (_dataMap?['archive1'] != null) {
      return Archive.fromJson(_dataMap!['archive1'] as Map<String, dynamic>);
    }
    return null;
  }

  Archive? get _archive2 {
    if (_dataMap?['archive2'] != null) {
      return Archive.fromJson(_dataMap!['archive2'] as Map<String, dynamic>);
    }
    return null;
  }

  int? get _money => (_dataMap?['money'] as num?)?.toInt();

  @override
  void initState() {
    super.initState();
    if (widget.content != null) {
      try {
        _dataMap = jsonDecode(widget.content!);
      } catch (_) {}
    }
    _loadCompositeData();
  }

  Future<void> _loadCompositeData() async {
    final qid = _questionId;
    if (qid == null) return;
    setState(() => _loading = true);
    try {
      final cache = Get.find<ChatController>().questionDetailCache;
      var xzQuestion = cache[qid];
      if (xzQuestion == null) {
        xzQuestion = await QuestionApi().questionDetail(qid);
        if (xzQuestion == null) return;
        if (xzQuestion.astrology?.content != null) {
          final astroMap =
              jsonDecode(xzQuestion.astrology!.content!)
                  as Map<String, dynamic>;
          final svg = astroMap['svg'] as String?;
          if (svg != null) {
            xzQuestion.astrology!.content = jsonEncode({'svg': svg});
          }
        }
        cache[qid] = xzQuestion;
      }
      final astroContent = xzQuestion.astrology?.content;
      if (astroContent == null) {
        setState(() {
          _loading = false;
        });
        return;
      }
      final map = jsonDecode(astroContent) as Map<String, dynamic>;
      final svg = map['svg'] as String?;
      if (svg != null && mounted) {
        setState(() {
          _svgContent = svg;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final a1 = _archive1;
    final a2 = _archive2;
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
      ),
      constraints: const BoxConstraints(maxWidth: 280.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _questionText ?? '',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffF7FAFC),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      spacing: 5,
                      children: [
                        CircleAvatar(
                          radius: 45 / 2,
                          backgroundColor: Colors.white,
                          child: Text(
                            a1?.name?.isNotEmpty == true ? a1!.name![0] : '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffFF52CE),
                            ),
                          ),
                        ),
                        Text(
                          a1?.name ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff383838),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      spacing: 5,
                      children: [
                        Icon(Icons.add, color: Color(0xff383838)),
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff383838),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      spacing: 5,
                      children: [
                        CircleAvatar(
                          radius: 45 / 2,
                          backgroundColor: Colors.white,
                          child: Text(
                            a2?.name?.isNotEmpty == true ? a2!.name![0] : '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffFF52CE),
                            ),
                          ),
                        ),
                        Text(
                          a2?.name ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff383838),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _loading
                    ? const SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _svgContent != null
                    ? SizedBox(
                        width: 100,
                        height: 100,
                        child: XingpanSvg(svgString: _svgContent),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                '合盘解答',
                style: TextStyle(fontSize: 12, color: Color(0xff808080)),
              ),
              Spacer(),
              GestureDetector(
                child: Text(
                  '查看详情',
                  style: TextStyle(fontSize: 12, color: Color(0xff2A82E4)),
                ),
              ),
            ],
          ),
          if (_money != null && _money! > 0)
            Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                color: Color(0xffF7FAFC),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '赞赏：',
                    style: TextStyle(color: Color(0xffFF8D1A), height: 1),
                  ),
                  Text(
                    '$_money',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xffFF8D1A),
                      height: 1,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(2, 1),
                    child: Image.asset(
                      'assets/icons/icon_zuanshi.png',
                      width: 16,
                      height: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
