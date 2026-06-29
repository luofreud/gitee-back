import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:freud/router/app_pages.dart';
import 'package:freud/service/fortune_service.dart';
import 'package:freud/service/im_service.dart';
import 'package:freud/service/notification_service.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/overlay_util.dart';
import 'package:get/get.dart';

import 'utils/theme_util.dart';

void main() {
  // 关键：设置允许的屏幕方向（仅竖屏）
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化完成
  if (kDebugMode) {
    runApp(const MyApp());
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // 仅允许竖屏（向上）
      // 可选：如需允许倒竖屏，可添加下面一行
      // DeviceOrientation.portraitDown,
    ]).then((_) {
      runApp(const MyApp());
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '问问星座',

      theme: ThemeUtil.lightThemeData(),
      darkTheme: ThemeUtil.darkThemeData(),
      themeMode: ThemeUtil.themeMode,
      // 启用GetX日志
      enableLog: kDebugMode ? true : false,
      // 日志输出
      logWriterCallback: (text, {bool isError = false}) => print(text),

      // 初始路由
      initialRoute: AppPages.INITIAL,
      // 初始绑定
      // initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      defaultTransition: Transition.rightToLeft,

      locale: const Locale('zh', 'CN'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'), // 中文简体
        // const Locale('en', 'US'), // 美国英语
      ],
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      //toast初始化
      onInit: () async {
        //初始化全局变量
        Get.put(UserService());
        Get.put(ImService());
        Get.put(FortuneService());
        Get.put(await NotificationService.init());
        //项目初始化进行配置
        ThemeUtil.init();
      },
    );
  }
}

//安卓悬浮窗入口
@pragma("vm:entry-point")
void overlayMain() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayUtil.overlayWidget(),
    ),
  );
}
