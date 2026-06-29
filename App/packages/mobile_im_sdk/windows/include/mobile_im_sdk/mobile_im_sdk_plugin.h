#ifndef FLUTTER_PLUGIN_MOBILE_IM_SDK_PLUGIN_H_
#define FLUTTER_PLUGIN_MOBILE_IM_SDK_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

namespace mobile_im_sdk {

/// MobileIMSDK Flutter 插件的 Windows 平台桩.
///
/// 通信实现全部在 Dart 层,Windows 端仅负责插件注册.
class MobileImSdkPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  MobileImSdkPlugin();

  virtual ~MobileImSdkPlugin();

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace mobile_im_sdk

#endif  // FLUTTER_PLUGIN_MOBILE_IM_SDK_PLUGIN_H_
