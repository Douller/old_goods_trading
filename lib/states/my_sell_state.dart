import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/widgets/bottom_sheet/choose_delivery_sheet.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../dialog/dialog.dart';
import '../model/my_sell_goods_model.dart';
import '../page/mine/appraise_page.dart';
import '../router/app_router.dart';
import '../utils/toast.dart';

class MySellViewModel extends ChangeNotifier {
  int _page = 1;
  int _status = -1;

  final List<MySellGoodsData> _mySellList = [];

  List<MySellGoodsData> get mySellList => _mySellList;

  final RefreshController _refreshController = RefreshController();

  RefreshController get refreshController => _refreshController;

  Future<void> changeTopBtn(int status) async {
    _status = status;
    refresh();
  }

  Future<void> onLoading() async {
    _page++;
    await getMySellData();
  }

  Future<void> refresh() async {
    _mySellList.clear();
    _page = 1;
    await getMySellData();
  }

  Future<void> getMySellData() async {
    ToastUtils.showLoading();
    MySellGoodsModel? resModel = await ServiceRepository.getMySellGoodsData(
        status: _status.toString(), page: _page.toString(), pageSize: '20');

    _refreshController.refreshCompleted(resetFooterState: true);
    _refreshController.loadComplete();

    List<MySellGoodsData> resList = [];
    if (resModel != null) {
      if (resModel.data != null && resModel.data!.isNotEmpty) {
        resList = resModel.data!;
        _mySellList.addAll(resList);
      }
    }
    if (resList.length < 20) {
      _refreshController.loadNoData();
    }
    notifyListeners();
  }

  Future<void> cellBtnClick(BuildContext context, String? orderId,
      String? actions, String? title) async {
    if ((orderId ?? '').isEmpty || (actions ?? '').isEmpty) return;
    if (actions == 'comment/supplierAdd') {
      ///卖家评论买家
      AppRouter.push(
        context,
        AppraisePage(
          orderId: orderId!,
          isSupplier: true,
        ),
      ).then((value) => refresh());
    } else if (actions == 'supplier/delivery') {
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
          _mySellList.clear();
          _page = 1;
          getMySellData();
        }
      });
    } else {
      bool? res =
          await DialogUtils.orderAfterCancelDialog(context, title ?? '');
      if (res == true) {
        ToastUtils.showLoading();
        await ServiceRepository.cellBtnClick(
            orderId: orderId!, actions: actions!);
        _mySellList.clear();
        _page = 1;
        await getMySellData();
      }
    }
  }
}
