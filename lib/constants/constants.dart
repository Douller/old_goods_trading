import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../utils/sp_manager.dart';

import 'package:tim_ui_kit_push_plugin/model/appInfo.dart';


enum MinePageClickType {
  setting,
  collection,
  browsingHistory,
  coupon,
  bill,
  myOrder,
  afterSales,
  mySell,
  myPublish,
  supplierAfter,
  withdrawalCenter
}

class Constants {
  static const String version = '1.0.10';
  static const String iosDebugVersion = '(1)';
  static const String androidDebugVersion = '(1)';
  static const String tabImagePath = './assets/images/bottom_bar/';
  static const String iconsPath = './assets/images/icons/';
  static const String placeholderPath = './assets/images/placeholder/';

  static double screenHeight = MediaQueryData.fromWindow(window).size.height;
  static double screenWidth = MediaQueryData.fromWindow(window).size.width;
  static double statusBarH = MediaQueryData.fromWindow(window).padding.top;
  static double bottomPadding =
      MediaQueryData.fromWindow(window).padding.bottom;
  static double bottomBarH = 62;
  static double safeAreaH = screenHeight - statusBarH - bottomPadding;

  static const String searchRecordListKey = 'searchRecordList';
  static const String userTokenKey = 'userTokenKey';
  static const String loginInKey = 'loginInKey';
  static const String userInfoKey = 'userInfoKey';
  static const String addressDefaultKey = 'addressDefaultKey';

  // Mapbox api token
  static const String mapboxAccessToken = 'sk.eyJ1IjoiZG91bGxlciIsImEiOiJjbHIyaHd5MHYwNTl5MmlrOGlzZmF4eWkwIn0.9Hqq6SuYfHbgrrau6G59-w';

  // Max distance of nearby good (miles)
  static const double maxDistance = 100.0;

  //首页评分组件
  /*static String getStarIcon(num star) {
    if (star == 0) {
      return "${iconsPath}empty_star.png";
    } else if (star <= 0.5) {
      return "${iconsPath}star1.png";
    } else if (star <= 1 && star > 0.5) {
      return "${iconsPath}star2.png";
    } else if (star <= 1.5 && star > 1) {
      return "${iconsPath}star3.png";
    } else if (star <= 2 && star > 1.5) {
      return "${iconsPath}star4.png";
    } else if (star <= 2.5 && star > 2) {
      return "${iconsPath}empty_star.png";
    } else if (star <= 3 && star > 2.5) {
      return "${iconsPath}star6.png";
    } else if (star <= 3.5 && star > 3) {
      return "${iconsPath}star7.png";
    } else if (star <= 4 && star > 3.5) {
      return "${iconsPath}star8.png";
    } else if (star <= 4.6 && star > 4) {
      return "${iconsPath}star9.png";
    } else {
      return "${iconsPath}full_star.png";
    }
  }*/

  static bool isLogin() {
    String? uid = SharedPreferencesUtils.getLoginUid();
    if (uid != null && uid.isNotEmpty) {
      return true;
    }
    return false;
  }

  //推送  详情看文档
  static final PushAppInfo appInfo = PushAppInfo(
    google_buz_id: 7054, // Google FCM证书ID
    apple_buz_id: kDebugMode?15197: 15196, // Apple证书ID
  );
}
