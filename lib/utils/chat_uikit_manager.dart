import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/utils/sp_manager.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import '../im/GenerateUserSig.dart';
import '../model/user_info_model.dart';

class ChatUikitManager {
  static const int imAppId = 70000035;
  static const String imSecret =
      '3aafc32924a8ad364d2bc4099fffe01d3a4e31501331863a433fd09cb24cc572';

  static CoreServicesImpl coreInstance = TIMUIKitCore.getInstance();

  static Future<bool> initTIMUIKitSDK() async {
    ///初始化IM
    bool? res = await coreInstance.init(
      sdkAppID: imAppId,
      loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
      listener: getV2TimSDKListener(),
      onTUIKitCallbackListener: (TIMCallback callbackValue) {
        if (kDebugMode) {
          print(
            'IMErrorCode = ${callbackValue.errorCode} IMErrorCode = ${callbackValue.errorMsg}',
          );
        }
      },
    );
    if (res == true) {
      debugPrint('IM----------初始化IM SDK成功');
      setIMTheme();
      return true;
    } else {
      debugPrint('IM----------即时通信 SDK初始化失败');
      return false;
    }
  }

  static Future<void> setIMTheme() async {
    coreInstance.setTheme(
      theme: const TUITheme(
        chatMessageItemFromSelfBgColor: Color(0xFFFE734C),
        chatMessageItemFromOthersBgColor: Colors.white,
      ),
    );
  }

  ///登录IM
  static Future<bool> loginIM({UserInfoModel? userInfoModel}) async {
    userInfoModel ??= SharedPreferencesUtils.getUserInfoModel();

    if (userInfoModel == null) {
      debugPrint('暂未登录');
      return false;
    }

    String userSig = GenerateTestUserSig(sdkappid: imAppId, key: imSecret)
        .genSig(
            identifier: userInfoModel.id ?? '',
            expire: 24 * 7 * 60 * 60 * 1000);

    if ((userInfoModel.id ?? '').isEmpty || userSig.isEmpty) {
      debugPrint(
          "IM----------The running parameters are abnormal, please check");
      return false;
    }

    V2TimCallback res = await coreInstance.login(
        userID: userInfoModel.id ?? '', userSig: userSig);

    debugPrint('IM----------登录${res.desc}');
    if (res.code == 0) {
      V2TimUserFullInfo userFullInfo = V2TimUserFullInfo();
      userFullInfo.userID = userInfoModel.id;
      userFullInfo.nickName = userInfoModel.nickName;
      userFullInfo.faceUrl = userInfoModel.avatar;

      TIMUIKitCore.getInstance().setSelfInfo(userFullInfo: userFullInfo);
      return true;
    } else {
      return false;
    }
  }

  ///登出IM
  static Future<bool> logoutIM() async {
    V2TimCallback logoutRes = await TencentImSDKPlugin.v2TIMManager.logout();
    if (logoutRes.code == 0) {
      debugPrint("IM----------Log out to Tencent IM Success");
      return true;
    } else {
      debugPrint("IM----------Log out to Tencent IM Failed");
      return false;
    }
  }

  static V2TimSDKListener getV2TimSDKListener() {
    return V2TimSDKListener(
      onConnectFailed: (code, error) {
        if (kDebugMode) {
          print('IM----------连接失败 code =$code error =$error');
        }
      },
      onConnectSuccess: () {
        if (kDebugMode) {
          print('IM----------已经成功连接到腾讯云服务器');
        }
      },
      onConnecting: () {
        if (kDebugMode) {
          print('IM----------正在连接到腾讯云服务器');
        }
      },
      onKickedOffline: () {
        // 当前用户被踢下线，此时可以 UI 提示用户，并再次调用 V2TIMManager 的 login() 函数重新登录。
        if (kDebugMode) {
          print('IM----------当前用户被踢下线');
        }
      },
      onSelfInfoUpdated: (V2TimUserFullInfo info) {
        if (kDebugMode) {
          print('IM----------登录用户的资料发生了更新');
        }
      },
      onUserSigExpired: () {
        if (kDebugMode) {
          print(
              'IM----------在线时票据过期：此时您需要生成新的 userSig 并再次调用 V2TIMManager 的 login() 函数重新登录。');
        }
      },
      onUserStatusChanged: (List<V2TimUserStatus> userStatusList) {
        //用户状态变更通知
        //userStatusList 用户状态变化的用户列表
        //收到通知的情况：订阅过的用户发生了状态变更（包括在线状态和自定义状态），会触发该回调
        //在 IM 控制台打开了好友状态通知开关，即使未主动订阅，当好友状态发生变更时，也会触发该回调
        //同一个账号多设备登录，当其中一台设备修改了自定义状态，所有设备都会收到该回调
      },
    );
  }
}
