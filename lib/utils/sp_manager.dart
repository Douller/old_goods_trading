import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../model/order_buy_confirm_model.dart';
import '../model/user_info_model.dart';

class SharedPreferencesUtils {
  static SharedPreferences? _sp;

  static SharedPreferences get sp {
    return _sp!;
  }

  static spInit(SharedPreferences sp) {
    _sp = sp;
  }

  static String? getLoginUid() {
    return _sp?.getString(Constants.loginInKey);
  }

  static Future<bool> setLoginUid(String uid) async {
    return await _sp?.setString(Constants.loginInKey, uid) ?? false;
  }

  static List<String>? getSearchRecordList() {
    return _sp?.getStringList(Constants.searchRecordListKey);
  }

  static Future<bool> setSearchRecordList(List<String> recordList) async {
    return await _sp?.setStringList(
            Constants.searchRecordListKey, recordList) ??
        false;
  }

  static UserInfoModel? getUserInfoModel() {
    String key = Constants.userInfoKey + (getLoginUid() ?? '');
    String result = _sp!.getString(key) ?? "";
    if (result.isEmpty) {
      return null;
    }
    return UserInfoModel.fromJson(json.decode(result));
  }

  static void setUserInfoModel(UserInfoModel model) {
    String key = Constants.userInfoKey + (getLoginUid() ?? '');
    _sp!.setString(key, json.encode(model.toJson()));
  }

  // static AddressModelInfo? getAddressModel() {
  //   String key = Constants.addressDefaultKey;
  //   String result = _sp!.getString(key) ?? "";
  //   if (result.isEmpty) {
  //     return null;
  //   }
  //   return AddressModelInfo.fromJson(json.decode(result));
  // }
  //
  // static void setAddressModel(AddressModelInfo model) {
  //   String key = Constants.addressDefaultKey;
  //   _sp!.setString(key, json.encode(model.toJson()));
  // }

  static Future<bool>? remove(String key) {
    return _sp?.remove(key);
  }

//
// static Object? get(String key)  {
//   return _sp?.get(key);
// }
//
// static int? getInt(String key)  {
//   return _sp?.getInt(key);
// }
//
// static bool? getBool(String key)  {
//   return _sp?.getBool(key);
// }
//
// static String? getString(String key)  {
//   return _sp?.getString(key);
// }
//
// static List<String>? getStringList(String key)  {
//   return _sp?.getStringList(key);
// }
//
// static Future<bool>? setInt(String key, int value)  {
//   return _sp?.setInt(key, value);
// }
//
// static Future<bool>? setBool(String key, bool value)  {
//   return _sp?.setBool(key, value);
// }
//
// static Future<bool>? setString(String key, String value)  {
//   return _sp?.setString(key, value);
// }
//
// static Future<bool>? setStringList(String key, List<String> value)  {
//   return _sp?.setStringList(key, value);
// }
//
// static bool? containsKey(String key)  {
//   return _sp?.containsKey(key);
// }
//
// static Future<bool>? get clear  {
//   return _sp?.clear();
// }
}
