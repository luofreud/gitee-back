import 'dart:async';

import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkMonitor {
  NetworkMonitor._();

  static final NetworkMonitor _instance = NetworkMonitor._();
  static NetworkMonitor get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _sub;

  void Function()? onNetworkLost;
  void Function()? onNetworkRestored;

  bool _wasDisconnected = false;

  void start() {
    if (!_hasBinding()) return;
    _sub?.cancel();
    _wasDisconnected = false;
    _sub = _connectivity.onConnectivityChanged.listen(_onChanged);
  }

  void stop() {
    final sub = _sub;
    _sub = null;
    sub?.cancel();
  }

  static bool _hasBinding() {
    try {
      ServicesBinding.instance;
      return true;
    } catch (_) {
      return false;
    }
  }

  void _onChanged(List<ConnectivityResult> results) {
    final bool hasConnection = results.isNotEmpty &&
        !results.contains(ConnectivityResult.none);

    if (_wasDisconnected && hasConnection) {
      _wasDisconnected = false;
      onNetworkRestored?.call();
    } else if (!_wasDisconnected && !hasConnection) {
      _wasDisconnected = true;
      onNetworkLost?.call();
    }
  }
}
