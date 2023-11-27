import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/page/home/search_details_page.dart';
import '../constants/constants.dart';
import '../model/hot_search_words_model.dart';
import '../router/app_router.dart';
import '../utils/sp_manager.dart';
import '../utils/toast.dart';

class SearchState with ChangeNotifier {
  List<String> _historyList = [];
  final List<String> _recommendedList = [];

  List<String> get historyList => _historyList;

  List<String> get recommendedList => _recommendedList;

  ///获取搜索历史列表
  void getHistoryList() {
    _historyList = SharedPreferencesUtils.getSearchRecordList() ?? [];

    notifyListeners();
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

  ///获取搜索推荐列表
  Future<void> getRecommendedList() async {
    HotSearchWordsModel? model = await ServiceRepository.getHotSearchWords();
    if (model != null && model.data != null && model.data!.isNotEmpty) {
      model.data?.forEach((element) {
        _recommendedList.add(element.keyword ?? '');
      });
    }
    notifyListeners();
  }

  ///删除搜索历史
  Future<void> removeSearchRecord() async {
    await SharedPreferencesUtils.remove(Constants.searchRecordListKey);
    getHistoryList();
  }

  ///跳转搜索详情
  void pushSearchResult(BuildContext context, String text) {
    if (text.isNotEmpty) {
      setHistoryList(text);
      getHistoryList();
      AppRouter.push(
          context, SearchDetailsPage(keywords: text, isTextSearch: true));
    } else {
      ToastUtils.showText(text: '请在输入框中输入商品关键词');
    }
  }
}
