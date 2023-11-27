import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/page/mine/withdrawal_center_page.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

import '../../widgets/mine/payment_list_view.dart';
import 'choose_bank_card.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet>
    with SingleTickerProviderStateMixin {
  int _currIndex = 0;
  final List<String> _tabList = [
    '账户余额',
    '收款方式',
    '付款方式',
  ];

  late TabController _tabController;

  late PageController _pageController;
  final List<Widget> _pageList = [
    const WithdrawalCenterPage(),
    const PaymentMethod(),
    const PaymentListView(),
  ];

  @override
  void initState() {
    _tabController = TabController(
        initialIndex: _currIndex, length: _tabList.length, vsync: this);
    _pageController = PageController(initialPage: _currIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        title: const Text('我的钱包'),
      ),
      body: Column(
        children: [
          _topTabBarView(),
          const SizedBox(height: 12),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _pageList,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topTabBarView() {
    return Theme(
      data: ThemeData(
        splashColor: const Color.fromRGBO(0, 0, 0, 0),
        highlightColor: const Color.fromRGBO(0, 0, 0, 0),
      ),
      child: TabBar(
        tabs: List.generate(_tabList.length, (index) {
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                  color: (index == _currIndex)
                      ? const Color(0xffE4D719).withOpacity(0.8)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16)),
              child: Text(_tabList[index]));
        }),
        controller: _tabController,
        isScrollable: false,
        labelColor: const Color(0xff484C52),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        unselectedLabelColor: const Color(0xff484C52).withOpacity(0.4),
        unselectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: EdgeInsets.zero,
        onTap: (index) {
          setState(() {
            _currIndex = index;
            _pageController.jumpToPage(_currIndex);
          });
        },
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: Column(
        children: List.generate(1, (index) {
          return _cellView(
            index == 0
                ? '${Constants.iconsPath}credit_card.png'
                : '${Constants.iconsPath}attach_money.png',
            index == 0 ? '银行卡' : '账户余额支付',
            onTap: () => AppRouter.push(context, const ChooseBankCard()),
          );
        }),
      ),
    );
  }

  Widget _cellView(String imagePath, String title,
      {GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        color: Colors.white,
        height: 56,
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            ThemeText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            )
          ],
        ),
      ),
    );
  }
}
