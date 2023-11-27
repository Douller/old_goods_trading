import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/page/mine/my_tool_page.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/widgets/mine/mine_page_top_btn.dart';
import 'package:old_goods_trading/widgets/mine/mine_user_info_view.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import '../../model/user_info_model.dart';
import '../../states/user_info_state.dart';
import '../../widgets/mine/mine_page_order_view.dart';
import '../../widgets/mine/mine_page_seller_view.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final List<String> _topButtonsList = [
    '收藏',
    '关注',
    '足迹',
    '优惠券',
    // '账单',
  ];

  final List<Map<String, String>> _orderButtonsList = [
    {'title': '待付款', 'icon': 'to_be_paid.png'},
    {'title': '待发货', 'icon': 'to_be_shipped.png'},
    {'title': '待收货', 'icon': 'to_be_received.png'},
    {'title': '待评价', 'icon': 'to_be_evaluated.png'},
    {'title': '退货', 'icon': 'aftermarket.png'},
  ];

  @override
  void initState() {
    UserInfoModel? model =
        Provider.of<UserInfoViewModel>(context, listen: false).userInfoModel;

    if (model != null) {
      Provider.of<UserInfoViewModel>(context, listen: false).getMinePageData();
    }
    Provider.of<UserInfoViewModel>(context, listen: false).getUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            const MineUserInfoView(),
            MineTopBtn(topButtonsList: _topButtonsList),
            MinePageOrderBtnView(orderButtonsList: _orderButtonsList),
            const SizedBox(height: 10),
            const MineSellerView(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ThemeText(
                    text: '推荐工具',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 18),
                  _toolBtn(
                    '关于我们',
                    '${Constants.iconsPath}about.png',
                    () => AppRouter.push(
                        context, const MyToolPage(title: '关于我们')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolBtn(String title, String iconPath, GestureTapCallback? onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            iconPath,
            width: 28,
            height: 28,
          ),
          const SizedBox(height: 10),
          ThemeText(
            text: title,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
