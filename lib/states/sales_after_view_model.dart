
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../dialog/dialog.dart';
import '../model/order_after_processing_model.dart';
import '../net/service_repository.dart';
import '../utils/toast.dart';

class SalesAfterViewModel with ChangeNotifier{

  int _page = 1;
  int _status = 0;

  final List<AfterProcessingModel> _supplierAfterOrderList = [];

  List<AfterProcessingModel> get supplierAfterOrderList =>
      _supplierAfterOrderList;

  final RefreshController _refreshController = RefreshController();

  RefreshController get refreshController => _refreshController;

  Future<void> onLoading() async {
    _page++;
    getSupplierAfterOrder();
  }

  Future<void> refresh() async {
    _page = 1;
    _supplierAfterOrderList.clear();
    notifyListeners();

    getSupplierAfterOrder();
  }

  Future<void> changeTopBtn(int index) async {
    _status = index;
    refresh();
  }


  ///获取买家所有售后列表申请记录
  Future<void> getSupplierAfterOrder() async {
    ToastUtils.showLoading();
    OrderAfterProcessingModel? model =
    await ServiceRepository.getSupplierAfterOrder(
        page: _page.toString(), pageSize: '10',type:( _status+1).toString());
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
    List<AfterProcessingModel> resList = [];
    if (model != null) {
      ToastUtils.hiddenAllToast();
      if (model.afterProcessingModel != null &&
          model.afterProcessingModel!.isNotEmpty) {
        resList = model.afterProcessingModel!;
        _supplierAfterOrderList.addAll(resList);
      }
    }
    if (resList.length < 10) {
      _refreshController.loadNoData();
    }
    notifyListeners();
  }

  Future<void> cellBtnClick(BuildContext context,String? orderId, String? actions,String? alertTitle) async {
    if ((orderId ?? '').isEmpty || (actions ?? '').isEmpty) return;
    bool? res = await DialogUtils
        .orderAfterCancelDialog(context,alertTitle??"");
    if (res == true) {
      ToastUtils.showLoading();
      await ServiceRepository.cellBtnClick(orderId: orderId!, actions: actions!);

      refresh();
    }
  }
}