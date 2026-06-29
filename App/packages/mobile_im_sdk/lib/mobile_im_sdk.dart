/// MobileIMSDK 的 Flutter 客户端实现.
///
/// ```dart
/// import 'package:mobile_im_sdk/mobile_im_sdk.dart';
/// ```
///
/// 支持平台: Android / iOS / macOS / Windows / Linux (全功能 TCP+UDP+WebSocket)
/// Web 平台仅支持插件注册,暂不支持 TCP/UDP 连接.
library mobile_im_sdk;

export 'src/core/connection_type.dart';
export 'src/core/error_code.dart';
export 'src/core/im_client.dart';
export 'src/core/im_config.dart';
export 'src/core/im_event.dart';
export 'src/core/im_factory.dart';
export 'src/core/im_message.dart';
export 'src/core/p_error_response.dart';
export 'src/core/p_kickout_info.dart';
export 'src/core/p_login_info.dart';
export 'src/core/p_login_info_response.dart';
export 'src/core/protocal_factory.dart';
export 'src/core/sense_mode.dart';
export 'src/core/user_type_u.dart';
export 'src/utils/byte_utils.dart';
export 'src/utils/fingerprint.dart';
export 'src/utils/im_logger.dart';

// 传输层:IO 平台导出 TCP/UDP/WS;Web 平台无原生传输能力
export 'src/transport/transport_web.dart'
    if (dart.library.io) 'src/transport/transport_io.dart';
