import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../states/withdraw_center_state.dart';
import '../theme_button.dart';
import '../theme_text.dart';

class WithdrawCenterAmountView extends StatelessWidget {
  const WithdrawCenterAmountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WithdrawCenterViewModel>(
      builder: (BuildContext context, provider, Widget? child) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const ThemeText(
                text: '可提现金额',
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              ThemeText(
                text: '\$ ${provider.userInfoModel?.money ?? '0.00'}',
                fontWeight: FontWeight.w500,
                fontSize: 48,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ThemeButton(
                height: 36,
                width: 180,
                text: '提现',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                bgColor: const Color(0xffE4D719).withOpacity(0.8),
                onPressed: () => provider.withdrawBtnClick(context),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 16, top: 9, bottom: 6, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ThemeText(
                        text:
                            '总售出 \$${provider.userInfoModel?.allOrderAmount ?? '0.00'}',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: ThemeText(
                          text:
                              '已提现 \$${provider.userInfoModel?.allWithdrawAmount ?? '0.00'}',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
