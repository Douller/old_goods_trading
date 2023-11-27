import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../model/withdraw_record_model.dart';
import '../../states/withdraw_center_state.dart';
import '../../widgets/mine/withdraw_center_amount_view.dart';
import '../../widgets/no_data_view.dart';

class WithdrawalCenterPage extends StatefulWidget {
  const WithdrawalCenterPage({Key? key}) : super(key: key);

  @override
  State<WithdrawalCenterPage> createState() => _WithdrawalCenterPageState();
}

class _WithdrawalCenterPageState extends State<WithdrawalCenterPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final WithdrawCenterViewModel _withdrawCenterViewModel =
      WithdrawCenterViewModel();

  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    _withdrawCenterViewModel.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) => _withdrawCenterViewModel,
      child: Scaffold(
        backgroundColor: const Color(0xffFAFAFA),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const WithdrawCenterAmountView(),
              const SizedBox(height: 18),
              _withdrawalTabBar(),
              Expanded(
                child: Consumer<WithdrawCenterViewModel>(
                    builder: (BuildContext context, value, Widget? child) {
                  return SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    controller: _withdrawCenterViewModel.refreshController,
                    onLoading: _withdrawCenterViewModel.onLoading,
                    onRefresh: _withdrawCenterViewModel.refresh,
                    child: (value.tabBarChooseIndex == 0
                                ? value.revenueRecordList
                                : value.withdrawRecordList)
                            .isEmpty
                        ? const NoDataView()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: (value.tabBarChooseIndex == 0
                                    ? value.revenueRecordList
                                    : value.withdrawRecordList)
                                .length,
                            itemBuilder: (context, index) {
                              return value.tabBarChooseIndex == 0
                                  ? _revenueRecords(
                                      value.revenueRecordList[index])
                                  : _withdrawalCell(
                                      value.withdrawRecordList[index]);
                            },
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _withdrawalTabBar() {
    return SizedBox(
      height: 34,
      child: Theme(
        data: ThemeData(
          splashColor: const Color.fromRGBO(0, 0, 0, 0),
          highlightColor: const Color.fromRGBO(0, 0, 0, 0),
        ),
        child: TabBar(
          controller: _tabController,
          tabs: List.generate(2, (index) {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                    color: (index == _tabController?.index)
                        ? const Color(0xffE4D719).withOpacity(0.8)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16)),
                child: Text(index == 0 ? '收入记录' : '提现记录'));
          }),
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
          onTap: (index) {
            setState(() {});
            _withdrawCenterViewModel.changeTabBar(index);
          },
        ),
      ),
    );
  }

  Widget _revenueRecords(WithdrawRecordModel model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          ThemeNetImage(
            imageUrl: model.image,
            width: 41,
            height: 41,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ThemeText(
                        text: model.content ?? '',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: const Color(0xFF2F3033),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 17),
                    ThemeText(
                      text: '+ ${model.changeAmount}',
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                      color: const Color(0xFFFE734C),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ThemeText(
                        text: model.createTime ?? '',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: const Color(0xFF999999),
                      ),
                    ),
                    ThemeText(
                      text: '余额：${model.amount}',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: const Color(0xFF999999),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _withdrawalCell(WithdrawRecordModel model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          ClipRRect(
            child: Image.asset(
              '${Constants.iconsPath}withdrawal_cell.png',
              width: 41,
              height: 41,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ThemeText(
                        text: model.title ?? '',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: const Color(0xFF2F3033),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 17),
                    ThemeText(
                      text: '- ${model.money ?? ''}',
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                      color: const Color(0xFF2F3033),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ThemeText(
                        text: model.createTime ?? '',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: const Color(0xFF999999),
                      ),
                    ),
                    ThemeText(
                      text: model.statusName ?? '',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: model.status == '0'
                          ? const Color(0xFFFF3800)
                          : const Color(0xFF0DB13E),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
