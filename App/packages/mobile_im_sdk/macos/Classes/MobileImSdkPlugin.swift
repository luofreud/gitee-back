import Flutter
import Cocoa

/// MobileIMSDK Flutter 插件的 macOS 平台桩.
///
/// 通信实现全部在 Dart 层,macOS 端仅负责插件注册.
public class MobileImSdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "mobile_im_sdk",
            binaryMessenger: registrar.messenger())
        let instance = MobileImSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
}
