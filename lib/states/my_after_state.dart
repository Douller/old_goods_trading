import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../dialog/dialog.dart';
import '../model/my_sell_goods_model.dart';
import '../model/order_after_processing_model.dart';
import '../utils/toast.dart';
import '../widgets/bottom_sheet/choose_delivery_sheet.dart';

class MyAfterViewModel with ChangeNotifier {
  int _page = 1;
  int _status = 0;

  final List<MySellGoodsData> _myAfterList = [];

  List<MySellGoodsData> get myAfterList => _myAfterList;

  final List<AfterProcessingModel> _myAfterProcessingList = [];

  List<AfterProcessingModel> get myAfterProcessingList =>
      _myAfterProcessingList;

  final List<AfterProcessingModel> _myOrderAfterHistoryList = [];

  List<AfterProcessingModel> get myOrderAfterHistoryList =>
      _myOrderAfterHistoryList;

  final RefreshController _refreshController = RefreshController();

  RefreshController get refreshController => _refreshController;

  Future<void> onLoading() async {
    _page++;
    if (_status == 0) {
      await getMyOrderAfterList();
    } else if (_status == 1) {
      await getMyOrderAfterProcessing();
    } else {
      await getMyOrderAfterHistory();
    }
  }

  Future<void> refresh() async {
    _page = 1;
    notifyListeners();
    if (_status == 0) {
      _myAfterList.clear();
      await getMyOrderAfterList();
    } else if (_status == 1) {
      _myAfterProcessingList.clear();
      await getMyOrderAfterProcessing();
    } else {
      _myOrderAfterHistoryList.clear();
      await getMyOrderAfterHistory();
    }
  }

  Future<void> changeTopBtn(int index) async {
    _status = index;
    refresh();
  }

  ///获取售后申请列表
  Future<void> getMyOrderAfterList() async {
    ToastUtils.showLoading();
    MySellGoodsModel? model = await ServiceRepository.getMyOrderAfterList(
        page: _page.toString(), pageSize: '10');
    List<MySellGoodsData> resList = [];
    if (model != null) {
      ToastUtils.hiddenAllToast();
      if (model.data != null && model.data!.isNotEmpty) {
        resList = model.data!;
        _myAfterList.addAll(resList);
      }
    }
    if (resList.length < 20) {
      _refreshController.loadNoData();
    }
    notifyListeners();
  }

  ///获取处理中的售后列表
  Future<void> getMyOrderAfterProcessing() async {
    ToastUtils.showLoading();
    OrderAfterProcessingModel? model =
        await ServiceRepository.getMyOrderAfterProcessing(
            page: _page.toString(), pageSize: '10');
    List<AfterProcessingModel> resList = [];

    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
    if (model != null) {
      ToastUtils.hiddenAllToast();
      if (model.afterProcessingModel != null &&
          model.afterProcessingModel!.isNotEmpty) {
        resList = model.afterProcessingModel!;
        _myAfterProcessingList.addAll(resList);
      }
    }
    if (resList.length < 20) {
      _refreshController.loadNoData();
    }
    notifyListeners();
  }

  ///获取买家所有售后列表申请记录
  Future<void> getMyOrderAfterHistory() async {
    ToastUtils.showLoading();
    OrderAfterProcessingModel? model =
        await ServiceRepository.getMyOrderAfterHistory(
            page: _page.toString(), pageSize: '10');
    List<AfterProcessingModel> resList = [];
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
    if (model != null) {
      ToastUtils.hiddenAllToast();
      if (model.afterProcessingModel != null &&
          model.afterProcessingModel!.isNotEmpty) {
        resList = model.afterProcessingModel!;
        _myOrderAfterHistoryList.addAll(resList);
      }
    }
    if (resList.length < 10) {
      _refreshController.loadNoData();
    }
    notifyListeners();
  }

  Future<void> cellBtnClick(BuildContext context, String? orderId,
      String? actions, String? alertTitle) async {
    if ((orderId ?? '').isEmpty || (actions ?? '').isEmpty) return;

    if (actions == 'supplier/delivery') {
      showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) {
            return ChooseDeliverySheetView(orderId: orderId!);
          }).then((value) {
        if (value != null && value == true) {
          refresh();
        }
      });
    } else {
      bool? res =
          await DialogUtils.orderAfterCancelDialog(context, alertTitle ?? "");
      if (res == true) {
        ToastUtils.showLoading();
        await ServiceRepository.cellBtnClick(
            orderId: orderId!, actions: actions!);

        refresh();
      }
    }
  }
}
