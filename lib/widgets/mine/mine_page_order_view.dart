import 'package:flutter/material.dart';
import 'package:old_goods_trading/states/user_info_state.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../model/user_center_model.dart';

class MinePageOrderBtnView extends StatelessWidget {
  final List orderButtonsList;

  const MinePageOrderBtnView({Key? key, required this.orderButtonsList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoViewModel>(
      builder: (context, value, Widget? child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => value.btnClick(context, MinePageClickType.myOrder,
                    myOrderIndex: 0),
                child: Row(
                  children: [
                    const Text(
                      '我的订单',
                      style: TextStyle(
                          color: Color(0xff2F3033),
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Expanded(child: Container()),
                    Image.asset(
                      '${Constants.iconsPath}right_arrow.png',
                      width: 13,
                      height: 13,
                      color: const Color(0xff484C52).withOpacity(0.4),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  orderButtonsList.length,
                  (index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (index == 4) {
                          value.btnClick(context, MinePageClickType.afterSales);
                        } else {
                          value.btnClick(context, MinePageClickType.myOrder,
                              myOrderIndex: index + 1);
                        }
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 21,
                            width: 23,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                Image.asset(
                                  '${Constants.iconsPath}${orderButtonsList[index]['icon']}',
                                  width: 20,
                                  height: 20,
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _cornerNumText(
                                                  index, value.centerModel)
                                              .isEmpty
                                          ? Colors.transparent
                                                : const Color(0xffFF3800),
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    height: 8,
                                    width: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            orderButtonsList[index]['title']!,
                            style: const TextStyle(
                                color: Color(0xff2F3033),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _cornerNumText(int index, UserCenterModel? centerModel) {
    String cornerNum = '';
    switch (index) {
      case 0:
        cornerNum = int.parse(centerModel?.orderUnpay ?? '0') == 0
            ? ''
            : int.parse(centerModel?.orderUnpay ?? '0') > 99
                ? '99+'
                : centerModel?.orderUnpay ?? '';
        break;
      case 1:
        cornerNum = int.parse(centerModel?.orderUndeliver ?? '0') == 0
            ? ''
            : int.parse(centerModel?.orderUndeliver ?? '0') > 99
                ? '99+'
                : centerModel?.orderUndeliver ?? '';

        break;
      case 2:
        cornerNum = int.parse(centerModel?.orderUnreceipt ?? '0') == 0
            ? ''
            : int.parse(centerModel?.orderUnreceipt ?? '0') > 9
                ? '9+'
                : centerModel?.orderUnreceipt ?? '';

        break;
      case 3:
        cornerNum = int.parse(centerModel?.orderUncomment ?? '0') == 0
            ? ''
            : int.parse(centerModel?.orderUncomment ?? '0') > 9
                ? '9+'
                : centerModel?.orderUncomment ?? '';
        break;
      case 4:
        cornerNum = int.parse(centerModel?.orderAfterSales ?? '0') == 0
            ? ''
            : int.parse(centerModel?.orderAfterSales ?? '0') > 9
                ? '9+'
                : centerModel?.orderAfterSales ?? '';

        break;

      default:
        break;
    }
    return cornerNum;
  }
}
