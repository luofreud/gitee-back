import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freud/api/live/question_api.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/pages/main/astrolabe/widgets/xingpan_svg.dart';
import 'package:freud/pages/message/chat/chat_controller.dart';
import 'package:get/get.dart';

/// 星盘内容
class ChatItemAstrolabe extends StatefulWidget {
  final String? content;

  const ChatItemAstrolabe({super.key, this.content});

  @override
  State<ChatItemAstrolabe> createState() => _ChatItemAstrolabeState();
}

class _ChatItemAstrolabeState extends State<ChatItemAstrolabe> {
  Map<String, dynamic>? _dataMap;
  var _loadingAstrolabe = false;
  String? _svgContent;

  String? get _questionText => _dataMap?['content'] as String?;

  int? get _questionId => (_dataMap?['question_id'] as num?)?.toInt();

  Archive? get _archive {
    if (_dataMap?['archive1'] != null) {
      return Archive.fromJson(_dataMap!['archive1'] as Map<String, dynamic>);
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
    _loadAstrolabeSvg();
  }

  Future<void> _loadAstrolabeSvg() async {
    final qid = _questionId;
    if (qid == null) return;
    setState(() => _loadingAstrolabe = true);
    try {
      final cache = Get.find<ChatController>().questionDetailCache;
      var xzQuestion = cache[qid];
      if (xzQuestion == null) {
        xzQuestion = await QuestionApi().questionDetail(qid);
        if (xzQuestion == null) return;
        // 缓存轻量版：astrology.content 只保留 svg 字段
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
          _loadingAstrolabe = false;
        });
        return;
      }
      final map = jsonDecode(astroContent) as Map<String, dynamic>;
      final svg = map['svg'] as String?;
      if (svg != null && mounted) {
        setState(() {
          _svgContent = svg;
          _loadingAstrolabe = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingAstrolabe = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final archive = _archive;
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
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffF7FAFC),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 12, color: Color(0xff383838)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text('姓名：${archive?.name ?? ''}'),
                  Text('性别：${archive?.sex == 0 ? '男' : '女'}'),
                  Text('出生时间：${archive?.birthday ?? ''}'),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _loadingAstrolabe
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
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text(
                '星盘解读',
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
