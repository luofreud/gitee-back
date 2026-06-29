import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/service/user_service.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final isLoggedIn = Get.find<UserService>().isLogin;
    if (!isLoggedIn) {
      // 2. 如果未登录，重定向到登录页
      // 关键点：将原本要访问的 route 作为参数传递过去
      return RouteSettings(
        name: AppRoutes.LOGIN,
        arguments: {'targetRoute': route}, // 携带目标路由参数
      );
    }
    // 已登录，允许继续访问（返回 null）
    return null;
  }
}
