import 'package:flutter_easyloading/flutter_easyloading.dart';

class ToastUtil {
  ToastUtil._() {}

  static final ToastUtil _instance = ToastUtil._();

  static const String SUCCESS = "SUCCESS";
  static const String ERROR = "ERROR";
  static const String WARNING = "WARNING";
  static const String INFO = "INFO";

  static final Duration _duration = Duration(milliseconds: 1500);

  static loading({
    String? msg,
    EasyLoadingMaskType maskType = EasyLoadingMaskType.clear,
  }) {
    EasyLoading.show(status: msg, maskType: maskType);
  }

  static progeress(double value, String msg) {
    EasyLoading.showProgress(value, status: msg);
  }

  static show(
    String msg, {
    String? type,
    Duration? duration,
    EasyLoadingToastPosition? toastPosition,
  }) {
    switch (type) {
      case ToastUtil.SUCCESS:
        EasyLoading.showSuccess(msg, duration: duration ?? _duration);
        break;
      case ToastUtil.ERROR:
        EasyLoading.showError(msg, duration: duration ?? _duration);
        break;
      case ToastUtil.WARNING:
        EasyLoading.showInfo(msg, duration: duration ?? _duration);
        break;
      case ToastUtil.INFO:
      default:
        EasyLoading.showToast(
          msg,
          duration: duration ?? _duration,
          toastPosition: toastPosition ?? EasyLoadingToastPosition.center,
        );
        break;
    }
  }

  static success(String msg, {Duration? duration}) {
    show(msg, type: SUCCESS, duration: duration);
  }

  static error(String msg, {Duration? duration}) {
    show(msg, type: ERROR, duration: duration);
  }

  static warning(String msg, {Duration? duration}) {
    show(msg, type: WARNING, duration: duration);
  }

  static info(
    String msg, {
    Duration? duration,
    EasyLoadingToastPosition? toastPosition,
  }) {
    show(msg, type: INFO, duration: duration, toastPosition: toastPosition);
  }

  static hide({bool animation = true}) {
    EasyLoading.dismiss(animation: animation);
  }
}
