import 'package:package_info_plus/package_info_plus.dart';

export 'package:package_info_plus/package_info_plus.dart';

class PackageInfoUtils {
  /// app包信息
  PackageInfo? _appPackageInfo;

  /// 工厂模式
  factory PackageInfoUtils() => _getInstance();

  /// 单例
  static PackageInfoUtils get instance => _getInstance();
  static PackageInfoUtils? _instance;

  PackageInfoUtils._internal();

  static PackageInfoUtils _getInstance() => _instance ??= PackageInfoUtils._internal();

  /// 获取app buildConfig信息
  Future<PackageInfo> get getPackageInfo async => _appPackageInfo ??= await PackageInfo.fromPlatform();
}
