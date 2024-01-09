import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../model/home_goods_list_model.dart';
import '../net/service_repository.dart';
import 'package:haversine_distance/haversine_distance.dart';

class HomeState with ChangeNotifier {
  int _page = 1;

  String latitude = '';
  String longitude = '';

  int _tabBarIndex = 0;

  int get tabBarIndex => _tabBarIndex;


  final RefreshController _refreshController = RefreshController(
      initialRefresh: true, initialLoadStatus: LoadStatus.idle);

  RefreshController get refreshController => _refreshController;

  final List<GoodsInfoModel> _goodsList = [];

  List<GoodsInfoModel> get goodsList => _goodsList;

  //附近商品数据
  final List<GoodsInfoModel> _nearbyGoodsList = [];

  List<GoodsInfoModel> get nearbyGoodsList => _nearbyGoodsList;

  //banner数据
  final List<Advs> _advsList = [];

  List<Advs> get advsList => _advsList;

  void changeTabBarIndex(int index) {
    _tabBarIndex = index;
    notifyListeners();
  }

  Future<void> refreshData() async {
    _page = 1;
    if (_tabBarIndex == 0) {
      _goodsList.clear();
      await _getData();
    } else {
      _nearbyGoodsList.clear();
      await _getNearbyData();
    }
  }

  Future<void> onLoadingData() async {
    _page++;
    if (_tabBarIndex == 0) {
      await _getData();
    } else {
      await _getNearbyData();
    }
  }

  Future<void> _getData() async {
    HomeGoodsListModel? model = await ServiceRepository.getHomeGoodsList(
        page: _page.toString(), pageSize: '10');

    _refreshController.refreshCompleted(resetFooterState: true);
    _refreshController.loadComplete();
    if (model != null &&
        model.goodsLists != null &&
        model.goodsLists?.data != null &&
        model.goodsLists!.data!.isNotEmpty) {
      _goodsList.addAll(model.goodsLists!.data!);

      if (model.goodsLists!.data!.length < 10) {
        _refreshController.loadNoData();
      }

      // get state info of goods according to lon&lat
      for(GoodsInfoModel item in model.goodsLists!.data!){
        String? state = await ServiceRepository.getStateInfo(item.longitude ?? '0', item.latitude ?? '0');
        item.state = state;
      }

    } else {
      _refreshController.loadNoData();
    }

    if(model != null && (model.advs??[]).isNotEmpty){
      _advsList.clear();
      _advsList.addAll(model.advs??[]);
    }
    notifyListeners();
  }

  Future<void> _getNearbyData() async {
    if (latitude.isEmpty || longitude.isEmpty) {
      ToastUtils.showText(text: '未获取到位置信息');
      return;
    }

    HomeGoodsListModel? model = await ServiceRepository.getNearbyGoodsList(
      page: _page.toString(),
      pageSize: '10',
      latitude: latitude,
      longitude: longitude,
    );

    _refreshController.refreshCompleted(resetFooterState: true);
    _refreshController.loadComplete();
    if (model != null &&
        model.goodsLists != null &&
        model.goodsLists?.data != null &&
        model.goodsLists!.data!.isNotEmpty) {
      // _nearbyGoodsList.addAll(model.goodsLists!.data!);

      // set user's location as start coordinate
      final startCoordinate = Location(double.parse(latitude), double.parse(longitude));

      for(GoodsInfoModel item in model.goodsLists!.data!){
        // set each good's location as end coordinate
        final endCoordinate = Location(double.parse(item.latitude!), double.parse(item.longitude!));

        // calculate distance between start and end location
        final haversineDistance = HaversineDistance();
        final distance = haversineDistance.haversine(startCoordinate, endCoordinate, Unit.MILE).floor();

        // only display goods within 100 miles
        if(distance <= Constants.maxDistance){
          _nearbyGoodsList.add(item);
        }

        // if no good within 100 miles, alert '当前位置附近没有商品'
        if(_nearbyGoodsList.isEmpty){
          ToastUtils.showText(text: '当前位置附近没有商品');
        }
      }

      if (model.goodsLists!.data!.length < 10) {
        _refreshController.loadNoData();
      }

      // get state info of goods according to lon&lat
      for(GoodsInfoModel item in model.goodsLists!.data!){
        String? state = await ServiceRepository.getStateInfo(item.longitude ?? '0', item.latitude ?? '0');
        item.state = state;
      }

    } else {
      _refreshController.loadNoData();
    }
    notifyListeners();
  }
}
