import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:old_goods_trading/utils/channel_push.dart';
import 'package:old_goods_trading/utils/sp_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tim_ui_kit_push_plugin/tim_ui_kit_push_plugin.dart';
import 'app.dart';
import 'constants/constants.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      /// 配置异常捕获
      Isolate.current.addErrorListener(
        RawReceivePort((dynamic pair) {
          var isolateError = pair as List<dynamic>;
          var error = isolateError.first;
          var stackTrace = isolateError.last;
          Zone.current.handleUncaughtError(error, stackTrace);
        }).sendPort,
      );

      FlutterError.onError = (details) {
        if (!kReleaseMode || details.stack == null) {
          FlutterError.presentError(details);
        } else {
          Zone.current.handleUncaughtError(details.exception, details.stack!);
        }
      };

      /// 如果在runApp之前你就需要执行某些操作，必须要让胶水类WidgetsFlutterBinding初始化先
      WidgetsFlutterBinding.ensureInitialized();
      // 这里打开后可以用Google FCM推送
      if (Platform.isAndroid) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      
      SystemChrome.setPreferredOrientations(
        const <DeviceOrientation>[
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      );

      if (Platform.isAndroid) {
        SystemUiOverlayStyle systemUiOverlayStyle =
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      SharedPreferencesUtils.spInit(prefs);

      SystemChannels.lifecycle.setMessageHandler((msg) async {
        debugPrint('SystemChannels> $msg');
        int? unreadCount = await _getTotalUnreadCount();
        if(msg == 'AppLifecycleState.inactive'){
          TIMUIKitCore.getInstance().setOfflinePushStatus(
              status: AppStatus.background, totalCount: unreadCount);
          if (unreadCount != null) {
            ChannelPush.setBadgeNum(unreadCount);
          }
        }else if(msg == 'AppLifecycleState.resumed'){
          TIMUIKitCore.getInstance().setOfflinePushStatus(status: AppStatus.foreground);
        }else if(msg == 'AppLifecycleState.paused'){
          TIMUIKitCore.getInstance().setOfflinePushStatus(
              status: AppStatus.background, totalCount: unreadCount);        }

      });

      runApp(const App());
    },
    (error, stackTrace) {
      FlutterError.presentError(
          FlutterErrorDetails(exception: error, stack: stackTrace));
    },
  );
}
Future<int?> _getTotalUnreadCount() async {
  final res = await TIMUIKitCore.getSDKInstance()
      .getConversationManager()
      .getTotalUnreadMessageCount();
  if (res.code == 0) {
    return res.data ?? 0;
  }
  return null;
}

