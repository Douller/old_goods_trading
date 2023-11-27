
import 'package:flutter/foundation.dart';

class Config {
  //服务器的host
  static String get hostUrl {
    return kDebugMode
        ? 'http://api.douller.com/'
        : 'http://api.douller.com/';
  }


  //支付的host
  static String get payHostUrl {
    return kReleaseMode
        ? 'https://mapi.yuansfer.com/'
        : 'https://mapi.yuansfer.com/';//'https://mapi.yuansfer.yunkeguan.com/';
  }

  /// http请求代理，例如localhost:8888
  static String get httpProxyClientHost => "";
}
