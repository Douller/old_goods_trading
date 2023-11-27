import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../states/withdraw_state.dart';
import '../theme_text.dart';

class WithdrawBankCardView extends StatelessWidget {
  const WithdrawBankCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WithdrawViewModel>(
      builder: (BuildContext context, provider, Widget? child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => provider.chooseBandCardView(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ThemeText(text: '到账银行卡', fontSize: 14),
                const SizedBox(width: 40),
                provider.bankCardList.isEmpty
                    ? Image.asset(
                        '${Constants.iconsPath}add_card.png',
                        width: 20,
                        height: 20,
                      )
                    : ThemeNetImage(
                        imageUrl: provider.bankCardList.first.bankImg,
                        width: 20,
                        height: 20,
                      ),
                const SizedBox(width: 8),
                provider.bankCardList.isEmpty
                    ? const ThemeText(text: '添加银行卡')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ThemeText(
                            text: provider.bankCardList.first.bankName ?? '',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 4),
                          const ThemeText(
                            text: '2小时到账',
                            fontSize: 14,
                            color: Color(0xFF999999),
                          ),
                        ],
                      ),
                Expanded(child: Container()),
                Image.asset(
                  '${Constants.iconsPath}right_arrow.png',
                  width: 10,
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
