import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:location/location.dart';
import 'package:old_goods_trading/model/version_model.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/page/home/goods_details_page.dart';
import 'package:old_goods_trading/states/home_page_state.dart';
import 'package:old_goods_trading/utils/location_utils.dart';
import 'package:old_goods_trading/utils/regex.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../constants/constants.dart';
import '../../dialog/dialog.dart';
import '../../router/app_router.dart';
import '../../utils/package_info.dart';
import '../../widgets/category_widgets/category_top_bar.dart';
import '../../widgets/home_widgets/home_goods_cell.dart';
import '../../widgets/no_data_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final HomeState _homeViewModel = HomeState();

  late TabController _tabController;

  Future<void> _onAppUpdateListener() async {
    PackageInfo packageInfo = await PackageInfoUtils.instance.getPackageInfo;
    VersionModel? versionModel = await ServiceRepository.getVersion();
    if (versionModel != null) {
      int compare = RegexUtils.compare(
          versionModel.appVersion ?? '1.0.0', packageInfo.version);
      if (compare == 1) {
        if (!mounted) return;
        DialogUtils.showAppUpgradeDialog(context, versionModel);
      }
    }
  }

  Future<void> _requestLocationPermission(int index) async {
    _homeViewModel.changeTabBarIndex(index);
    if (index == 1) {
      bool res = await LocationUtils().requestLocationPermission();
      if (!res) {
        if (!mounted) return;
        bool? dialogRes = await DialogUtils.openSetting(context);
        if ((dialogRes ?? false) == false) {
          setState(() {
            _tabController.index = 0;
          });
          _homeViewModel.changeTabBarIndex(0);
        }
      } else {
        if (_homeViewModel.longitude.isEmpty ||
            _homeViewModel.latitude.isEmpty) {
          ToastUtils.showLoading();
          LocationData locationData = await LocationUtils().getLocationData();
          ToastUtils.hiddenAllToast();
          _homeViewModel.longitude = locationData.longitude.toString();
          _homeViewModel.latitude = locationData.latitude.toString();
        }
        _homeViewModel.refreshData();
        LocationData locationData = await LocationUtils().getLocationData();

        _homeViewModel.longitude = locationData.longitude.toString();
        _homeViewModel.latitude = locationData.latitude.toString();
      }
    }
  }

  Future<void> _checkUp() async {
    bool res = await ServiceRepository.checkUpApp();
    if (res) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container();
        },
      );
    }
  }

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _checkUp();
    _onAppUpdateListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) => _homeViewModel,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar: AppBar(
            title: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: SizedBox(
                height: 36,
                width: 260,
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: '推荐'),
                    Tab(text: '附近'),
                  ],
                  labelColor: const Color(0xFF2F3033),
                  labelStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                  unselectedLabelColor: const Color(0xff999999),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 5),
                  onTap: (int index) {
                    _requestLocationPermission(index);
                  },
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              const CategoryTopBar(),
              Expanded(
                child: Consumer<HomeState>(
                  builder: (BuildContext context, value, Widget? child) {
                    return SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        controller: _homeViewModel.refreshController,
                        onRefresh: _homeViewModel.refreshData,
                        onLoading: _homeViewModel.onLoadingData,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          children: [
                            value.advsList.isEmpty
                                ? Container()
                                : Container(
                                    height: 158,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: const Color(0xffEEF1F4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          offset: const Offset(0, 40),
                                          blurRadius: 40,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Swiper(
                                        itemCount: value.advsList.length,
                                        autoplay: true,
                                        duration: 500,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            child: ThemeNetImage(
                                              imageUrl:
                                                  value.advsList[index].image,
                                            ),
                                          );
                                        },
                                        pagination: SwiperPagination(
                                          builder: DotSwiperPaginationBuilder(
                                            size: 8,
                                            activeSize: 10,
                                            activeColor: const Color(0xffB6AC14)
                                                .withOpacity(0.8),
                                            color: const Color(0xffE4D719)
                                                .withOpacity(0.15),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            (value.tabBarIndex == 0
                                        ? value.goodsList
                                        : value.nearbyGoodsList)
                                    .isEmpty
                                ? const NoDataView()
                                : MasonryGridView.count(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: (value.tabBarIndex == 0
                                            ? value.goodsList
                                            : value.nearbyGoodsList)
                                        .length,
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => AppRouter.push(
                                          context,
                                          GoodsDetailsPage(
                                            goodsId:
                                                value.goodsList[index].id ??
                                                    '0',
                                          ),
                                        ),
                                        child: HomeGoodsCell(
                                          index: index,
                                          goodsList: (value.tabBarIndex == 0
                                              ? value.goodsList
                                              : value.nearbyGoodsList),
                                          tabBarIndex: value.tabBarIndex,
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
