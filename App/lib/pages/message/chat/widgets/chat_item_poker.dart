import 'dart:convert';
import 'package:get/get.dart';
import 'package:freud/pages/message/chat/chat_controller.dart';

import 'package:flutter/material.dart';
import 'package:freud/api/live/question_api.dart';
import 'package:freud/constants/app_const.dart';

/// 智慧牌
class ChatItemPoker extends StatefulWidget {
  final String? content;

  const ChatItemPoker({super.key, this.content});

  @override
  State<ChatItemPoker> createState() => _ChatItemPokerState();
}

class _ChatItemPokerState extends State<ChatItemPoker> {
  final _cards = <Map<String, dynamic>>[];
  var _loading = true;
  Map<String, dynamic>? _dataMap;

  String? get _questionText => _dataMap?['content'] as String?;

  int? get _money => (_dataMap?['money'] as num?)?.toInt();

  int? get _questionId => (_dataMap?['question_id'] as num?)?.toInt();

  @override
  void initState() {
    super.initState();
    _parseContent();
    _loadCards();
  }

  void _parseContent() {
    if (widget.content != null) {
      try {
        _dataMap = jsonDecode(widget.content!);
      } catch (_) {}
    }
  }

  Future<void> _loadCards() async {
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
      final list = jsonDecode(astroContent) as List;
      if (mounted) {
        setState(() {
          _cards.addAll(list.cast<Map<String, dynamic>>());
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildCard(Map<String, dynamic> card) {
    final id = card['id'] as int;
    final imageName = id > 0 && id <= AppConst.TAROT_CARD_NAMES.length
        ? AppConst.TAROT_CARD_NAMES[id - 1]
        : null;
    return Column(
      spacing: 5,
      children: [
        Container(
          width: 26,
          height: 45,
          decoration: BoxDecoration(color: Colors.grey),
          child: imageName != null
              ? Image.asset(
                  'assets/images/taluopai/$imageName.jpg',
                  width: 26,
                  height: 45,
                  fit: BoxFit.fill,
                )
              : null,
        ),
        Text(
          card['title'] as String? ?? '',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xff383838),
          ),
        ),
      ],
    );
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
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xffF7FAFC),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _cards.map(_buildCard).toList(),
                  ),
          ),
          Row(
            children: [
              Text(
                '智慧牌解答',
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
