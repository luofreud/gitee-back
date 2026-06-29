import 'dart:convert';
import 'package:get/get.dart';
import 'package:freud/pages/message/chat/chat_controller.dart';

import 'package:flutter/material.dart';
import 'package:freud/api/live/question_api.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/component/icon_widget.dart';

/// 骰子内容
class ChatItemDice extends StatefulWidget {
  final String? content;

  const ChatItemDice({super.key, this.content});

  @override
  State<ChatItemDice> createState() => _ChatItemDiceState();
}

class _ChatItemDiceState extends State<ChatItemDice> {
  final _diceItems = <Map<String, dynamic>>[];
  var _loading = true;
  Map<String, dynamic>? _dataMap;

  String? get _questionText => _dataMap?['content'] as String?;

  int? get _money => (_dataMap?['money'] as num?)?.toInt();

  int? get _questionId => (_dataMap?['question_id'] as num?)?.toInt();

  @override
  void initState() {
    super.initState();
    _parseContent();
    _loadDiceData();
  }

  void _parseContent() {
    if (widget.content != null) {
      try {
        _dataMap = jsonDecode(widget.content!);
      } catch (_) {}
    }
  }

  Future<void> _loadDiceData() async {
    final qid = _questionId;
    if (qid == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final cache = Get.find<ChatController>().questionDetailCache;
      final xzQuestion = cache[qid] ?? await QuestionApi().questionDetail(qid);
      if (!cache.containsKey(qid) && xzQuestion != null) cache[qid] = xzQuestion;
      final astroContent = xzQuestion?.astrology?.content;
      if (astroContent == null) {
        if (mounted) setState(() => _loading = false);
        return;
      }
      final map = jsonDecode(astroContent) as Map<String, dynamic>;
      Map<String, dynamic> parse(Map m, String type) {
        final id = m['id'] as int;
        final c = List<String>.from(m['content'] as List);
        return <String, dynamic>{
          'type': type,
          'id': id,
          'title': c[0],
          'desc': c.sublist(1),
        };
      }
      if (mounted) {
        setState(() {
          _diceItems.addAll([
            parse(map['planet'] as Map, 'planet'),
            parse(map['house'] as Map, 'house'),
            parse(map['constellation'] as Map, 'constellation'),
          ]);
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildIcon(Map item, double radius) {
    switch (item['type']) {
      case 'planet':
        {
          final id = item['id'] as int;
          final icon = id < AppConst.XINGXING_ICON.length
              ? AppConst.XINGXING_ICON[id].icon
              : '';
          return IconWidget(icon: 'xingpan/$icon.png', size: radius * 2);
        }
      case 'house':
        return CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xffedf5ff),
          child: Text(
            '${(item['id'] as int) + 1}',
            style: TextStyle(
              color: const Color(0xff2A82E4),
              fontWeight: FontWeight.w500,
              fontSize: radius * 1.2,
            ),
          ),
        );
      case 'constellation':
        {
          final id = item['id'] as int;
          final icon = id < AppConst.CONSTELLATION.length
              ? AppConst.CONSTELLATION[id].icon
              : '';
          return IconWidget(icon: 'constellation/$icon.png', size: radius * 2);
        }
    }
    return CircleAvatar(radius: radius, backgroundColor: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(15.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffF7FAFC),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _diceItems
                        .map(
                          (item) => Column(
                            spacing: 5,
                            children: [
                              _buildIcon(item, 45 / 2),
                              Text(
                                item['title'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff383838),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
          ),
          Row(
            children: [
              Text(
                '骰子解答',
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
