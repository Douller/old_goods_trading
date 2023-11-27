import 'package:flutter/foundation.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../model/home_goods_list_model.dart';
import '../net/service_repository.dart';

class MyCollectionViewModel extends ChangeNotifier {
  String _title = '';
  int _page = 1;

  bool _isEdit = false;

  bool get isEdit => _isEdit;

  bool _isSelectAll = false;

  bool get isSelectAll => _isSelectAll;

  //数据列表
  final List<GoodsInfoModel> _collectionList = [];

  List<GoodsInfoModel> get collectionList => _collectionList;

  //删除选中列表
  final List<GoodsInfoModel> _chooseList = [];

  List<GoodsInfoModel> get chooseList => _chooseList;

  final RefreshController _refreshController = RefreshController();

  RefreshController get refreshController => _refreshController;

  ///编辑按钮点击
  Future<void> editBtnClick() async {
    _isEdit = !_isEdit;
    if (!_isEdit) {
      _chooseList.clear();
      _isSelectAll = false;
    }
    notifyListeners();
  }

  ///全选
  Future<void> selectAllClick() async {
    if (_collectionList.isEmpty) return;
    _isSelectAll = !_isSelectAll;

    if (_isSelectAll) {
      _chooseList.clear();
      _chooseList.addAll(_collectionList);
    } else {
      _chooseList.clear();
    }

    notifyListeners();
  }

  ///选中单个点击
  Future<void> itemClick(GoodsInfoModel model) async {
    if (_chooseList.contains(model)) {
      _chooseList.remove(model);
    } else {
      _chooseList.add(model);
    }
    if (_chooseList.length == _collectionList.length) {
      _isSelectAll = true;
    } else {
      _isSelectAll = false;
    }
    notifyListeners();
  }

  Future<void> deleteCollection() async {
    if (_chooseList.isEmpty) return;
    ToastUtils.showLoading();
    List gooIds = [];
    for (GoodsInfoModel element in _chooseList) {
      gooIds.add(element.id);
    }
    bool res = false;
    if (_title == '收藏') {
      res =
          await ServiceRepository.postCollectDelete(goodsId: gooIds.join(','));
    } else {
      res = await ServiceRepository.deletedHistory(goodsId: gooIds.join(','));
    }

    if (res) {
      _collectionList.removeWhere((element) => gooIds.contains(element.id));
      _chooseList.removeWhere((element) => gooIds.contains(element.id));

      if (_chooseList.isEmpty) {
        _isSelectAll = false;
      }
    }
    ToastUtils.hiddenAllToast();
    notifyListeners();
  }

  Future<void> onLoading() async {
    _page++;
    await getMyCollectList(_title);
  }

  Future<void> getMyCollectList(String title) async {
    _title = title;
    ToastUtils.showLoading();
    GoodsLists? res;
    if (title == '收藏') {
      res = await ServiceRepository.getMyCollectList(
          page: _page.toString(), pageSize: '10');
    } else {
      res = await ServiceRepository.getMyCollectHistory(
          page: _page.toString(), pageSize: '10');
    }
    _refreshController.loadComplete();
    List<GoodsInfoModel> resList = [];
    if (res != null) {
      ToastUtils.hiddenAllToast();
      if (res.data != null && res.data!.isNotEmpty) {
        resList = res.data!;

        _collectionList.addAll(resList);
      }
    }
    if (resList.length < 10) {
      _refreshController.loadNoData();
    }
    notifyListeners();
  }
}
