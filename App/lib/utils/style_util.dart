import 'package:flutter/material.dart';

import 'theme_util.dart';

///组件抽取的公共类方法集合
///用于将组件的公共属性进行抽取统一样式
class StyleUtil {
  static BuildContext? _context;

  static StyleUtil of(BuildContext context) {
    _context = context;
    return StyleUtil();
  }

  ///获取输入框统一样式
  InputDecoration getInputDecoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      isDense: true,
      // enabledBorder: InputBorder.none,
      filled: true,
      fillColor: fillColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 0,
          style: BorderStyle.solid,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 0,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: ThemeUtil.primaryColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 30),
    ).copyWith(
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }
}
