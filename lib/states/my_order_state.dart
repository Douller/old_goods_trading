import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/page/mine/appraise_page.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../dialog/dialog.dart';
import '../model/my_sell_goods_model.dart';
import '../model/order_create_model.dart';
import '../net/service_repository.dart';
import '../page/mine/apply_after_sales.dart';
import '../page/mine/my_order_details_page.dart';
import '../router/app_router.dart';

class MyOrderViewModel extends ChangeNotifier {
  int _page = 1;
  int _status = -1;

  final List<MySellGoodsData> _myOrderList = [];

  List<MySellGoodsData> get myOrderList => _myOrderList;

  final RefreshController _refreshController = RefreshController();

  RefreshController get refreshController => _refreshController;

  Future<void> changeTopBtn(int status) async {
    _status = status;
    refresh();
  }

  Future<void> onLoading() async {
    _page++;
    await getMyOrderListData();
  }

  Future<void> refresh() async {
    _myOrderList.clear();
    _page = 1;
    await getMyOrderListData();
  }

  Future<void> cellBtnClick(BuildContext context, String btnName,
      String? orderId, String? actions,model,String? alertTitle) async {
    if ((orderId ?? '').isEmpty || (actions ?? '').isEmpty) return;

    if (actions == 'pay/pay' || actions!.contains('cancelReason')) {
      AppRouter.push(context, MyOrderDetailsPage(orderId: orderId ?? ''))
          .then((value) async {
        ToastUtils.showLoading();

        _myOrderList.clear();
        _page = 1;
        await getMyOrderListData();
      });
    } else if (actions == 'comment/add') {
      AppRouter.push(context, AppraisePage(orderId: orderId!, isSupplier: false,))
          .then((value) async {
        ToastUtils.showLoading();

        _myOrderList.clear();
        _page = 1;
        await getMyOrderListData();
      });
    }else if(actions == 'orderAfter/create'){
      AppRouter.push(context, ApplyAfterSales(model: model));
    } else {

      bool? res = await DialogUtils
          .orderAfterCancelDialog(context,alertTitle??'');
      if (res == true) {
        ToastUtils.showLoading();
        OrderCreateModel? model = await ServiceRepository.cellBtnClick(
            orderId: orderId!, actions: actions);
        if (model != null) {
          _myOrderList.clear();
          _page = 1;
          await getMyOrderListData();
        }
      }
    }
  }

  Future<void> getMyOrderListData() async {
    ToastUtils.showLoading();
    MySellGoodsModel? resModel = await ServiceRepository.getMyOrderList(
      status: _status.toString(),
      pageSize: '20',
      page: _page.toString(),
    );
    _refreshController.refreshCompleted(resetFooterState: true);
    _refreshController.loadComplete();
    List<MySellGoodsData> resList = [];
    if (resModel != null) {
      ToastUtils.hiddenAllToast();
      if (resModel.data != null && resModel.data!.isNotEmpty) {
        resList = resModel.data!;
        _myOrderList.addAll(resList);
      }
    }
    if (resList.length < 20) {
      _refreshController.loadNoData();
    }
    notifyListeners();
  }
}
