import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import '../../states/withdraw_state.dart';
import '../../utils/custom_number_textinput.dart';
import '../../widgets/mine/withdraw_bank_card_view.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final WithdrawViewModel _withdrawViewModel = WithdrawViewModel();




  @override
  void initState() {
    _withdrawViewModel.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _withdrawViewModel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF2F3F5),
          appBar: AppBar(
            title: const Text('提现中心'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const WithdrawBankCardView(),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 21, top: 20, right: 19),
                  child: Consumer<WithdrawViewModel>(
                    builder: (BuildContext context, value, Widget? child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ThemeText(text: '提现金额', fontSize: 14),
                          _shopPriceView(),
                          const Divider(color: Color(0xFFF2F3F5)),
                          Row(
                            children: [
                              ThemeText(
                                text: '当前可提现金额：\$${value.withdrawAmount}',
                                fontSize: 14,
                                color: const Color(0xFF999999),
                              ),
                              TextButton(
                                onPressed: value.allAmountBtnClick,
                                child: const ThemeText(
                                  text: '全部提现',
                                  fontSize: 14,
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 22),
            child:  ThemeButton(
              text: '提现',
              height: 40,
              onPressed: _withdrawViewModel.withdrawBtnClick,
            ),
          ),
        ),
      ),
    );
  }

  Widget _shopPriceView() {
    return Container(
      alignment: Alignment.center,
      height: 70,
      child: Row(
        children: [
          const ThemeText(
            text: '\$',
            fontWeight: FontWeight.w500,
            fontSize: 40,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Consumer<WithdrawViewModel>(
              builder: (BuildContext context, value, Widget? child) {
                return TextField(
                  controller: value.withdrawTF,
                  style: const TextStyle(
                    color: Color(0xff2F3033),
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                  ),
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    NumberTextInputFormatter(
                      maxIntegerLength: null,
                      maxDecimalLength: null,
                      isAllowDecimal: true,
                    ),
                  ],

                  decoration: const InputDecoration.collapsed(
                    hintText: '请输出提现金额',
                    hintStyle: TextStyle(
                      color: Color(0xffCECECE),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                );
              },)

            ,
          ),
        ],
      ),
    );
  }
}
