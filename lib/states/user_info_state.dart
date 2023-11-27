import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/page/mine/my_coupon_page.dart';
import 'package:old_goods_trading/page/mine/withdrawal_center_page.dart';
import 'package:old_goods_trading/utils/sp_manager.dart';
import 'package:old_goods_trading/utils/toast.dart';
import '../MethodChannel/native_channel.dart';
import '../constants/constants.dart';
import '../model/user_center_model.dart';
import '../model/user_info_model.dart';
import '../page/mine/after_sales_page.dart';
import '../page/mine/collection_browsing_record.dart';
import '../page/mine/my_after_page.dart';
import '../page/mine/my_order_page.dart';
import '../page/mine/my_publish_page.dart';
import '../page/mine/my_sell_page.dart';
import '../page/mine/my_wallet_page.dart';
import '../page/mine/setting_page.dart';
import '../router/app_router.dart';
import '../utils/chat_uikit_manager.dart';

class UserInfoViewModel with ChangeNotifier {
  UserInfoModel? _userInfoModel;

  UserInfoModel? get userInfoModel =>
      _userInfoModel ?? SharedPreferencesUtils.getUserInfoModel();

  set userInfoModel(UserInfoModel? value) {
    _userInfoModel = value;
    notifyListeners();
  }

  UserCenterModel? _centerModel;

  UserCenterModel? get centerModel => _centerModel;

  set centerModel(UserCenterModel? value) {
    _centerModel = value;
    notifyListeners();
  }

  Future<bool> login() async {
    String resJson = await NativeChannel.getLoginUserInfoResult();
    ToastUtils.showLoading();
    Map dataInfo = json.decode(resJson);
    String token = Platform.isIOS ? dataInfo['token'] : dataInfo['idToken'];
    String? mobile =
        Platform.isIOS ? dataInfo['phone'] : dataInfo['phone_number'];
    String? email = Platform.isIOS ? dataInfo['email'] : dataInfo['email'];
    userInfoModel = await ServiceRepository.login(
      mobile: mobile,
      verifyCode: token,
      dataInfo: resJson,
      email: email,
    );
    ToastUtils.hiddenAllToast();
    if (userInfoModel != null && (userInfoModel?.uid ?? '').isNotEmpty) {
      await ChatUikitManager.loginIM(userInfoModel: userInfoModel);

      SharedPreferencesUtils.setLoginUid(userInfoModel!.uid!);
      SharedPreferencesUtils.setUserInfoModel(userInfoModel!);

      await getMinePageData();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getUserInfo() async {
    ToastUtils.showLoading();

    userInfoModel = await ServiceRepository.getUserInfo();
    ToastUtils.hiddenAllToast();
    if (userInfoModel != null) {
      SharedPreferencesUtils.setUserInfoModel(userInfoModel!);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> loginOut() async {
    bool? loginOut = await SharedPreferencesUtils.remove(Constants.loginInKey);

    bool logoutIM = await ChatUikitManager.logoutIM();
    if (loginOut == true && logoutIM) {
      await SharedPreferencesUtils.remove(
          Constants.userInfoKey + (SharedPreferencesUtils.getLoginUid() ?? ''));
      userInfoModel = null;
      centerModel = null;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeUser() async {
    bool res = await ServiceRepository.removeUser();
    if (!res) return false;
    bool? loginOut = await SharedPreferencesUtils.remove(Constants.loginInKey);

    bool logoutIM = await ChatUikitManager.logoutIM();
    if (loginOut == true && logoutIM) {
      await SharedPreferencesUtils.remove(
          Constants.userInfoKey + (SharedPreferencesUtils.getLoginUid() ?? ''));
      userInfoModel = null;
      centerModel = null;
      return true;
    } else {
      return false;
    }
  }

  ///获取个人中心页面的数据
  Future<void> getMinePageData() async {
    ToastUtils.showLoading();
    UserCenterModel? model = await ServiceRepository.getUserCenterInfo();
    ToastUtils.hiddenAllToast();
    if (model != null) {
      centerModel = model;
    }
  }

  void btnClick(BuildContext context, MinePageClickType type,
      {int myOrderIndex = 0}) {
    if (Constants.isLogin()) {
      switch (type) {
        case MinePageClickType.setting:
          AppRouter.push(context, const SettingPage());
          break;
        case MinePageClickType.collection:
          AppRouter.push(
                  context, const CollectionBrowsingRecord(appBarTitle: '收藏'))
              .then((value) {
            getMinePageData();
          });
          break;
        case MinePageClickType.browsingHistory:
          AppRouter.push(
                  context, const CollectionBrowsingRecord(appBarTitle: '足迹'))
              .then((value) {
            getMinePageData();
          });
          break;
        case MinePageClickType.coupon:
          AppRouter.push(context, const MyCouponPage()).then((value) {
            getMinePageData();
          });
          break;
        case MinePageClickType.bill:
          break;
        case MinePageClickType.myOrder:
          AppRouter.push(context, MyOrderPage(index: myOrderIndex))
              .then((value) {
            getMinePageData();
          });
          break;
        case MinePageClickType.afterSales:
          AppRouter.push(context, const AfterSalesPage()).then((value) {
            getMinePageData();
          });
          break;
        case MinePageClickType.mySell:
          AppRouter.push(context, const MySellPage()).then((value) {
            getMinePageData();
          });
          break;
        case MinePageClickType.myPublish:
          AppRouter.push(context, const MyPublishPage()).then((value) {
            getMinePageData();
          });
          break;
        case MinePageClickType.supplierAfter:
          AppRouter.push(context, const MyAfterPage());
          break;
        case MinePageClickType.withdrawalCenter:
          AppRouter.push(context, const MyWallet());
          break;
        default:
          break;
      }
    } else {
      login();
      // AppRouter.push(context, const LoginPage());
    }
  }
}
