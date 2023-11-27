import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../router/app_router.dart';
import '../../states/search_details_state.dart';
import '../../widgets/home_widgets/home_goods_cell.dart';
import '../../widgets/home_widgets/search_config_list.dart';
import '../../widgets/home_widgets/search_details_appbar.dart';
import '../../widgets/no_data_view.dart';
import 'goods_details_page.dart';

class SearchDetailsPage extends StatefulWidget {
  final bool isTextSearch; //不是用户输入的不需要传keywords
  final String keywords;
  final String? brandId;
  final String? categoryId;
  final String? sonCategoryId;

  const SearchDetailsPage({
    Key? key,
    required this.keywords,
    this.brandId,
    this.categoryId,
    this.sonCategoryId,
    required this.isTextSearch,
  }) : super(key: key);

  @override
  State<SearchDetailsPage> createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {
  final SearchDetailsState _searchDetailsState = SearchDetailsState();

  @override
  void initState() {
    _searchDetailsState.getData(
      widget.keywords,
      widget.brandId,
      widget.categoryId,
      widget.sonCategoryId,
      widget.isTextSearch,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _searchDetailsState,
      child: Scaffold(
        backgroundColor: const Color(0xffF9F9F9),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SearchDetailsAppBar(keywords: widget.keywords),
              const SearchConfigListView(),
              Expanded(
                child: Consumer<SearchDetailsState>(
                  builder: (BuildContext context, value, Widget? child) {
                    return value.searchDetailsDataList.isEmpty
                        ? const NoDataView()
                        : SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            controller: value.refreshController,
                            onRefresh: value.refreshData,
                            onLoading: value.onLoadingData,
                            child: MasonryGridView.count(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: value.searchDetailsDataList.length,
                              crossAxisCount: 2,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 5,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => AppRouter.push(
                                      context,
                                      GoodsDetailsPage(
                                        goodsId: value
                                                .searchDetailsDataList[index]
                                                .id ??
                                            '0',
                                      )),
                                  child: HomeGoodsCell(
                                    index: index,
                                    goodsList: value.searchDetailsDataList, tabBarIndex: 0,
                                  ),
                                );
                              },
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
