import 'package:flutter/material.dart';

import '../../constants/app_const.dart';

/// 列表过滤条件筛选框
/// 弹出的是一个全屏OverlayEntry界面，在触发组件的下边缘弹出内容框，底部显示遮罩层，触发组件到顶部显示为透明，点击内容部分以外的区域都会移除界面。
class ListFilterOverlay {
  static OverlayEntry? _overlayEntry;

  static VoidCallback? _onClose;

  ListFilterOverlay();

  /// 显示过滤条件
  static showFilterOverlay({
    required BuildContext context,
    required List<dynamic> values,
    String? value,
    void Function(String)? onTap,
    VoidCallback? onClose,
    EdgeInsetsGeometry? padding,
  }) {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    _onClose = onClose;

    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;

    var bodyWidget = Container(
      padding: padding ?? EdgeInsets.all(AppConst.PAGE_PADDING),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppConst.PAGE_BACKGROUND_COLOR,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: values.map((item) {
          bool isActive = item["key"] == value;
          return GestureDetector(
            onTap: () {
              closeFilterOverlay();
              onTap?.call(item["key"] == value ? '' : item["key"]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: isActive ? Color(0xffE3E9FF) : Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item["title"],
                style: TextStyle(
                  color: isActive ? Color(0xff4B65CC) : Color(0xff383838),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            closeFilterOverlay();
          },
          onPanStart: (details) {
            closeFilterOverlay();
          },
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: offset.dy + size.height,
                  child: Container(
                    height: double.infinity,
                    color: Colors.black.withAlpha(100),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          onPanStart: (details) {},
                          child: bodyWidget,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// 关闭过滤条件
  static closeFilterOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    _onClose?.call();
  }
}
