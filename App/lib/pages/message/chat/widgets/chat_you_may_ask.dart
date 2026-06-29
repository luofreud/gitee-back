import 'package:flutter/material.dart';

class ChatYouMayAsk extends StatelessWidget {
  const ChatYouMayAsk({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Row(
            children: [
              const Text('猜你想问'),
              Spacer(),
              GestureDetector(
                onTap: () {},
                child: Text('换一换', style: TextStyle(color: Color(0xff808080))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Text(
              '我还能和前任复合吗？',
              style: TextStyle(color: Color(0xff808080)),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              '我哪个时候才会遇到自己的正桃花？',
              style: TextStyle(color: Color(0xff808080)),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              '我暗恋的那个人喜欢我吗？',
              style: TextStyle(color: Color(0xff808080)),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text('他喜欢我吗？', style: TextStyle(color: Color(0xff808080))),
          ),
        ],
      ),
    );
  }
}
