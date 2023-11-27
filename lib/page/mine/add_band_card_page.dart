import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/model/bank_model.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import '../../utils/custom_number_textinput.dart';
import '../../widgets/mine/card_expiry_date_widget.dart';
import '../../widgets/theme_button.dart';
import 'choose_bank_page.dart';

class AddBandCardPage extends StatefulWidget {
  const AddBandCardPage({Key? key}) : super(key: key);

  @override
  State<AddBandCardPage> createState() => _AddBandCardPageState();
}

class _AddBandCardPageState extends State<AddBandCardPage> {
  final TextEditingController _nameTF = TextEditingController();
  final TextEditingController _cardNumTF = TextEditingController();
  final TextEditingController _cvcNumTF = TextEditingController();
  final TextEditingController _addressNumTF = TextEditingController();

  // Bank? _bankModel;
  String? _month;

  String? _year;

  void _pushChooseBank() {
    FocusScope.of(context).requestFocus(FocusNode());
    // AppRouter.push(context, const ChooseBankPage()).then((value) {
    //   if (value is Bank) {
    //     setState(() {
    //       _bankModel = value;
    //     });
    //   }
    // });

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        builder: (BuildContext context) {
          return const CardExpiryDateWidget();
        }).then((value) {
      if (value != null && value is List) {
        setState(() {
          _month = value[0];
          _year = value[1];
        });
      }
    });
  }

  Future<void> _addBankCard() async {
    if (_nameTF.text.isEmpty) {
      ToastUtils.showText(text: '用户名不正确');
      return;
    }
    if (_cardNumTF.text.isEmpty) {
      ToastUtils.showText(text: '卡号不正确');
      return;
    }
    if (_cvcNumTF.text.isEmpty) {
      ToastUtils.showText(text: 'CVC不正确');
      return;
    }
    if (_addressNumTF.text.isEmpty) {
      ToastUtils.showText(text: '地址不正确');
      return;
    }
    if (_month == null || _year == null) {
      ToastUtils.showText(text: '请选择有效期');
      return;
    }

    bool res = await ServiceRepository.addBankCard(
        bankUser: _nameTF.text,
        month: _month!,
        year: _year!,
        cvc: _cvcNumTF.text,
        address: _addressNumTF.text,
        bankAcc: _cardNumTF.text);
    if (res) {
      ToastUtils.showText(text: '银行卡添加成功');
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('添加银行卡'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              _tfItemView('户名', '请输入姓名', _nameTF),
              _tfItemView(
                '卡号',
                '请输入卡号',
                _cardNumTF,
                inputType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  NumberTextInputFormatter(
                    maxIntegerLength: null,
                    maxDecimalLength: null,
                    isAllowDecimal: true,
                  ),
                ],
              ),
              _tfItemView('CVC', '请输入CVC', _cvcNumTF),
              _tfItemView('卡主地址', '请输入地址', _addressNumTF),
              _bankChooseView(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 12),
          child: ThemeButton(
            text: '确定',
            height: 40,
            onPressed: _addBankCard,
          ),
        ),
      ),
    );
  }

  Widget _tfItemView(
      String title, String hintText, TextEditingController? controller,
      {TextInputType? inputType, List<TextInputFormatter>? inputFormatters}) {
    return Column(
      children: [
        SizedBox(
          height: 54,
          child: Row(
            children: [
              ThemeText(
                text: title,
                fontSize: 16,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.right,
                  keyboardType: inputType,
                  inputFormatters: inputFormatters,
                  decoration: InputDecoration.collapsed(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFFCECECE),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFFF2F3F5)),
      ],
    );
  }

  Widget _bankChooseView() {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _pushChooseBank,
          child: SizedBox(
            height: 54,
            child: Row(
              children: [
                const ThemeText(
                  text: '有效期',
                  fontSize: 16,
                ),
                Expanded(child: Container()),
                ThemeText(
                  text: _month == null ? '选择有效期时间' : '$_month-$_year',
                  fontSize: 16,
                  color: Color(_month != null ? 0xFF000000 : 0xFFCECECE),
                ),
                const SizedBox(width: 10),
                Image.asset(
                  '${Constants.iconsPath}right_arrow.png',
                  width: 10,
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        const Divider(color: Color(0xFFF2F3F5)),
      ],
    );
  }
}
