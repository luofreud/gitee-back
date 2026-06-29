#include "include/mobile_im_sdk/mobile_im_sdk_plugin.h"

#include <flutter_linux/flutter_linux.h>

struct _MobileImSdkPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(MobileImSdkPlugin, mobile_im_sdk_plugin, g_object_get_type())

static void mobile_im_sdk_plugin_init(MobileImSdkPlugin* self) {}

static void mobile_im_sdk_plugin_class_init(MobileImSdkPluginClass* klass) {}

static void method_call_cb(FlPluginRegistrar* registrar,
                            FlMethodChannel* channel,
                            FlMethodCall* method_call,
                            gpointer user_data) {
  fl_method_call_respond_not_implemented(method_call, nullptr);
}

void mobile_im_sdk_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  MobileImSdkPlugin* plugin = MOBILE_IM_SDK_PLUGIN(
      g_object_new(mobile_im_sdk_plugin_get_type(), nullptr));

  auto channel = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar),
      "mobile_im_sdk",
      FL_METHOD_CODEC(fl_standard_method_codec_new()));

  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin), g_object_unref);

  g_object_unref(plugin);
}
