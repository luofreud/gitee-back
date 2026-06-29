/// IO 平台传输层导出(Android / iOS / macOS / Windows / Linux).
///
/// 当 `dart.library.io` 可用时,替代 [transport_stub.dart].
library transport_io;

export 'frame_codec.dart';
export 'qos_daemon.dart';
export 'tcp/tcp_im_client.dart';
export 'udp/udp_im_client.dart';
export 'websocket/websocket_im_client.dart';
