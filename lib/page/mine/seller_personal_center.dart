import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:old_goods_trading/page/mine/sell_off_goods_details_page.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../constants/constants.dart';
import '../../router/app_router.dart';
import '../../states/seller_personal_center_state.dart';
import '../../widgets/home_widgets/home_goods_cell.dart';
import '../../widgets/home_widgets/message_cell.dart';
import '../../widgets/no_data_view.dart';
import '../home/goods_details_page.dart';
import '../../widgets/mine/seller_center_user_info_view.dart';

class SellerPersonalCenter extends StatefulWidget {
  final String supplierId;

  const SellerPersonalCenter({Key? key, required this.supplierId})
      : super(key: key);

  @override
  State<SellerPersonalCenter> createState() => _SellerPersonalCenterState();
}

class _SellerPersonalCenterState extends State<SellerPersonalCenter>
    with SingleTickerProviderStateMixin {
  final List<String> _tabBarList = ['宝贝', '评价'];
  final List<String> _goodsSubtitleList = ['全部', '在售', '已售'];

  TabController? _tabController;

  final SellerPersonalCenterViewModel _sellerPersonalCenterViewModel =
      SellerPersonalCenterViewModel();

  @override
  void initState() {
    _tabController =
        TabController(length: _tabBarList.length, initialIndex: 0, vsync: this);
    _sellerPersonalCenterViewModel.getSupplierInfo(widget.supplierId);
    _sellerPersonalCenterViewModel.changeTabBarChooseIndex(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _sellerPersonalCenterViewModel,
      child: Scaffold(
        backgroundColor: const Color(0xffF2F3F5),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _sellerPersonalCenterViewModel.refreshController,
          onLoading: _sellerPersonalCenterViewModel.onLoading,
          onRefresh: _sellerPersonalCenterViewModel.refresh,
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              const SliverAppBar(
                pinned: true,
                expandedHeight: 285,
                flexibleSpace: FlexibleSpaceBar(
                  background: SellerCenterUserInfoView(),
                  collapseMode: CollapseMode.pin,
                ),
                backgroundColor: Colors.white,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) {
                    return _contentView();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentView() {
    return Container(
      width: Constants.screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabBarView(),
          const SizedBox(height: 12),
          Consumer<SellerPersonalCenterViewModel>(
            builder: (BuildContext context, value, Widget? child) {
              return value.tabBarChooseIndex == 0
                  ? _goodsSubtitleView(value)
                  : _commentSubView(value);
            },
          ),
          const SizedBox(height: 12),
          Consumer<SellerPersonalCenterViewModel>(
            builder: (BuildContext context, value, Widget? child) {
              return value.myGoodsList.isEmpty
                  ? const NoDataView()
                  : value.tabBarChooseIndex == 0
                      ? MasonryGridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: value.myGoodsList.length,
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 5,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (value.myGoodsList[index].status == '2') {
                                  AppRouter.push(
                                    context,
                                    SellOffGoodsDetailsPage(
                                        model: value.myGoodsList[index]),
                                  );
                                } else {
                                  AppRouter.push(
                                    context,
                                    GoodsDetailsPage(
                                      goodsId:
                                          value.myGoodsList[index].id ?? '0',
                                      isSupplier: true,
                                    ),
                                  );
                                }
                              },
                              child: HomeGoodsCell(
                                index: index,
                                goodsList: value.myGoodsList,
                                isSupplier: true, tabBarIndex: 0,
                              ),
                            );
                          },
                        )
                      : _messageBoard();
            },
          ),
        ],
      ),
    );
  }

  Widget _tabBarView() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelPadding: const EdgeInsets.only(right: 20),
      labelColor: const Color(0xff2F3033),
      labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      unselectedLabelColor: const Color(0xff666666),
      unselectedLabelStyle: const TextStyle(fontSize: 16),
      indicatorColor: const Color(0xffFE734C),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: const EdgeInsets.only(right: 20),
      tabs: List.generate(_tabBarList.length, (index) {
        return Text(_tabBarList[index]);
      }),
      // 设置标题
      onTap: (int index) {
        _sellerPersonalCenterViewModel.changeTabBarChooseIndex(index);
      },
    );
  }

  /// 宝贝选项
  Widget _goodsSubtitleView(SellerPersonalCenterViewModel provider) {
    return Row(
      children: List.generate(_goodsSubtitleList.length, (index) {
        return _subtitleBtnView(
          _goodsSubtitleList[index],
          provider.subChooseIndex == index
              ? const Color(0xffFE734C)
              : const Color(0xff2F3033),
          provider.subChooseIndex == index
              ? const Color(0xffFE734C).withOpacity(0.05)
              : const Color(0xff2F3033).withOpacity(0.05),
          () {
            provider.changeSubChooseIndex(index);
          },
        );
      }),
    );
  }

  Widget _commentSubView(SellerPersonalCenterViewModel provider) {
    if (provider.commentListModel != null &&
        (provider.commentListModel?.types ?? []).isNotEmpty) {
      return SizedBox(
        width: Constants.screenWidth,
        height: 26,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: (provider.commentListModel?.types ?? []).length,
            itemBuilder: (context, index) {
              return _subtitleBtnView(
                  provider.commentListModel?.types?[index].name ?? '',
                  provider.subChooseIndex == index
                      ? const Color(0xffFE734C)
                      : const Color(0xff2F3033),
                  provider.subChooseIndex == index
                      ? const Color(0xffFE734C).withOpacity(0.05)
                      : const Color(0xff2F3033).withOpacity(0.05), () {
                provider.changeSubChooseIndex(index);
              });
            }),
      );
    } else {
      return Container();
    }
  }

  Widget _subtitleBtnView(
    String title,
    Color textColor,
    Color bgColor,
    GestureTapCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: ThemeText(
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _messageBoard() {
    return Consumer<SellerPersonalCenterViewModel>(
        builder: (BuildContext context, value, Widget? child) {
      return value.commentListModel?.data == null ||
              (value.commentListModel?.data ?? []).isEmpty
          ? const NoDataView()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: List.generate(
                    (value.commentListModel?.data ?? []).length, (index) {
                  return MessageCell(
                    index: index,
                    commentList: (value.commentListModel!.data ?? []),
                  );
                }),
              ),
            );
    });
  }
}
