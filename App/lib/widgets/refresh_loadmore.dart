import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

class RefreshLoadmore extends StatefulWidget {
  final Widget? child;
  final Future<dynamic> Function()? onRefresh;
  final Future<dynamic> Function()? onLoad;
  final RefreshController? controller;
  final bool? headerSafeArea;
  final IndicatorPosition? headerPosition;

  const RefreshLoadmore({
    super.key,
    this.child,
    this.onRefresh,
    this.onLoad,
    this.controller,
    this.headerSafeArea,
    this.headerPosition,
  });

  @override
  State<RefreshLoadmore> createState() => _RefreshLoadmoreState();
}

class _RefreshLoadmoreState extends State<RefreshLoadmore> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    // 当控制器通知变化时，调用 setState 来重建UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: widget.controller?.controller,
      scrollController: widget.controller?.scrollController,
      // 刷新头样式（使用默认样式，可自定义）
      header: ClassicHeader(
        showMessage: false,
        showText: false,
        succeededIcon: SizedBox.shrink(),
        processedDuration: Duration.zero,
        safeArea: widget.headerSafeArea ?? true,
        position: widget.headerPosition ?? IndicatorPosition.above,
      ),
      footer: widget.controller?.noMore == true
          ? const NotLoadFooter()
          : ClassicFooter(
              showMessage: false,
              showText: false,
              succeededIcon: SizedBox.shrink(),
              noMoreIcon: SizedBox.shrink(),
              processedDuration: Duration.zero,
            ),
      onRefresh: widget.onRefresh,
      onLoad: widget.onLoad,
      child: widget.child,
    );
  }
}

class RefreshController extends ChangeNotifier {
  final EasyRefreshController controller;
  final ScrollController? scrollController;

  RefreshController({required this.controller, this.scrollController});

  bool noMore = false;

  void finishLoad([
    IndicatorResult result = IndicatorResult.success,
    bool force = false,
  ]) {
    controller.finishLoad(result, force);
    if (result == IndicatorResult.noMore) {
      noMore = true;
      notifyListeners();
    }
  }

  void resetFooter() {
    noMore = false;
    controller.resetFooter();
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController?.dispose();
    super.dispose();
  }
}
