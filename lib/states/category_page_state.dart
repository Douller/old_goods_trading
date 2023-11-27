import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import '../model/category_model.dart';
import '../page/home/search_details_page.dart';
import '../router/app_router.dart';
import '../utils/sp_manager.dart';

class CategoryState with ChangeNotifier {
  List<CategoryData> _categoryList = [];

  List<CategoryData> get categoryList => _categoryList;

  Future<void> getCategoryList() async {
    ToastUtils.showLoading();
    CategoryModel? model = await ServiceRepository.getGoodsCategory();
    ToastUtils.hiddenAllToast();
    if (model != null && model.data != null && model.data!.isNotEmpty) {
      _categoryList = model.data!;
    }
    notifyListeners();
  }

  ///跳转搜索详情
  void pushSearchResult(
      BuildContext context, String text, String? brandId, String? categoryId,String? sonCategoryId) {
    if (text.isNotEmpty) {
      setHistoryList(text);

      AppRouter.push(
          context,
          SearchDetailsPage(
            keywords: text,
            brandId: brandId,
            categoryId: categoryId,
            sonCategoryId: sonCategoryId,
            isTextSearch: false,
          ));
    } else {
      ToastUtils.showText(text: '请在输入框中输入商品关键词');
    }
  }

  ///保存搜索历史列表
  Future<void> setHistoryList(String text) async {
    List<String> recordList =
        SharedPreferencesUtils.getSearchRecordList() ?? [];
    text = text.trim();
    if (recordList.contains(text)) {
      recordList.remove(text);
    }
    recordList.insert(0, text);
    if (recordList.length > 20) {
      recordList.removeLast();
    }
    await SharedPreferencesUtils.setSearchRecordList(recordList);
  }
}
