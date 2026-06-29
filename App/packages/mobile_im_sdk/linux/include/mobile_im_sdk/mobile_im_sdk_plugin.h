#ifndef FLUTTER_PLUGIN_MOBILE_IM_SDK_PLUGIN_H_
#define FLUTTER_PLUGIN_MOBILE_IM_SDK_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

/// MobileIMSDK Flutter 插件的 Linux 平台桩.
///
/// 通信实现全部在 Dart 层,Linux 端仅负责插件注册.
typedef struct _MobileImSdkPlugin MobileImSdkPlugin;
typedef struct {
  GObjectClass parent_class;
} MobileImSdkPluginClass;

FLUTTER_PLUGIN_EXPORT GType mobile_im_sdk_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void mobile_im_sdk_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_MOBILE_IM_SDK_PLUGIN_H_
