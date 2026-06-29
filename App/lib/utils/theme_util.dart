import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constants/app_const.dart';
import 'sp_util.dart';

class ThemeUtil {
  static ThemeMode themeMode = ThemeMode.light; //默认主题模式

  static Color primaryColor = AppConst.PRIMARY_COLOR;

  static const String _themeModeKey = "themeMode";

  static Future<void> init() async {
    themeMode = await _getSpThemeMode();
  }

  static Future<ThemeMode> _getSpThemeMode() async {
    var mode = await SpUtil.getStorage(_themeModeKey);
    switch (mode) {
      case 'ThemeMode.light':
        return ThemeMode.light;
        break;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
        break;
      case 'ThemeMode.system':
        return ThemeMode.system;
        break;
      default:
        return ThemeMode.system;
    }
  }

  ///获取当前使用的主题模式
  static Brightness currentTheme() {
    if (themeMode == ThemeMode.system) {
      //获取当前系统设置的模式
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness;
    }
    return themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
  }

  ///设置主题模式
  static setThemeMode(ThemeMode mode) async {
    await SpUtil.setStorage(_themeModeKey, mode.toString());
    themeMode = mode;
    // setBrightness();
    Get.changeThemeMode(mode);
  }

  ///设置顶部状态栏颜色
  static setBrightness({Brightness? mode}) {
    mode ??= currentTheme();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        //设置导航栏的背景颜色。这个属性主要适用于 Android 设备。
        systemNavigationBarColor: Colors.transparent,
        //const Color(0xFF000000),
        //设置导航栏上图标（如返回按钮等）的亮度。可以是 Brightness.light 或 Brightness.dark。
        //这个属性在 Android 设备上且 SDK 版本大于等于 O 时可用
        systemNavigationBarIconBrightness: mode == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        //设置状态栏上图标（如时间、电池电量等）的亮度
        statusBarIconBrightness: mode == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        //设置状态栏的亮度
        statusBarBrightness: mode,
      ),
    );
  }

  ///亮色主题
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: primaryColor,
    primary: primaryColor,
    primaryContainer: primaryColor,
    //主题颜色文字颜色
    onPrimary: Colors.white,
    //第二背景颜色
    secondary: Colors.white,
    //第二背景颜色文字颜色
    onSecondary: Color(0xff8294A8),
    //背景颜色
    surface: Color(0xffF5F7F9),
    //
    //背景颜色上面的文字颜色
    onSurface: Colors.black,
    //图标之类的颜色
    onSurfaceVariant: Colors.black87,
    surfaceContainerLowest: Colors.white,
    //弹窗窗口等颜色
    surfaceContainerLow: Colors.white,
    //错误颜色
    error: Colors.red,
    //错误颜色文字颜色
    onError: Colors.white,
    //边框颜色
    outline: Color(0xffe8ebf0),
  );

  static ThemeData lightThemeData() {
    var themeData = ThemeData(
      fontFamily: "SourceHanSansSC",
      useMaterial3: true,
      primaryColor: darkColorScheme.primary,
      colorScheme: lightColorScheme,
      //禁用颜色
      disabledColor: const Color(0xffF0F1F3),
      textTheme: const TextTheme(
        //用于辅助说明文本
        bodySmall: TextStyle(color: Color(0xff383838), fontSize: 13),
        bodyMedium: TextStyle(color: Color(0xff383838), fontSize: 14),
        bodyLarge: TextStyle(color: Color(0xff383838), fontSize: 16),
        labelSmall: TextStyle(
          color: Color(0xff8495AC),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelMedium: TextStyle(
          color: Color(0xff8495AC),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: Color(0xff8495AC),
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
      //文本框描述主题
      inputDecorationTheme: const InputDecorationTheme(
        //填充颜色
        fillColor: Color(0xffF1F4F9),
        //默认提示文本样式
        hintStyle: TextStyle(color: Color(0xff8495AC), fontSize: 14),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black87, // 设置光标颜色
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withAlpha(150),
      ), // 全局移除水波纹效果
    );

    return themeData.copyWith(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: themeData.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: themeData.textTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  ///暗黑主题
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: primaryColor,
    primary: primaryColor,
    primaryContainer: primaryColor,
    onPrimaryContainer: Colors.black87,

    onPrimary: Colors.white,
    secondary: Color(0xff1A1D22),
    onSecondary: Color(0xff8294A8),
    surface: Color(0xff13171A),
    //背景色上面的颜色 文字颜色
    onSurface: Colors.white,
    //图标之类的颜色
    onSurfaceVariant: Colors.white,
    surfaceContainerLowest: const Color(0xff1A1D22),
    //弹窗窗口等颜色
    surfaceContainerLow: const Color(0xff1A1D22),
    error: Colors.red,
    onError: Colors.white,
    outline: Color(0xff293238),
  );

  static ThemeData darkThemeData() {
    var themeData = ThemeData(
      fontFamily: "SourceHanSansSC",
      useMaterial3: true,
      colorScheme: darkColorScheme,
      primaryColor: darkColorScheme.primary,
      textTheme: const TextTheme(
        //用于辅助说明文本
        bodySmall: TextStyle(color: Color(0xfff1f4f9), fontSize: 13),
        bodyMedium: TextStyle(color: Color(0xfff1f4f9), fontSize: 14),
        bodyLarge: TextStyle(color: Color(0xfff1f4f9), fontSize: 16),
        labelSmall: TextStyle(
          color: Color(0xff8495AC),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelMedium: TextStyle(
          color: Color(0xff8495AC),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: Color(0xff8495AC),
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        //填充颜色
        fillColor: Color(0xff293038),
        //默认提示文本样式
        hintStyle: TextStyle(color: Color(0xff8495AC), fontSize: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xff8495AC),
      ),
    );
    return themeData.copyWith(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: themeData.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: themeData.textTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // static ColorScheme themeColor() {
  //   return currentTheme() == Brightness.light
  //       ? ColorScheme(
  //         brightness: Brightness.light,
  //         //主题颜色
  //         primary: primaryColor,
  //         //主题颜色文字颜色
  //         onPrimary: Colors.white,
  //         //第二背景颜色
  //         secondary: Colors.white,
  //         //第二背景颜色文字颜色
  //         onSecondary: Color(0xff8294A8),
  //         //二级容器背景颜色
  //         surface: Color(0xffF1F4F9),
  //         //二级容器背景颜色上面的文字颜色
  //         onSurface: Colors.black,
  //         //错误颜色
  //         error: Colors.red,
  //         //错误颜色文字颜色
  //         onError: Colors.white,
  //         //边框颜色
  //         outline: Color(0xffe8ebf0),
  //       )
  //       : ColorScheme(
  //         brightness: Brightness.dark,
  //         primary: primaryColor,
  //         onPrimary: Colors.white,
  //         secondary: Color(0xff1A1D22),
  //         onSecondary: Color(0xff8294A8),
  //         surface: Color(0xff13171A),
  //         onSurface: Colors.white,
  //         error: Colors.red,
  //         onError: Colors.white,
  //         outline: Color(0xff293238),
  //       );
  // }
}
