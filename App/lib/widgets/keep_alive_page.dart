import 'package:flutter/material.dart';

class KeepalivePage extends StatefulWidget {
  final Widget child;

  const KeepalivePage({super.key, required this.child});

  @override
  State<KeepalivePage> createState() => _KeepalivePageState();
}

class _KeepalivePageState extends State<KeepalivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
