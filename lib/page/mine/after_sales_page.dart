import 'package:flutter/material.dart';
import 'package:old_goods_trading/page/mine/after_sales_details.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../states/my_after_state.dart';
import '../../widgets/mine/my_after_sales_cell.dart';
import '../../widgets/no_data_view.dart';

class AfterSalesPage extends StatefulWidget {
  const AfterSalesPage({Key? key}) : super(key: key);

  @override
  State<AfterSalesPage> createState() => _AfterSalesPageState();
}

class _AfterSalesPageState extends State<AfterSalesPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabBarList = [
    '售后申请',
    '处理中',
    '申请记录',
  ];
  TabController? _tabController;

  final MyAfterViewModel _myAfterViewModel = MyAfterViewModel();

  @override
  void initState() {
    _tabController =
        TabController(length: _tabBarList.length, initialIndex: 0, vsync: this);

    _myAfterViewModel.changeTopBtn(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _myAfterViewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: AppBar(
          title: const Text('我的售后'),
        ),
        body: Column(
          children: [
            _topTabBarView(),
            Consumer<MyAfterViewModel>(
                builder: (BuildContext context, value, Widget? child) {
              return Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _myAfterViewModel.refreshController,
                  onLoading: _myAfterViewModel.onLoading,
                  onRefresh: _myAfterViewModel.refresh,
                  child: (_tabController?.index == 0
                          ? value.myAfterList.isEmpty
                          : _tabController?.index == 1
                              ? value.myAfterProcessingList.isEmpty
                              : value.myOrderAfterHistoryList.isEmpty)
                      ? const NoDataView()
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 33),
                          itemCount: _tabController?.index == 0
                              ? value.myAfterList.length
                              : _tabController?.index == 1
                                  ? value.myAfterProcessingList.length
                                  : value.myOrderAfterHistoryList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (_tabController?.index != 0) {
                                  String orderId = _tabController?.index == 1
                                      ? (value.myAfterProcessingList[index]
                                              .id ??
                                          '')
                                      : (value.myOrderAfterHistoryList[index]
                                              .id ??
                                          '');
                                  AppRouter.push(
                                          context,
                                          AfterSalesDetails(
                                              orderId: orderId,
                                              isSupplier: false))
                                      .then((res) {
                                    value.refresh();
                                  });
                                }
                              },
                              child: MyAfterSalesCell(
                                isSupplier: false,
                                model: _tabController?.index == 0
                                    ? value.myAfterList[index]
                                    : null,
                                processingModel: _tabController?.index == 1
                                    ? value.myAfterProcessingList[index]
                                    : _tabController?.index == 2
                                        ? value.myOrderAfterHistoryList[index]
                                        : null,
                                status: _tabController?.index,
                              ),
                            );
                          },
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _topTabBarView() {
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
              child: Text(_tabBarList[index]),
            );
          }),

          onTap: (int i) {
            setState(() {});
            _myAfterViewModel.changeTopBtn(i);
          },
        ),
      ),
    );
  }
}
