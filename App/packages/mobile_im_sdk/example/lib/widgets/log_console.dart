import 'package:flutter/material.dart';

/// 一个简单的滚动日志面板,用于在示例页面中展示连接/收发日志.
class LogConsole extends StatefulWidget {
  final String title;
  const LogConsole({Key? key, this.title = '日志'}) : super(key: key);

  @override
  State<LogConsole> createState() => LogConsoleState();
}

class LogConsoleState extends State<LogConsole> {
  final List<String> _logs = <String>[];
  final ScrollController _scrollCtrl = ScrollController();

  void append(String msg) {
    final String ts = TimeOfDay.now().toString().substring(0, 8);
    setState(() {
      _logs.add('[$ts] $msg');
      if (_logs.length > 200) _logs.removeAt(0);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void clear() => setState(() => _logs.clear());

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey.shade100,
            child: Row(
              children: <Widget>[
                Text(widget.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                const Spacer(),
                InkWell(
                  onTap: clear,
                  child: const Text('清空',
                      style: TextStyle(
                          color: Colors.blue, fontSize: 12)),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            color: Colors.black87,
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              controller: _scrollCtrl,
              itemCount: _logs.length,
              itemBuilder: (_, int i) => Text(
                _logs[i],
                style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
