import 'package:flutter/material.dart';
import 'package:old_goods_trading/states/user_info_state.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';

class MineTopBtn extends StatelessWidget {
  final List topButtonsList;

  const MineTopBtn({Key? key, required this.topButtonsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              topButtonsList.length,
              (index) {
                return TextButton(
                  onPressed: () {
                    if (index == 0) {
                      value.btnClick(context, MinePageClickType.collection);
                    } else if (index == 1) {
                    } else if (index == 2) {
                      value.btnClick(
                          context, MinePageClickType.browsingHistory);
                    } else if (index == 3) {
                      value.btnClick(context, MinePageClickType.coupon);
                    }
                  }, //_btnClick(index),
                  child: Column(
                    children: [
                      Text(
                        index == 0
                            ? value.centerModel?.collectCount ?? '0'
                            : index == 1
                                ? value.centerModel?.collectSupplierCount ?? '0'
                                : index == 2
                                    ? value.centerModel?.historyCount ?? '0'
                                    : value.centerModel?.couponCount ?? '0',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        topButtonsList[index],
                        style: const TextStyle(
                          color: Color(0xff484C52),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
