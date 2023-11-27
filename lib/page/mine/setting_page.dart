import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/page/mine/my_info_page.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/states/user_info_state.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../utils/package_info.dart';
import '../login/change_password_page.dart';
import 'edit_user_info.dart';
import 'my_address_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final List<String> _settingList = [
    '编辑资料',
    '地址管理',
    '修改密码',
  ];
  String _version = '1.0.0';

  void _cellClick(int index) {
    switch (index) {
      case 0:
        AppRouter.push(context, const EditUserInfoPage());
        break;
      case 1:
        AppRouter.push(context, const MyAddressPage());
        break;
      case 2:
        AppRouter.push(context, const ChangePasswordPage());
        break;
      default:
        break;
    }
  }

  void _removeAccounts() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('注销账号'),
            content: const Text('注销账号后不可以再次登录，需要重新申请或者联系管理员，请谨慎操作'),
            actions: <Widget>[
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  _remove();
                },
                child: const Text('注销'),
              ),
              CupertinoDialogAction(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _loginOut() async {
    bool out =
        await Provider.of<UserInfoViewModel>(context, listen: false).loginOut();

    if (out) {
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      ToastUtils.showText(text: '退出登录失败');
    }
  }

  Future<void> _remove() async {
    bool out = await Provider.of<UserInfoViewModel>(context, listen: false)
        .removeUser();

    if (out) {
      if (mounted) {
        Navigator.popUntil(context, (route) {
          return route.isFirst;
        });
      }
    } else {
      ToastUtils.showText(text: '注销失败');
    }
  }

  Future<void> _getVersion() async {
    PackageInfo packageInfo = await PackageInfoUtils.instance.getPackageInfo;
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  void initState() {
    _getVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(title: const Text('设置')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _settingList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _cellClick(index),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Row(
                            children: [
                              Text(
                                _settingList[index],
                                style: const TextStyle(
                                    color: Color(0xff2F3033),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Expanded(child: Container()),
                              Image.asset(
                                '${Constants.iconsPath}right_arrow.png',
                                width: 10,
                                height: 10,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: ThemeText(
                  text: '当前版本 $_version',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              kDebugMode
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child:  ThemeText(
                        text:
                            '当前IOS测试版本 $_version ${Constants.iosDebugVersion} \n当前Android测试版本 $_version ${Constants.androidDebugVersion}',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Container(),
              GestureDetector(
                onTap: _loginOut,
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffFE734C),
                    borderRadius: BorderRadius.circular(44),
                  ),
                  child: const Text(
                    '退出登录',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _removeAccounts,
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(44),
                  ),
                  child: const Text(
                    '注销账号',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
