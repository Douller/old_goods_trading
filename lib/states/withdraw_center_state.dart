import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../model/user_info_model.dart';
import '../model/withdraw_record_model.dart';
import '../page/mine/withdraw_page.dart';
import '../router/app_router.dart';

class WithdrawCenterViewModel extends ChangeNotifier {
  UserInfoModel? _userInfoModel;

  UserInfoModel? get userInfoModel => _userInfoModel;

  //提现记录数据列表
  final List<WithdrawRecordModel> _withdrawRecordList = [];
  List<WithdrawRecordModel>get withdrawRecordList => _withdrawRecordList;


  final List<WithdrawRecordModel>_revenueRecordList = [];
  List<WithdrawRecordModel> get revenueRecordList => _revenueRecordList;

  int _tabBarChooseIndex = 0;
  int get tabBarChooseIndex => _tabBarChooseIndex;

  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  RefreshController get refreshController => _refreshController;


  int _page = 1;


  Future<void> onLoading() async {
    _page++;
    if(_tabBarChooseIndex == 0){
      await _getRevenueRecordsList();
    }else{
      _withdrawRecordList.clear();
      await  _getWithdrawRecordsList();
    }
  }

  Future<void> refresh() async {
    _page = 1;
    if(_tabBarChooseIndex == 0){
      _revenueRecordList.clear();
      await _getRevenueRecordsList();
    }else{
      _withdrawRecordList.clear();
      ToastUtils.showLoading();
     await  _getWithdrawRecordsList();
    }
  }

  Future<void> initData() async {
    ToastUtils.showLoading();
    await _getWithdrawAmount();
    ToastUtils.hiddenAllToast();
  }

  ///获取提现金额
  Future<void> _getWithdrawAmount() async {
    UserInfoModel? model = await ServiceRepository.getWithdrawAmount();
    if (model != null) {
      _userInfoModel = model;
      notifyListeners();
    }
  }

  void changeTabBar(int index) {
    _tabBarChooseIndex = index;
    notifyListeners();
    refresh();

  }

  Future<void> _getWithdrawRecordsList() async {
    List<WithdrawRecordModel> res =
        await ServiceRepository.getWithdrawRecordsList(
            page: _page.toString(), pageSize: '20');

    _refreshController.refreshCompleted(resetFooterState: true);
    _refreshController.loadComplete();

    _withdrawRecordList.addAll(res);

    if(res.length<20){
      _refreshController.loadNoData();
    }
    notifyListeners();
  }

  Future<void> _getRevenueRecordsList() async {
    ToastUtils.showLoading();
    List<WithdrawRecordModel> res =
    await ServiceRepository.getRevenueRecordsList(
        page: _page.toString(), pageSize: '20');

    _refreshController.refreshCompleted(resetFooterState: true);
    _refreshController.loadComplete();

    _revenueRecordList.addAll(res);

    if(res.length<20){
      _refreshController.loadNoData();
    }
    notifyListeners();
  }

  Future<void> withdrawBtnClick(BuildContext context) async {
    num moneyNum = num.parse(_userInfoModel?.money ?? '0');
    if (moneyNum > 0) {
      AppRouter.push(context, const WithdrawPage()).then((value) {
        _getWithdrawAmount();
      });
    } else {
      ToastUtils.showText(text: '余额不足');
    }
  }
}
