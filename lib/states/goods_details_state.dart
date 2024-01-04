import 'package:flutter/material.dart';

import 'package:old_goods_trading/utils/sp_manager.dart';
import 'package:old_goods_trading/utils/toast.dart';
import '../model/goods_details_model.dart';
import '../model/order_buy_confirm_model.dart';
import '../net/service_repository.dart';


class GoodsDetailsState with ChangeNotifier {
  GoodsDetailsModel? _detailsModel;

  GoodsDetailsModel? get detailsModel => _detailsModel;

  bool? _follow;

  bool? get follow => _follow;

  bool? _collect;

  bool? get collect => _collect;

  String? _currentAddress;

  String? get currentAddress => _currentAddress;


  Future<void> getGoodsDetails(String goodsId) async {
    ToastUtils.showLoading();
    _detailsModel = await ServiceRepository.getGoodsInfo(id: goodsId);
    (_detailsModel?.isCollectSupplier ?? 0) == 0
        ? _follow = false
        : _follow = true;

    (_detailsModel?.isCollect ?? 0) == 0 ? _collect = false : _collect = true;

    // Get address information
    _currentAddress = await ServiceRepository.getAddressInfo(_detailsModel?.goodsInfo?.longitude ?? '', _detailsModel?.goodsInfo?.latitude ?? '');

    notifyListeners();
  }


  ///关注和收藏
  Future<void> collectAndAdd({
    String? goodsId,
    String? supplierId,
  }) async {
    ToastUtils.showLoading();
    bool? result = await ServiceRepository.postCollectAndeAdd(
        goodsId: goodsId, supplierId: supplierId);
    if (result == true) {
      ToastUtils.hiddenAllToast();
      if (goodsId != null) {
        _collect = result;
      } else if (supplierId != null) {
        _follow = result;
      }
    }

    notifyListeners();
  }

  ///取消关注和收藏
  Future<void> collectDelete({
    String? goodsId,
    String? supplierId,
  }) async {
    ToastUtils.showLoading();
    bool? result = await ServiceRepository.postCollectDelete(
        goodsId: goodsId, supplierId: supplierId);
    if (result == true) {
      ToastUtils.hiddenAllToast();
      if (goodsId != null) {
        _collect = false;
      } else if (supplierId != null) {
        _follow = false;
      }
    }

    notifyListeners();
  }
}
