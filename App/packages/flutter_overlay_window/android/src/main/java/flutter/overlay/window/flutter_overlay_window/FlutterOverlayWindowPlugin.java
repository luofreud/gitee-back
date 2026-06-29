package flutter.overlay.window.flutter_overlay_window;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.service.notification.StatusBarNotification;
import android.util.Log;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationManagerCompat;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import java.util.Map;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.FlutterEngineGroup;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.JSONMessageCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterOverlayWindowPlugin implements
        FlutterPlugin, ActivityAware, BasicMessageChannel.MessageHandler, MethodCallHandler,
        PluginRegistry.ActivityResultListener {

    private MethodChannel channel;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
    private Context context;
    private Activity mActivity;
    private BasicMessageChannel<Object> messenger;
    private BasicMessageChannel<Object> mainAppMessenger;
    private Result pendingResult;
    private boolean broadcastReceiverRegistered = false;
    final int REQUEST_CODE_FOR_OVERLAY_PERMISSION = 1248;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), OverlayConstants.CHANNEL_TAG);
        channel.setMethodCallHandler(this);

        // 初始化 EventChannel
        eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "x-slayer/overlay_event_channel");
        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                eventSink = events;
                Log.i("FlutterOverlay", "EventChannel listener attached");
            }

            @Override
            public void onCancel(Object arguments) {
                eventSink = null;
            }
        });

        // 注册 BroadcastReceiver 监听来自 overlay 的消息
        registerMainAppBroadcastReceiver();

        messenger = new BasicMessageChannel(flutterPluginBinding.getBinaryMessenger(), OverlayConstants.MESSENGER_TAG,
                JSONMessageCodec.INSTANCE);
        messenger.setMessageHandler(this);

        mainAppMessenger = new BasicMessageChannel(flutterPluginBinding.getBinaryMessenger(), OverlayConstants.MAIN_APP_MESSENGER_TAG,
                JSONMessageCodec.INSTANCE);
        
        // mainAppMessenger 的消息处理器在 onAttachedToActivity 中设置

        WindowSetup.messenger = messenger;
        WindowSetup.messenger.setMessageHandler(this);
    }
    
    private void registerMainAppBroadcastReceiver() {
        try {
            android.content.BroadcastReceiver receiver = new android.content.BroadcastReceiver() {
                @Override
                public void onReceive(android.content.Context context, Intent intent) {
                    String message = intent.getStringExtra("message");
                    if (message != null) {
                        Log.i("FlutterOverlay", "Received broadcast from overlay: " + message);
                        if (eventSink != null) {
                            eventSink.success(message);
                            Log.i("FlutterOverlay", "Message forwarded via EventChannel");
                        } else {
                            Log.w("FlutterOverlay", "eventSink is null, cannot forward message");
                        }
                    }
                }
            };
            
            android.content.IntentFilter filter = new android.content.IntentFilter("flutter_overlay_to_main");
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                context.registerReceiver(receiver, filter, android.content.Context.RECEIVER_EXPORTED);
            } else {
                context.registerReceiver(receiver, filter);
            }
            Log.i("FlutterOverlay", "Main app BroadcastReceiver registered");
        } catch (Exception e) {
            Log.e("FlutterOverlayWindow", "Error registering main app receiver: " + e.getMessage());
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        pendingResult = result;
        if (call.method.equals("checkPermission")) {
            result.success(checkOverlayPermission());
        } else if (call.method.equals("requestPermission")) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
                intent.setData(Uri.parse("package:" + mActivity.getPackageName()));
                mActivity.startActivityForResult(intent, REQUEST_CODE_FOR_OVERLAY_PERMISSION);
            } else {
                result.success(true);
            }
        } else if (call.method.equals("showOverlay")) {
            if (!checkOverlayPermission()) {
                result.error("PERMISSION", "overlay permission is not enabled", null);
                return;
            }
            Integer height = call.argument("height");
            Integer width = call.argument("width");
            String alignment = call.argument("alignment");
            String flag = call.argument("flag");
            String overlayTitle = call.argument("overlayTitle");
            String overlayContent = call.argument("overlayContent");
            String notificationVisibility = call.argument("notificationVisibility");
            boolean enableDrag = call.argument("enableDrag");
            String positionGravity = call.argument("positionGravity");
            Map<String, Integer> startPosition = call.argument("startPosition");
            int startX = startPosition != null ? startPosition.getOrDefault("x", OverlayConstants.DEFAULT_XY) : OverlayConstants.DEFAULT_XY;
            int startY = startPosition != null ? startPosition.getOrDefault("y", OverlayConstants.DEFAULT_XY) : OverlayConstants.DEFAULT_XY;
            Object enableSoundObj = call.argument("enableSound");
            Boolean enableSound = enableSoundObj != null ? (Boolean) enableSoundObj : Boolean.TRUE;
            
            Log.i("FlutterOverlay", "enableSoundObj: " + enableSoundObj + ", enableSound: " + enableSound);


            WindowSetup.width = width != null ? width : -1;
            WindowSetup.height = height != null ? height : -1;
            WindowSetup.enableDrag = enableDrag;
            WindowSetup.setGravityFromAlignment(alignment != null ? alignment : "center");
            WindowSetup.setFlag(flag != null ? flag : "flagNotFocusable");
            WindowSetup.overlayTitle = overlayTitle;
            WindowSetup.overlayContent = overlayContent == null ? "" : overlayContent;
            WindowSetup.positionGravity = positionGravity;
            WindowSetup.setNotificationVisibility(notificationVisibility);
            WindowSetup.enableSound = enableSound;
            Log.i("FlutterOverlay", "WindowSetup.enableSound: " + WindowSetup.enableSound);

            final Intent intent = new Intent(context, OverlayService.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            intent.putExtra("startX", startX);
            intent.putExtra("startY", startY);
            context.startService(intent);
            result.success(null);
        } else if (call.method.equals("isOverlayActive")) {
            result.success(OverlayService.isRunning);
            return;
        } else if (call.method.equals("isOverlayActive")) {
            result.success(OverlayService.isRunning);
            return;
        } else if (call.method.equals("moveOverlay")) {
            int x = call.argument("x");
            int y = call.argument("y");
            result.success(OverlayService.moveOverlay(x, y));
        } else if (call.method.equals("getOverlayPosition")) {
            result.success(OverlayService.getCurrentPosition());
        } else if (call.method.equals("openApp")) {
            Object arguments = call.argument("arguments");
            result.success(openApp(arguments));
        } else if (call.method.equals("sendToMainApp")) {
            Object data = call.argument("data");
            result.success(sendToMainApp(data));
        } else if (call.method.equals("onOverlayMessage")) {
            // 这是一个来自 Android 广播的消息，转发给 Dart 层
            // 这个方法由 BroadcastReceiver 调用
        } else if (call.method.equals("getOverlayMessage")) {
            result.success(getOverlayMessage());
        } else if (call.method.equals("registerMessageListener")) {
            // 注册广播接收器
            registerBroadcastReceiver();
            result.success(true);
        } else if (call.method.equals("closeOverlay")) {
            if (OverlayService.isRunning) {
                final Intent i = new Intent(context, OverlayService.class);
                context.stopService(i);
                result.success(true);
            }
            return;
        } else {
            result.notImplemented();
        }

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        WindowSetup.messenger.setMessageHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
        binding.addActivityResultListener(this);
        if (FlutterEngineCache.getInstance().get(OverlayConstants.CACHED_TAG) == null) {
            FlutterEngineGroup enn = new FlutterEngineGroup(context);
            DartExecutor.DartEntrypoint dEntry = new DartExecutor.DartEntrypoint(
                    FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                    "overlayMain");
            FlutterEngine engine = enn.createAndRunEngine(context, dEntry);
            FlutterEngineCache.getInstance().put(OverlayConstants.CACHED_TAG, engine);
        }
        
        // 设置 mainAppMessenger 的消息处理器，转发消息给主应用
        if (mainAppMessenger != null) {
            mainAppMessenger.setMessageHandler(new BasicMessageChannel.MessageHandler() {
                @Override
                public void onMessage(Object message, BasicMessageChannel.Reply reply) {
                    Log.i("FlutterOverlay", "Received message from overlay: " + message);
                    
                    // 通过主应用的 FlutterEngine 发送消息
                    FlutterEngine mainEngine = FlutterEngineCache.getInstance().get(OverlayConstants.CACHED_TAG);
                    if (mainEngine != null) {
                        BasicMessageChannel mainChannel = new BasicMessageChannel(
                                mainEngine.getDartExecutor(),
                                OverlayConstants.MAIN_APP_MESSENGER_TAG,
                                JSONMessageCodec.INSTANCE);
                        mainChannel.send(message);
                        Log.i("FlutterOverlay", "Message forwarded to main app");
                    } else {
                        Log.i("FlutterOverlay", "Main engine is null, cannot forward");
                    }
                    reply.reply(null);
                }
            });
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.mActivity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        this.mActivity = null;
    }

    @Override
    public void onMessage(@Nullable Object message, @NonNull BasicMessageChannel.Reply reply) {
        BasicMessageChannel overlayMessageChannel = new BasicMessageChannel(
                FlutterEngineCache.getInstance().get(OverlayConstants.CACHED_TAG)
                        .getDartExecutor(),
                OverlayConstants.MESSENGER_TAG, JSONMessageCodec.INSTANCE);
        overlayMessageChannel.send(message, reply);
    }

    private boolean checkOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return Settings.canDrawOverlays(context);
        }
        return true;
    }

    private boolean openApp(Object arguments) {
        try {
            Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
            if (launchIntent == null) {
                return false;
            }
            
            if (arguments != null) {
                if (arguments instanceof String) {
                    launchIntent.putExtra("route_name", (String) arguments);
                } else if (arguments instanceof Map) {
                    launchIntent.putExtra("route_arguments", new android.os.Bundle());
                    // Map 类型的处理需要转换
                    for (Object key : ((Map) arguments).keySet()) {
                        Object value = ((Map) arguments).get(key);
                        if (value instanceof String) {
                            launchIntent.putExtra((String) key, (String) value);
                        } else if (value instanceof Integer) {
                            launchIntent.putExtra((String) key, (Integer) value);
                        } else if (value instanceof Boolean) {
                            launchIntent.putExtra((String) key, (Boolean) value);
                        }
                    }
                }
            }
            
            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(launchIntent);
            return true;
        } catch (Exception e) {
            Log.e("FlutterOverlayWindow", "Error opening app: " + e.getMessage());
            return false;
        }
    }

    private boolean sendToMainApp(Object data) {
        try {
            Log.i("FlutterOverlay", "sendToMainApp called with data: " + data);
            
            // 将消息转为字符串
            String jsonData = data instanceof String ? (String) data : data.toString();
            
            // 尝试通过 EventChannel 发送（仅在主应用进程中有效）
            if (eventSink != null) {
                eventSink.success(jsonData);
                Log.i("FlutterOverlay", "Message sent via EventChannel");
            } else {
                Log.w("FlutterOverlay", "EventSink is null, using broadcast to main app");
                
                // 使用广播发送到主应用
                String packageName = context.getPackageName();
                Intent broadcastIntent = new Intent("flutter_overlay_to_main");
                broadcastIntent.setPackage(packageName);
                broadcastIntent.putExtra("message", jsonData);
                context.sendBroadcast(broadcastIntent);
                Log.i("FlutterOverlay", "Broadcast sent to: " + packageName);
            }
            
            // 写入 SharedPreferences（主应用可以读取）
            android.content.SharedPreferences prefs = context.getSharedPreferences("overlay_messages", context.MODE_PRIVATE);
            android.content.SharedPreferences.Editor editor = prefs.edit();
            editor.putString("last_message", jsonData);
            editor.putLong("last_message_time", System.currentTimeMillis());
            editor.apply();
            
            return true;
        } catch (Exception e) {
            Log.e("FlutterOverlayWindow", "Error sending to main app: " + e.getMessage());
            return false;
        }
    }

    private String getOverlayMessage() {
        try {
            android.content.SharedPreferences prefs = context.getSharedPreferences("overlay_messages", context.MODE_PRIVATE);
            String message = prefs.getString("last_message", null);
            long timestamp = prefs.getLong("last_message_time", 0);
            
            // 如果消息超过 5 秒，清除它
            if (timestamp > 0 && System.currentTimeMillis() - timestamp > 5000) {
                prefs.edit().remove("last_message").remove("last_message_time").apply();
                return null;
            }
            
            // 读取后清除
            if (message != null) {
                prefs.edit().remove("last_message").remove("last_message_time").apply();
            }
            
            return message;
        } catch (Exception e) {
            Log.e("FlutterOverlayWindow", "Error getting overlay message: " + e.getMessage());
            return null;
        }
    }
    
    private void registerBroadcastReceiver() {
        // 防止重复注册
        if (broadcastReceiverRegistered) {
            Log.i("FlutterOverlay", "BroadcastReceiver already registered, skipping");
            return;
        }
        
        try {
            android.content.BroadcastReceiver receiver = new android.content.BroadcastReceiver() {
                @Override
                public void onReceive(android.content.Context context, Intent intent) {
                    String message = intent.getStringExtra("message");
                    if (message != null) {
                        Log.i("FlutterOverlay", "Broadcast received: " + message + ", eventSink: " + (eventSink != null));
                        // 通过 EventChannel 通知 Dart 层
                        if (eventSink != null) {
                            eventSink.success(message);
                        }
                    }
                }
            };
            
            android.content.IntentFilter filter = new android.content.IntentFilter("flutter_overlay_message");
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                context.registerReceiver(receiver, filter, android.content.Context.RECEIVER_EXPORTED);
            } else {
                context.registerReceiver(receiver, filter);
            }
            broadcastReceiverRegistered = true;
            Log.i("FlutterOverlay", "BroadcastReceiver registered");
        } catch (Exception e) {
            Log.e("FlutterOverlayWindow", "Error registering receiver: " + e.getMessage());
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE_FOR_OVERLAY_PERMISSION) {
            pendingResult.success(checkOverlayPermission());
            return true;
        }
        return false;
    }

}
