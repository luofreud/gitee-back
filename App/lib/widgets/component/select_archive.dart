import 'package:flutter/material.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/router/app_routes.dart';
import 'package:get/get.dart';

/// 档案选择组件
class SelectArchive extends StatelessWidget {
  final Color? backgroundColor;
  final String? placeholder;
  final Color? placeholderColor;
  final Archive? value;
  final ValueChanged<Archive>? onSelected;
  final Widget? trailing;

  const SelectArchive({
    super.key,
    this.backgroundColor,
    this.placeholder,
    this.placeholderColor,
    this.value,
    this.onSelected,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    Widget valueWidget = value != null
        ? Text(value!.name ?? '')
        : Text(
            placeholder ?? '请选择档案',
            style: TextStyle(color: placeholderColor ?? Color(0xffA8B2E6)),
          );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final result = await Get.toNamed(AppRoutes.ARCHIVE_SELECT);
          if (result != null) {
            onSelected?.call(result);
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: backgroundColor ?? Color(0xffF7F9FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(child: valueWidget),
              if (trailing != null) trailing!,
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
