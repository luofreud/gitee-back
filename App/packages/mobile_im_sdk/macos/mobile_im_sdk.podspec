Pod::Spec.new do |s|
  s.name             = 'mobile_im_sdk'
  s.version          = '1.0.0'
  s.summary          = 'MobileIMSDK 的 Flutter 插件,支持 TCP/UDP/WebSocket 三种传输方式.'
  s.description      = <<-DESC
                       统一的 IM 客户端接口,纯 Dart 实现,无原生依赖.
                       DESC
  s.homepage         = 'https://github.com/JackJiang2011/MobileIMSDK'
  s.license          = { :type => 'Apache-2.0' }
  s.author           = { 'MobileIMSDK' => 'noreply@52im.net' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform         = :osx, '10.14'
  s.swift_version    = '5.0'
end
