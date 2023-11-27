import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../constants/constants.dart';
import '../model/home_goods_list_model.dart';
import '../model/search_config_model.dart';
import '../model/search_goods_list_model.dart';
import '../widgets/bottom_sheet/all_round_sheet.dart';
import '../widgets/bottom_sheet/price_sheet.dart';
import '../widgets/bottom_sheet/search_area_sheet.dart';
import '../widgets/bottom_sheet/search_choice_sheet.dart';

class SearchDetailsState with ChangeNotifier {
  int _page = 1;
  final int _pageSize = 20;
  String? _keywords; //关键词
  String? _configKey; //选中条件的key
  String? _configId; //选中条件的id
  String? _brandId;
  String? _categoryId;
  String? _sonCategoryId;
  SearchGoodsListModel? _searchGoodsListModel;

  String? _minPrice; //最低价格
  String? get minPrice => _minPrice;

  String? _maxPrice; //最高价格
  String? get maxPrice => _maxPrice;
  bool _isTextSearch = true;

  //综合选项选中的item
  final List _allRoundList = [];

  List get allRoundList => _allRoundList;

  //价格选项选中的item
  List _priceList = [];

  List get priceList => _priceList;

  //筛选选项选中的item
  List _searchChoice = [];

  List get searchChoice => _searchChoice;

  //区域筛选选项数组

  List _citySearchList = [];

  List get citySearchList => _citySearchList;

  //
  final RefreshController _refreshController = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);

  RefreshController get refreshController => _refreshController;

  //
  SearchConfigModel? _searchConfigModel;

  SearchConfigModel? get searchConfigModel => _searchConfigModel;

  //顶部筛选选项数组
  List<Result> _configSearchList = [];

  List<Result> get configSearchList => _configSearchList;

  //商品列表
  final List<GoodsInfoModel> _searchDetailsDataList = [];

  List<GoodsInfoModel> get searchDetailsDataList => _searchDetailsDataList;

  Future<void> refreshData() async {
    _page = 1;
    await getGoodsSearchList(refresh: true);
  }

  Future<void> onLoadingData() async {
    _page++;
    await getGoodsSearchList(refresh: false);
  }

  Future<void> getData(String keywords, String? brandId, String? categoryId,
      String? sonCategoryId, bool isTextSearch) async {
    _keywords = keywords;
    _brandId = brandId;
    _categoryId = categoryId;
    _sonCategoryId = sonCategoryId;
    _isTextSearch = isTextSearch;
    await Future.wait([
      getSearchConfig(),
      getGoodsSearchList(refresh: true),
    ]);
  }

  ///获取顶部筛选模型
  Future<void> getSearchConfig() async {
    _searchConfigModel =
        await ServiceRepository.getGoodsSearchConfig(keywords: _keywords);
    if (_searchConfigModel != null &&
        _searchConfigModel?.result != null &&
        _searchConfigModel!.result!.isNotEmpty) {
      _configSearchList = _searchConfigModel!.result!;
    }
    notifyListeners();
  }

  ///获取商品列表
  Future<void> getGoodsSearchList({required bool refresh}) async {
    ToastUtils.showLoading();
    _searchGoodsListModel = await ServiceRepository.getGoodsSearchList(
      page: _page.toString(),
      pageSize: _pageSize.toString(),
      keywords: _isTextSearch ? _keywords : null,
      maxPrice: _maxPrice,
      minPrice: _minPrice,
      configId: _configId,
      configKey: _configKey,
      brandId: _brandId,
      categoryId: _categoryId,
      sonCategoryId: _sonCategoryId,
    );
    ToastUtils.hiddenAllToast();
    List<GoodsInfoModel> dataList = [];
    if ((_searchGoodsListModel?.data ?? []).isNotEmpty) {
      dataList = _searchGoodsListModel?.data ?? [];
    }
    if (refresh) {
      _refreshController.refreshCompleted(resetFooterState: true);
      _searchDetailsDataList.clear();
    } else {
      _refreshController.loadComplete();
      if (dataList.length < _pageSize) {
        _refreshController.loadNoData();
      }
    }
    _searchDetailsDataList.addAll(dataList);
    notifyListeners();
  }

  Future<void> showBottomSheet(BuildContext context, int selectIndex,String name) async {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          if (name == '综合') {
            return AllRoundBottomSheetView(
              allRoundList: _searchConfigModel?.result?[selectIndex].data ?? [],
              selectedList: _allRoundList,
              callback: (String selectedId, String name) {
                _allRoundList.clear();
                _allRoundList.add({
                  'key': _searchConfigModel?.result?[selectIndex].key,
                  'id': selectedId,
                  'name': name,
                });
              },
            );
          } else if (name == '价格') {
            return PriceBottomSheetView(
              priceList: _searchConfigModel?.result?[selectIndex].data ?? [],
              selectedList: _priceList,
              maxPrice: _maxPrice,
              minPrice: _minPrice,
              callback: (String? minPrice, String? maxPrice, String? priceId) {
                _minPrice = minPrice;
                _maxPrice = maxPrice;
                if (priceId != null) {
                  _priceList = [
                    {
                      'key': _searchConfigModel?.result?[selectIndex].key,
                      'id': priceId,
                    }
                  ];
                }
              },
            );
          } else if (name == '地区') {
            return SearchAreaBottomSheet(
              areaList: _searchConfigModel?.result?[selectIndex].data ?? [],
              callback: (String? areaId) {
                if (areaId == null) {
                  _citySearchList.clear();
                } else {
                  _citySearchList = [
                    {
                      'key': _searchConfigModel?.result?[selectIndex].key,
                      'id': areaId,
                    }
                  ];
                }
              },
            );
          } else if (name == '筛选') {
            return SearchChoiceBottomSheet(
              choiceList: _searchConfigModel?.result?[selectIndex].data ?? [],
              chooseList: _searchChoice,
              callback: (List<dynamic> chooseList) {
                _searchChoice = chooseList;
              },
            );
          }
          return Container(
              constraints:
                  BoxConstraints(maxHeight: Constants.safeAreaH - 100));
        }).then((value) {
      notifyListeners();
      List configKeyList = [];
      configKeyList.addAll(_allRoundList);
      configKeyList.addAll(_priceList);
      configKeyList.addAll(_citySearchList);
      configKeyList.addAll(_searchChoice);

      String keys = '';
      String ids = '';
      for (var element in configKeyList) {
        keys = '$keys${keys.isEmpty ? '' : ','}${element['key']}';
        ids = '$ids${ids.isEmpty ? '' : ','}${element['id']}';
      }
      _configKey = keys;
      _configId = ids;

      refreshData();
    });
  }
}
