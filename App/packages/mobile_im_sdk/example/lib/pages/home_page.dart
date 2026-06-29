import 'package:flutter/material.dart';

import 'tcp_page.dart';
import 'udp_page.dart';
import 'websocket_page.dart';

/// 示例应用主页:展示 3 种连接方式.
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobileIMSDK Flutter Demo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.bolt, color: Colors.amber.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'MobileIMSDK Flutter 插件',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '基于纯 Dart 实现的统一 IM 客户端接口,'
                    '支持 TCP / UDP / WebSocket 三种传输方式,'
                    'API 风格对齐 MobileIMSDK Android/iOS 官方版本。',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _ProtocolCard(
            icon: Icons.swap_horiz,
            color: Colors.blue,
            title: 'TCP',
            subtitle: '可靠长连接,适合移动网络与低功耗场景',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const TcpPage(),
              ),
            ),
          ),
          _ProtocolCard(
            icon: Icons.cell_tower,
            color: Colors.green,
            title: 'UDP',
            subtitle: '高实时性,支持单播/广播/组播(对齐 MobileIMSDK UDP 接口)',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const UdpPage(),
              ),
            ),
          ),
          _ProtocolCard(
            icon: Icons.public,
            color: Colors.purple,
            title: 'WebSocket',
            subtitle: 'Web 互通,支持文本/二进制与自动重连',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const WebSocketPage(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '提示:示例中的服务端配置与 MobileIMSDK 演示服务端保持一致,'
              '可参考仓库根目录 MobileIMSDK/demo_binary/Server/ 启动服务端。',
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtocolCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProtocolCard({
    Key? key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}
