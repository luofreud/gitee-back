#include "include/mobile_im_sdk/mobile_im_sdk_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

namespace mobile_im_sdk {

void MobileImSdkPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      registrar->messenger(), "mobile_im_sdk",
      &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<MobileImSdkPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

MobileImSdkPlugin::MobileImSdkPlugin() {}

MobileImSdkPlugin::~MobileImSdkPlugin() {}

void MobileImSdkPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  result->NotImplemented();
}

}  // namespace mobile_im_sdk
