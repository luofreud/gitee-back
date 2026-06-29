import 'package:flutter/material.dart';
import 'package:freud/widgets/gradient_button.dart';

import '../constants/app_const.dart';
import '../widgets/component/date_picker.dart';
import 'style_util.dart';

class DialogUtil {
  ///显示底部弹出框
  static Future<bool?> showModalBottom({
    required BuildContext context,
    String? title,
    AlignmentGeometry? titleAlignment,
    bool? enableDrag,
    Widget? child,
    WidgetBuilder? builder,
    Color? backgroundColor,
    Color? barrierColor,
    Color? titleColor,
    TextStyle? titleStyle,
    EdgeInsetsGeometry? padding,
    bool isDismissible = true,
    bool useSafeArea = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag ?? true,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConst.PAGE_PADDING),
          topRight: Radius.circular(AppConst.PAGE_PADDING),
        ),
      ),
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            padding: padding ?? const EdgeInsets.all(AppConst.PAGE_PADDING),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (title != null && title.isNotEmpty)
                    ? Align(
                        alignment: titleAlignment ?? Alignment.center,
                        child: Text(
                          title,
                          style:
                              titleStyle ??
                              TextStyle(
                                fontSize: 18,
                                color:
                                    titleColor ??
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      )
                    : SizedBox.shrink(),
                child ?? SizedBox.shrink(),
                builder != null ? builder(context) : SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 显示日期选择器
  /// initialDate 初始日期
  static Future<DateTime?> showDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    bool? showTime,
  }) async {
    return await showModalBottomSheet<DateTime?>(
      context: context,
      builder: (BuildContext context) {
        return DatePicker(initialDate: initialDate, showTime: showTime);
      },
    );
  }

  /// 确认弹出框组件
  ///
  /// 此函数用于在应用中显示一个确认对话框，对话框包含一个标题和可选的内容描述
  /// 用户可以选择取消或确认，对应的操作将通过[onCancel]和[onConfirm]回调函数执行
  ///
  /// Parameters:
  ///   context: 对话框显示的上下文，用于确定对话框在哪个屏幕上显示
  ///   title: 对话框的标题，用于告知用户对话框的主题或目的
  ///   content: 可选的对话框内容，用于提供更详细的说明或信息
  ///   onCancel: 可选的回调函数，当用户选择取消时执行
  ///   onConfirm: 可选的回调函数，当用户选择确认时执行
  ///
  /// Returns:
  ///   一个Future，用于获取用户是否确认了对话框。如果用户确认，返回true；如果取消或出现错误，返回false
  static Future<dynamic> showConfirmDialog({
    required BuildContext context,
    String? title,
    String? content,
    String? cancelText,
    bool? cancelShow = true,
    String? confirmText,
    Color? confirmColor,
    Color? confirmTextColor,
    Color? confirmDisabledTextColor,
    void Function(BuildContext context)? onCancel,
    void Function(BuildContext context)? onConfirm,
    Widget? child,
    WidgetBuilder? builder,
    DialogPosition? position = DialogPosition.bottom,
    bool isDismissible = true,
  }) {
    var buttons = [
      if (cancelShow == null || cancelShow == true)
        SizedBox(
          height: 42,
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
              backgroundColor: Color(0xffF5F7F9),
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              if (onCancel != null) {
                onCancel(context);
              } else {
                Navigator.of(context).pop(false);
              }
            },
            child: Text(
              cancelText ?? '取消',
              style: TextStyle(color: Color(0xff383838)),
            ),
          ),
        ),
      GradientButton(
        height: 42,
        width: double.infinity,
        foregroundColor: confirmTextColor,
        gradient: confirmColor != null
            ? LinearGradient(colors: [confirmColor, confirmColor])
            : null,
        onPressed: () {
          if (onConfirm != null) {
            onConfirm(context);
          } else {
            Navigator.of(context).pop(true);
          }
        },
        child: Text(confirmText ?? '确定'),
      ),
    ];
    Widget contentWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (position == DialogPosition.center && title != null)
          Text(title, style: TextStyle(fontSize: 16)),
        if (content != null && content.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        if (child != null) child,
        if (builder != null) builder(context),
        const SizedBox(height: 20),
        if (position == DialogPosition.bottom)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 15,
            children: buttons.map((item) => Expanded(child: item)).toList(),
          ),
        if (position == DialogPosition.center)
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            children: buttons.reversed.map((item) {
              return item;
            }).toList(),
          ),
      ],
    );
    if (position == DialogPosition.center) {
      return showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (_) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              constraints: BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffE8EEFF), Colors.white],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              child: contentWidget,
            ),
          );
        },
      );
    }
    return showModalBottom(
      context: context,
      title: title,
      enableDrag: false,
      isDismissible: isDismissible,
      builder: (context) {
        return contentWidget;
      },
    );
  }

  ///
  /// 弹出输入框
  static dynamic showInputDialog({
    required BuildContext context,
    required String title,
    String? subtitle,
    String? hintText,
    TextAlign? textAlign,
    String? initValue,
    TextInputType? keyboardType,
    void Function(BuildContext context)? onCancel,
    void Function(BuildContext context, String? value)? onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        var controller = TextEditingController(text: initValue);
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: 16),
            textAlign: textAlign ?? TextAlign.left,
          ),

          titlePadding: EdgeInsets.only(
            top: AppConst.PAGE_PADDING,
            left: AppConst.PAGE_PADDING,
            right: AppConst.PAGE_PADDING,
            bottom: 0,
          ),
          contentPadding: EdgeInsets.only(
            top: 5,
            left: AppConst.PAGE_PADDING,
            right: AppConst.PAGE_PADDING,
            bottom: 0,
          ),
          actionsPadding: EdgeInsets.all(AppConst.PAGE_PADDING),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              subtitle != null
                  ? Container(
                      alignment: textAlign == TextAlign.center
                          ? Alignment.center
                          : Alignment.centerLeft,
                      // child: LabelTextWidget(
                      //   subtitle ?? '',
                      //   style: TextStyle(fontSize: 14),
                      // ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 10),
              TextField(
                autofocus: true,
                controller: controller,
                decoration: StyleUtil.of(
                  context,
                ).getInputDecoration(hintText: hintText),
                keyboardType: keyboardType,
                onSubmitted: (value) {
                  if (onConfirm != null) {
                    onConfirm(context, value);
                  } else {
                    Navigator.of(context).pop(true);
                  }
                },
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Expanded(
                //   child: DefaultButton(
                //     onPressed: () {
                //       if (onCancel != null) {
                //         onCancel(context);
                //       } else {
                //         Navigator.of(context).pop(false);
                //       }
                //     },
                //     child: Text('取消'),
                //   ),
                // ),
                // const SizedBox(width: 15),
                // Expanded(
                //   child: PrimaryButton(
                //     onPressed: () {
                //       if (onConfirm != null) {
                //         String value = controller.text;
                //         onConfirm(context, value);
                //       } else {
                //         Navigator.of(context).pop(true);
                //       }
                //     },
                //     child: Text('确定'),
                //   ),
                // ),
              ],
            ),
          ],
        );
      },
    );
  }

  ///
  /// 弹出菜单选择对话框
  static Future<bool?> showMenuDialog({
    required BuildContext context,
    required List<DialogMenuItem> items,
    bool showCancel = true,
    bool autoClose = true,
    void Function(BuildContext context)? onCancel,
    Widget? header,
    Widget? footer,
  }) {
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), // 左上角圆角
          topRight: Radius.circular(10.0), // 右上角圆角
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null) header,
            ...items.asMap().entries.map((entry) {
              DialogMenuItem item = entry.value;
              int index = entry.key;
              ShapeBorder shape = Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.surface,
                  width: 1,
                ),
              );
              if (index == 0) {
                shape = RoundedRectangleBorder(
                  borderRadius: header == null
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(10.0), // 左上角圆角
                          topRight: Radius.circular(10.0), // 右上角圆角
                        )
                      : BorderRadius.zero,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                    width: 1,
                  ),
                );
              }
              return ListTile(
                title: Center(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color:
                          item.color ?? Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                shape: shape,
                onTap: () {
                  if (autoClose) {
                    Navigator.of(context).pop();
                  }
                  item.onTap(context);
                },
              );
            }),
            if (footer != null) footer,
            Container(height: 10, color: Theme.of(context).colorScheme.surface),
            showCancel
                ? ListTile(
                    title: const Center(child: Text('取消')),
                    onTap: () {
                      if (onCancel != null) {
                        onCancel(context);
                      } else {
                        Navigator.of(context).pop(false);
                      }
                    },
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  /// 弹出成功提示
  /// barrierDismissible 点击背景是否关闭弹窗 默认为false
  static Future<bool?> showSuccess({
    required BuildContext context,
    String? title,
    String? subtitle,
    bool? barrierDismissible,
  }) {
    return showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: barrierDismissible ?? false,
      builder: (context) {
        return Align(
          child: Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffE8EEFF), Colors.white],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 56),
                const SizedBox(height: 5),
                Text(title ?? '', style: TextStyle(fontSize: 16)),
                if (subtitle != null) const SizedBox(height: 5),
                if (subtitle != null)
                  Text(
                    subtitle ?? '',
                    style: TextStyle(fontSize: 14, color: Color(0xff808080)),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 20),
                GradientButton(
                  width: double.infinity,
                  height: 34,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('确认'),
                ),
                const SizedBox(height: 5),
              ],
            ),
            // child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

class DialogMenuItem {
  final String title;
  final Function(BuildContext context) onTap;
  final Color? color;

  DialogMenuItem({required this.title, required this.onTap, this.color});
}

enum DialogPosition { bottom, center }
