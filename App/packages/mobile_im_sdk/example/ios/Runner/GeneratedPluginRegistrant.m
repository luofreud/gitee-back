//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<connectivity_plus/ConnectivityPlusPlugin.h>)
#import <connectivity_plus/ConnectivityPlusPlugin.h>
#else
@import connectivity_plus;
#endif

#if __has_include(<mobile_im_sdk/MobileImSdkPlugin.h>)
#import <mobile_im_sdk/MobileImSdkPlugin.h>
#else
@import mobile_im_sdk;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [ConnectivityPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"ConnectivityPlusPlugin"]];
  [MobileImSdkPlugin registerWithRegistrar:[registry registrarForPlugin:@"MobileImSdkPlugin"]];
}

@end
