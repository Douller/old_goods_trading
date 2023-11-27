import 'package:flutter/material.dart';
import 'package:old_goods_trading/page/mine/seller_goods_details.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/states/my_sell_state.dart';
import 'package:old_goods_trading/widgets/mine/my_sell_cell.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../net/service_repository.dart';
import '../../widgets/no_data_view.dart';

class MySellPage extends StatefulWidget {
  const MySellPage({Key? key}) : super(key: key);

  @override
  State<MySellPage> createState() => _MySellPageState();
}

class _MySellPageState extends State<MySellPage>
    with SingleTickerProviderStateMixin {
  List _tabBarList = [];
  TabController? _tabController;
  final MySellViewModel _mySellViewModel = MySellViewModel();

  Future<void> _getTabBarList() async {
    List dataList = await ServiceRepository.myOrderStatus(false);

    _tabBarList = dataList;
    if (_tabBarList.isNotEmpty) {
      setState(() {
        _tabController = TabController(
            initialIndex: 0, length: _tabBarList.length, vsync: this);
      });

      _mySellViewModel
          .changeTopBtn(int.parse((_tabBarList[0]['status']).toString()));
    }
  }

  @override
  void initState() {
    _getTabBarList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _mySellViewModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('我卖的'),
        ),
        body: Column(
          children: [
            _topTabBarView(),
            Expanded(
              child: Consumer<MySellViewModel>(
                  builder: (BuildContext context, value, Widget? child) {
                return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _mySellViewModel.refreshController,
                  onLoading: _mySellViewModel.onLoading,
                  onRefresh: _mySellViewModel.refresh,
                  child: value.mySellList.isEmpty
                      ? const NoDataView()
                      : ListView.builder(
                          itemCount: value.mySellList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => AppRouter.push(
                                      context,
                                      SellerGoodsDetails(
                                          orderId:
                                              value.mySellList[index].id ?? ''))
                                  .then((value) {
                                _mySellViewModel.refresh();
                              }),
                              child: MySellCell(
                                  sellModel: value.mySellList[index]),
                            );
                          },
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topTabBarView() {
    if (_tabBarList.isEmpty) {
      return Container();
    } else {
      return Container(
        height: 40,
        color: Colors.white,
        child: Theme(
          data: ThemeData(
            splashColor: const Color.fromRGBO(0, 0, 0, 0),
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: false,
            labelColor: const Color(0xff484C52),
            labelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            unselectedLabelColor: const Color(0xff484C52).withOpacity(0.4),
            unselectedLabelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            indicatorColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.zero,
            tabs: List.generate(_tabBarList.length, (index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                    color: (index == _tabController?.index)
                        ? const Color(0xffE4D719).withOpacity(0.8)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16)),
                child: Text(_tabBarList[index]['name']),
              );
            }),
            onTap: (int i) {
              setState(() {});
              _mySellViewModel.changeTopBtn(
                  int.parse((_tabBarList[i]['status']).toString()));
            },
          ),
        ),
      );
    }
  }
}
