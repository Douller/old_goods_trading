import 'dart:math';

import 'package:flutter/foundation.dart';

/// 正则工具类
class RegexUtils {
  RegexUtils._();

  /// 简单的匹配手机号码
  static const String regexMobileSimple = '^[1]\\d{10}\$';

  /// 精确匹配国内三大运营商正则表达式。
  /// 中国移动: 134(0-8), 135, 136, 137, 138, 139, 147, 150, 151, 152, 157, 158, 159, 165, 172, 178, 182, 183, 184, 187, 188, 195, 198
  /// 中国联通: 130, 131, 132, 145, 155, 156, 166, 167, 171, 175, 176, 185, 186
  /// 中国电信: 133, 153, 162, 173, 177, 180, 181, 189, 199, 191
  /// global star: 1349</p>
  /// 虚拟运营商: 170</p>
  static const String regexMobileExact =
      '^((13[0-9])|(14[57])|(15[0-35-9])|(16[2567])|(17[01235-8])|(18[0-9])|(19[1589]))\\d{8}\$';

  /// 座机匹配
  static const String regexTel = '^0\\d{2,3}[-]?\\d{7,8}';

  /// 15位的中国身份证
  static const String regexIdCard15 =
      '^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}\$';

  /// 15位的中国身份证
  static const String regexIdCard18 =
      '^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9Xx])\$';

  /// 邮箱匹配
  static const String regexEmail =
      '^\\w+([-+]\\w+)*@\\w+([-]\\w+)*\\\\w+([-]\\w+)*\$';

  /// url
  static const String regexUrl = '[a-zA-Z]+://[^\\s]*';

  /// 中文字符
  static const String regexZh = '[\\u4e00-\\u9fa5]';

  /// 匹配yyyy-MM-dd的日期
  static const String regexDate =
      '^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)\$';

  /// ip地址
  static const String regexIp =
      '((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)';

  /// 必须包含字母和数字, 6~18
  static const String regexUsername =
      '^(?![0-9]+\$)(?![a-zA-Z]+\$)[0-9A-Za-z]{6,18}\$';

  /// 必须包含字母和数字,可包含特殊字符 6~18
  static const String regexUsername2 =
      '^(?![0-9]+\$)(?![a-zA-Z]+\$)[0-9A-Za-z\\W]{6,18}\$';

  /// 必须包含字母和数字和殊字符, 6~18
  static const String regexUsername3 =
      '^(?![0-9]+\$)(?![a-zA-Z]+\$)(?![0-9a-zA-Z]+\$)(?![0-9\\W]+\$)(?![a-zA-Z\\W]+\$)[0-9A-Za-z\\W]{6,18}\$';

  /// qq号码
  static const String regexQQ = '[1-9][0-9]{4,}';

  /// 中国邮政编码
  static const String regexChinaPostalCode = "[1-9]\\d{5}(?!\\d)";

  /// 护照编码
  static const String regexPassport =
      r'(^[EeKkGgDdSsPpHh]\d{8}$)|(^(([Ee][a-fA-F])|([DdSsPp][Ee])|([Kk][Jj])|([Mm][Aa])|(1[45]))\d{7}$)';

  /// 缓存cityMap,用来计算对应身份证号的地区
  static const Map<String, String> _cityMap = {
    '11': '北京',
    '12': '天津',
    '13': '河北',
    '14': '山西',
    '15': '内蒙古',
    '21': '辽宁',
    '22': '吉林',
    '23': '黑龙江',
    '31': '上海',
    '32': '江苏',
    '33': '浙江',
    '34': '安徽',
    '35': '福建',
    '36': '江西',
    '37': '山东',
    '41': '河南',
    '42': '湖北',
    '43': '湖南',
    '44': '广东',
    '45': '广西',
    '46': '海南',
    '50': '重庆',
    '51': '四川',
    '52': '贵州',
    '53': '云南',
    '54': '西藏',
    '61': '陕西',
    '62': '甘肃',
    '63': '青海',
    '64': '宁夏',
    '65': '新疆',
    '71': '台湾老',
    '81': '香港',
    '82': '澳门',
    '83': '台湾新',
    '91': '国外',
  };

  /// 简单判断手机号码
  static bool isMobileSimple(String input) => matches(regexMobileSimple, input);

  /// 准确的手机号码判断
  static bool isMobileExact(String input) => matches(regexMobileExact, input);

  /// 座机
  static bool isTel(String input) => matches(regexTel, input);

  /// 是否是身份证号码
  static bool isIDCard(String input) {
    switch (input.length) {
      case 15:
        return isIDCard15(input);
      case 18:
        return isIDCard18Exact(input);
      default:
        return false;
    }
  }

  /// 18位
  static bool isIDCard15(String input) => matches(regexIdCard15, input);

  /// 18位身份证号
  static bool isIDCard18(String input) => matches(regexIdCard18, input);

  /// 准确的判断身份证号
  static bool isIDCard18Exact(String input) {
    if (isIDCard18(input)) {
      const List<int> factor = [
        7,
        9,
        10,
        5,
        8,
        4,
        2,
        1,
        6,
        3,
        7,
        9,
        10,
        5,
        8,
        4,
        2
      ];
      const List<String> suffix = [
        '1',
        '0',
        'X',
        '9',
        '8',
        '7',
        '6',
        '5',
        '4',
        '3',
        '2'
      ];
      if (_cityMap[input.substring(0, 2)] != null) {
        int weightSum = 0;
        for (int i = 0; i < 17; ++i) {
          weightSum += (input.codeUnitAt(i) - '0'.codeUnitAt(0)) * factor[i];
        }
        final int idCardMod = weightSum % 11;
        String idCardLast = String.fromCharCode(input.codeUnitAt(17));
        return idCardLast == suffix[idCardMod];
      }
    }
    return false;
  }

  /// 匹配邮箱
  static bool isEmail(String input) => matches(regexEmail, input);

  /// 是否url地址
  static bool isURL(String input) => matches(regexUrl, input);

  /// 中文字符判断
  static bool isZh(String input) => '〇' == input || matches(regexZh, input);

  /// 是否yyyy-MM-dd格式日期
  static bool isDate(String input) => matches(regexDate, input);

  /// 判断是否是ip地址
  static bool isIP(String input) => matches(regexIp, input);

  /// 判断是否合格的账户
  static bool isUserName(String input, {String regex = regexUsername}) =>
      matches(regex, input);

  /// 是否qq号码
  static bool isQQ(String input) => matches(regexQQ, input);

  /// 判断是否护照
  static bool isPassport(String input) => matches(regexPassport, input);

  /// 判断匹配
  static bool matches(String regex, String input) {
    if (input.isEmpty) return false;
    return RegExp(regex).hasMatch(input);
  }

  static int compare(String str1, String str2) {
    List<String> strInt1 = str1.trim().split(".");
    List<String> strInt2 = str2.trim().split(".");
    int maxLen = max(strInt1.length, strInt2.length);
    for (var i = 0; i < maxLen; i++) {
      int a = 0;
      int b = 0;
      if (i < strInt1.length) {
        a = int.tryParse(strInt1[i])!;
      }
      if (i < strInt2.length) {
        b = int.tryParse(strInt2[i])!;
      }
      if (a > b) {
        if (kDebugMode) {
          print("比对结果  1");
        }
        return 1;
      } else if (a == b) {
        continue;
      } else {
        if (kDebugMode) {
          print("比对结果  -1");
        }
        return -1;
      }
    }
    if (kDebugMode) {
      print("比对结果  0");
    }
    return 0;
  }
}
