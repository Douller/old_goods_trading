import 'package:flutter/material.dart';
import 'package:old_goods_trading/states/search_state.dart';
import 'package:provider/provider.dart';
import '../../widgets/home_widgets/search_label.dart';
import '../../widgets/home_widgets/search_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchState _searchState = SearchState();

  @override
  void initState() {
    _searchState.getHistoryList();
    _searchState.getRecommendedList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _searchState,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Consumer<SearchState>(
              builder: (BuildContext context, value, Widget? child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _customAppBar(value),
                    const SizedBox(height: 30),
                    _historyListView(value),
                    SearchLabel(
                      title: '推荐搜索',
                      labelList: value.recommendedList,
                      pushSearchDetails: (String text) {
                        value.pushSearchResult(context, text);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ///顶部搜索框
  Widget _customAppBar(value) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          Expanded(
            child: SearchTextField(
              fillColor: const Color(0xffF6F6F6),
              hintText: '请输入您要搜索的宝贝',
              onSubmitted: (String text) {
                value.pushSearchResult(context, text);
              },
            ),
          ),
          _cancelBtn(),
        ],
      ),
    );
  }

  ///取消按钮
  Widget _cancelBtn() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text(
        '取消',
        style: TextStyle(
          color: Color(0xff2F3033),
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }

  ///搜索历史
  Widget _historyListView(value) {
    return value.historyList.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: SearchLabel(
              title: '历史搜索',
              isHideBtn: false,
              labelList: value.historyList,
              removeSearchRecord: value.removeSearchRecord,
              pushSearchDetails: (String text) {
                value.pushSearchResult(context, text);
              },
            ),
          );
  }
}
