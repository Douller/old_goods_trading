import 'package:flutter/cupertino.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../model/home_goods_list_model.dart';
import '../model/supplier_comment_list_model.dart';
import '../model/user_info_model.dart';
import '../utils/toast.dart';

class SellerPersonalCenterViewModel with ChangeNotifier {
  UserInfoModel? _userInfoModel;

  UserInfoModel? get userInfoModel => _userInfoModel;

  int _tabBarChooseIndex = 0;

  int get tabBarChooseIndex => _tabBarChooseIndex;

  int _subChooseIndex = 0;

  int get subChooseIndex => _subChooseIndex;

  final List<GoodsInfoModel> _myGoodsList = [];

  List<GoodsInfoModel> get myGoodsList => _myGoodsList;

  final RefreshController _refreshController = RefreshController();

  RefreshController get refreshController => _refreshController;

  SupplierCommentListModel? _commentListModel;

  SupplierCommentListModel? get commentListModel => _commentListModel;


  bool? _follow;

  bool? get follow => _follow;

  int _page = 1;
  String _goodsStatus = '-1';
  String _supplierId = '';
  String _commentType = '-1';

  Future<void> refresh() async {
    _page = 1;
    if (_tabBarChooseIndex == 0) {
      _myGoodsList.clear();
      getMyPublishedList();
    } else {
      getSupplierCommentList();
    }
    getSupplierInfo(_supplierId);
  }

  Future<void> onLoading() async {
    _page++;
    if (_tabBarChooseIndex == 0) {
      getMyPublishedList();
    }
  }

  Future<void> changeTabBarChooseIndex(int index) async {
    _tabBarChooseIndex = index;
    notifyListeners();
    if (_tabBarChooseIndex == 0) {
      _myGoodsList.clear();
      getMyPublishedList();
    } else if (_tabBarChooseIndex == 1) {
      getSupplierCommentList();
    }
  }

  ///子选项
  Future<void> changeSubChooseIndex(int index) async {
    _subChooseIndex = index;

    notifyListeners();
    if (_tabBarChooseIndex == 0) {
      _myGoodsList.clear();
      if (_subChooseIndex == 0) {
        _goodsStatus = '-1';
      } else if (_subChooseIndex == 1) {
        _goodsStatus = '1';
      } else {
        _goodsStatus = '2';
      }
      getMyPublishedList();
    } else if (_tabBarChooseIndex == 1) {
      _commentType = (_commentListModel?.types?[index].id ?? -1).toString();
      getSupplierCommentList();
    }
  }

  ///获取用户信息
  Future<void> getSupplierInfo(String? supplierId) async {
    if(supplierId != null){
      _supplierId = supplierId;
    }

    _userInfoModel =
        await ServiceRepository.getSupplierInfo(supplierId: _supplierId);
    (_userInfoModel?.isCollectSupplier ?? '0') == '0'
        ? _follow = false
        : _follow = true;
    notifyListeners();
  }

  ///获取卖家商品信息
  Future<void> getMyPublishedList() async {
    ToastUtils.showLoading();
    GoodsLists? res = await ServiceRepository.getMyPublishedList(
      supplierId: _supplierId,
      status: _goodsStatus.toString(),
      page: _page.toString(),
      pageSize: '20',
    );
    _refreshController.refreshCompleted(resetFooterState: true);
    _refreshController.loadComplete();
    List<GoodsInfoModel> resList = [];
    if (res != null) {
      ToastUtils.hiddenAllToast();
      if (res.data != null && res.data!.isNotEmpty) {
        resList = res.data!;
        myGoodsList.addAll(resList);
      }
    }
    if (resList.length < 20) {
      _refreshController.loadNoData();
    }
    notifyListeners();
  }

  ///获取卖家评论
  Future<void> getSupplierCommentList() async {
    ToastUtils.showLoading();
    _commentListModel = await ServiceRepository.getSupplierCommentList(
        supplierId: _supplierId, type: _commentType);
    _refreshController.refreshCompleted(resetFooterState: true);
    _refreshController.loadComplete();
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
     if (supplierId != null) {
        _follow = result;
      }
    }
    getSupplierInfo(supplierId);

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
       if (supplierId != null) {
        _follow = false;
      }
    }
    getSupplierInfo(supplierId);
    notifyListeners();
  }
}
