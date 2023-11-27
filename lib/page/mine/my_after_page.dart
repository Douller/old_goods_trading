import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../router/app_router.dart';
import '../../states/sales_after_view_model.dart';
import '../../widgets/mine/my_after_sales_cell.dart';
import '../../widgets/no_data_view.dart';
import 'after_sales_details.dart';

class MyAfterPage extends StatefulWidget {
  const MyAfterPage({Key? key}) : super(key: key);

  @override
  State<MyAfterPage> createState() => _MyAfterPageState();
}

class _MyAfterPageState extends State<MyAfterPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabBarList = [
    '处理中',
    '申请记录',
  ];
  TabController? _tabController;

  final SalesAfterViewModel _salesAfterViewModel = SalesAfterViewModel();

  @override
  void initState() {
    _tabController =
        TabController(length: _tabBarList.length, initialIndex: 0, vsync: this);

    _salesAfterViewModel.changeTopBtn(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _salesAfterViewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: AppBar(title: const Text('我的售后')),
        body: Column(
          children: [
            _topTabBarView(),
            Consumer<SalesAfterViewModel>(
                builder: (BuildContext context, value, Widget? child) {
              return Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _salesAfterViewModel.refreshController,
                  onLoading: _salesAfterViewModel.onLoading,
                  onRefresh: _salesAfterViewModel.refresh,
                  child: value.supplierAfterOrderList.isEmpty
                      ? const NoDataView()
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 33),
                          itemCount: value.supplierAfterOrderList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                AppRouter.push(
                                        context,
                                        AfterSalesDetails(
                                            orderId: value
                                                    .supplierAfterOrderList[
                                                        index]
                                                    .id ??
                                                '',
                                            isSupplier: true))
                                    .then((res) {
                                  value.refresh();
                                });
                              },
                              child: MyAfterSalesCell(
                                isSupplier: true,
                                processingModel:
                                    value.supplierAfterOrderList[index],
                                status: _tabController!.index + 1,
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
              _salesAfterViewModel.changeTopBtn(i);
            },
          )),
    );
  }
}
