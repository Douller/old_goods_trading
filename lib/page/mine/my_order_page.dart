import 'package:flutter/material.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/states/my_order_state.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../net/service_repository.dart';
import '../../widgets/mine/my_order_list_cell.dart';
import '../../widgets/no_data_view.dart';
import 'my_order_details_page.dart';

class MyOrderPage extends StatefulWidget {
  final int index;

  const MyOrderPage({Key? key, required this.index}) : super(key: key);

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage>
    with SingleTickerProviderStateMixin {
  List _tabBarList = [];
  TabController? _tabController;
  final MyOrderViewModel _myOrderViewModel = MyOrderViewModel();

  Future<void> _getTabBarList() async {
    List dataList = await ServiceRepository.myOrderStatus(true);

    _tabBarList = dataList;
    if (_tabBarList.isNotEmpty) {
      setState(() {
        _tabController = TabController(
            initialIndex: widget.index,
            length: _tabBarList.length,
            vsync: this);
      });

      _myOrderViewModel.changeTopBtn(
          int.parse((_tabBarList[widget.index]['status']).toString()));
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
      create: (BuildContext context) => _myOrderViewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(title: const Text('我的订单')),
        body: Column(
          children: [
            _topTabBarView(),
            Expanded(
              child: Consumer<MyOrderViewModel>(
                  builder: (BuildContext context, value, Widget? child) {
                return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _myOrderViewModel.refreshController,
                  onLoading: _myOrderViewModel.onLoading,
                  onRefresh: _myOrderViewModel.refresh,
                  child: value.myOrderList.isEmpty
                      ? const NoDataView()
                      : ListView.builder(
                          itemCount: value.myOrderList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => AppRouter.push(
                                  context,
                                  MyOrderDetailsPage(
                                    orderId: value.myOrderList[index].id ?? '',
                                  )).then((value) {
                                if (value is bool && value == true) {
                                  _myOrderViewModel.refresh();
                                }
                              }),
                              child: MyOrderListViewCell(
                                  model: value.myOrderList[index]),
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
      return SizedBox(
        height: 40,
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
            // 设置标题
            onTap: (int i) {
              setState(() {});
              print(_tabController?.index);
              _myOrderViewModel.changeTopBtn(
                  int.parse((_tabBarList[i]['status']).toString()));
            },
          ),
        ),
      );
    }
  }
}
