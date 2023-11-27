import 'package:flutter/cupertino.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/sp_manager.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../model/home_goods_list_model.dart';
import '../utils/toast.dart';

class MyPublishViewModel extends ChangeNotifier {
  int _page = 1;

  int _publishStatus = 1;

  int get publishStatus => _publishStatus;

  set publishStatus(int value) {
    _publishStatus = value;
    notifyListeners();
  }

  final RefreshController _refreshController = RefreshController();

  RefreshController get refreshController => _refreshController;

  //数据列表
  final List<GoodsInfoModel> _myPublishList = [];

  List<GoodsInfoModel> get myPublishList => _myPublishList;

  Future<void> onLoading() async {
    _page++;
    await getMyPublishData();
  }

  ///顶部切换
  Future<void> changeTopBtn(int index) async {
    if (index == 0) {
      publishStatus = 1;
    } else if (index == 1) {
      publishStatus = 2;
    } else {
      publishStatus = 0;
    }
    _myPublishList.clear();
    _page = 1;
    await getMyPublishData();
  }

  Future<void> getMyPublishData() async {
    ToastUtils.showLoading();
    String supplierId = SharedPreferencesUtils.getUserInfoModel()?.id ?? '';
    GoodsLists? res = await ServiceRepository.getMyPublishedList(
      status: _publishStatus.toString(),
      page: _page.toString(),
      pageSize: '20',
      supplierId: supplierId,
    );

    List<GoodsInfoModel> resList = [];
    if (res != null) {
      ToastUtils.hiddenAllToast();
      if (res.data != null && res.data!.isNotEmpty) {
        resList = res.data!;
        _myPublishList.addAll(resList);
      }
    }
    if (resList.length < 20) {
      _refreshController.loadNoData();
    }
    notifyListeners();
  }

  ///下架
  Future<void> pulledGoods(String goodsId) async {
    ToastUtils.showLoading();
    bool res = await ServiceRepository.publishOffSale(goodsId: goodsId);

    if (res) {
      changeTopBtn(0);
    }
  }

  ///重新上架
  Future<void> publishOnSale(String goodsId) async {
    ToastUtils.showLoading();
    bool res = await ServiceRepository.publishOnSale(goodsId: goodsId);
    if (res) {
      changeTopBtn(2);
    }
  }
}
