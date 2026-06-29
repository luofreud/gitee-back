// 集成测试辅助类(TCP echo 模拟服务端, 供 cross_component_test 使用).
//
// 这个文件刻意不依赖第三方库, 仅使用 dart:io / dart:async.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class MockTcpClient {
  MockTcpClient(this._socket);
  final Socket _socket;

  Future<void> send(List<int> data) async {
    _socket.add(data is Uint8List ? data : Uint8List.fromList(data));
    await _socket.flush();
  }
}

class MockTcpServer {
  MockTcpServer._(this.port, this._server, this._clients);

  final int port;
  final ServerSocket _server;
  final Set<MockTcpClient> _clients;

  static Future<MockTcpServer> start({
    required Future<void> Function(List<int> data, MockTcpClient peer) onFrame,
  }) async {
    final ServerSocket ss = await ServerSocket.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    final Set<MockTcpClient> clients = <MockTcpClient>{};
    ss.listen((Socket s) {
      final MockTcpClient peer = MockTcpClient(s);
      clients.add(peer);
      s.listen(
        (List<int> data) {
          // ignore: discarded_futures
          onFrame(data, peer);
        },
        onError: (_) {},
        onDone: () {
          clients.remove(peer);
        },
        cancelOnError: false,
      );
    });
    return MockTcpServer._(ss.port, ss, clients);
  }

  Future<void> killAll() async {
    for (final MockTcpClient c in List<MockTcpClient>.from(_clients)) {
      try {
        await c._socket.close();
      } catch (_) {}
    }
    _clients.clear();
  }

  Future<void> close() async {
    await killAll();
    await _server.close();
  }
}
