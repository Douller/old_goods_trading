import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../page/mine/my_address_page.dart';
import '../../page/mine/my_tool_page.dart';
import '../../router/app_router.dart';
import '../../states/user_info_state.dart';
import '../theme_text.dart';

class MineSellerView extends StatelessWidget {
  const MineSellerView({Key? key}) : super(key: key);

  static const List dataList = [
    {'imagePath': 'my_publish.png', 'title': '我发布的'},
    {'imagePath': 'my_sell.png', 'title': '我卖出的'},
    {'imagePath': 'after_sales_center.png', 'title': '售后中心'},
    {'imagePath': 'withdrawal_center.png', 'title': '我的钱包'},
    {'imagePath': 'my_address.png', 'title': '我的地址'},
    {'imagePath': 'customer_service.png', 'title': '联系客服'},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 2.9,
            ),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  switch (index) {
                    case 0:
                      value.btnClick(context, MinePageClickType.myPublish);
                      break;
                    case 1:
                      value.btnClick(context, MinePageClickType.mySell);
                      break;
                    case 2:
                      value.btnClick(context, MinePageClickType.supplierAfter);
                      break;
                    case 3:
                      value.btnClick(
                          context, MinePageClickType.withdrawalCenter);
                      break;
                    case 4:
                      AppRouter.push(context, const MyAddressPage());
                      break;
                    case 5:
                      AppRouter.push(context, const MyToolPage(title: '客服'));
                      break;
                    default:
                      break;
                  }
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color(0xffE4D719).withOpacity(0.8)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Image.asset(
                        '${Constants.iconsPath}${dataList[index]['imagePath']}',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(width: 8),
                      ThemeText(
                        text: dataList[index]['title'],
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      // Expanded(child: Container()),
                      Expanded(
                        child: ThemeText(
                          text: _subtitle(value, index),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  String _subtitle(value, index) {
    if (index == 0) {
      return value.centerModel?.sellerGoodsCount ?? '';
    } else if (index == 1) {
      return value.centerModel?.sellerOrderCount ?? '';
    } else if (index == 2) {
      return value.centerModel?.afterSalesCount ?? '';
    } else if (index == 3) {
      return value.centerModel?.money ?? '0';
      // num money = num.parse((value.centerModel?.money ?? '0'));

      // return num.parse((value.centerModel?.money ?? '0')) > 9999
      //     ? "9999+"
      //     : value.centerModel?.money ?? '';
    } else {
      return '';
    }
  }
}
