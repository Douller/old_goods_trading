import 'dart:io';

import 'package:flutter/services.dart';

class NativeChannel {
  static const MethodChannel loginChannel = MethodChannel('Authing');
  static const MethodChannel payChannel = MethodChannel('pay_plugin_channel');

  //登录
  static Future<String> getLoginUserInfoResult() async {
    String resultJson = await loginChannel.invokeMethod('login');
    return resultJson;
  }

  //支付宝或者微信
  static Future<dynamic> requestPayment({
    required int payStatus,
    required String orderSN,
    required String amount,
    required String token,
    required String merchantNo,
    required String storeNo,
    required String ipnUrl,
    required String description,
    required String customerNo,
    required String creditType,
  }) async {
    Map map = {
      "orderSN": orderSN,
      "amount": amount,
      "token": token,
      "merchantNo": merchantNo,
      "storeNo": storeNo,
      "ipnUrl": ipnUrl,
      "description": description,
      "customerNo": customerNo,
      "creditType": creditType,
    };
    dynamic result;
    if (payStatus == 0) {
      map['note'] = Platform.isIOS ? "ios微信支付" : "安卓微信支付";
      result = await payChannel.invokeMapMethod('weChat_pay', map);
    } else
    if (payStatus == 1) {
      map['note'] = Platform.isIOS ? "ios支付宝支付" : "安卓支付宝支付";
      result = await payChannel.invokeMapMethod('alipay_pay', map);
    } else if (payStatus == 2) {
      map['note'] = Platform.isIOS ? "iosDropInUI" : "安卓DropInUI";
      result = await payChannel.invokeMapMethod('dropIn_ui', map);
    }
    // else if (payStatus == 2) {
    //   result = await payChannel.invokeMapMethod('card_pay');
    // } else {
    //   result = await payChannel.invokeMapMethod('payPal_pay');
    // }
    return result;
  }
}
