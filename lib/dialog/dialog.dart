import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/dialog/widget/app_version_upgrade_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/version_model.dart';
import 'widget/order_botton_dialog.dart';


class DialogUtils {
  DialogUtils._();


  static Future<bool?> orderAfterCancelDialog(BuildContext context,String title) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return  OrderButtonDialog(title: title);
      },
    );
  }

  /// 请求版本更新
  static Future<void> showAppUpgradeDialog(
      BuildContext context, VersionModel versionModel) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return  AppVersionUpgradeDialog(versionModel: versionModel);
      },
    );
  }

  static Future<bool?> openSetting(BuildContext context) async {
    return await showCupertinoDialog<bool>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('授予权限'),
            content: const Text('请在您的手机设置页面打开位置权限，以便我们提供更好的服务'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('确认'),
                onPressed: () {
                  Navigator.pop(context,false);
                },
              ),
              // CupertinoDialogAction(
              //   child: const Text('设置'),
              //   onPressed: () {
              //     Navigator.pop(context,false);
              //
              //     openAppSettings();
              //   },
              // ),
            ],
          );
        });
  }
}
