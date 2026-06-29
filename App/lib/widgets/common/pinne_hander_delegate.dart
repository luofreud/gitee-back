import 'package:flutter/material.dart';

/// 自定义悬浮头部代理
class SimplePinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget child;

  SimplePinnedHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // 这里直接返回 child，pinned: true 会在上滑时固定在顶部
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SimplePinnedHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent ||
        oldDelegate.child != child;
  }
}
