import 'package:flutter/material.dart';
import 'package:old_goods_trading/config/Config.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/goods_price_text.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../MethodChannel/native_channel.dart';
import '../../constants/constants.dart';
import '../../model/my_sell_goods_model.dart';
import '../../model/pay_config_model.dart';
import '../../utils/regex.dart';

class PayBottomSheet extends StatefulWidget {
  final String totalAmount;
  final String orderSN;
  final String orderId;
  final String description;

  const PayBottomSheet({
    Key? key,
    required this.totalAmount,
    required this.orderSN,
    required this.description,
    required this.orderId,
  }) : super(key: key);

  @override
  State<PayBottomSheet> createState() => _PayBottomSheetState();
}

class _PayBottomSheetState extends State<PayBottomSheet> {
  final List _payImageList = [
    'wechat_pay.png',
    'alipay.png',
    'bank_card_pay.png',
    'paypal.png'
  ];
  final List _payTextList = ['微信支付', '支付宝支付', '银行卡/信用卡支付', 'PayPal支付'];

  int _selectIndex = -1;
  String _customerNo = '';
  String _creditType = '';
  PayConfigModel? _payConfigModel;

  Future<void> _creatYuansfer() async {
    ToastUtils.showLoading();
    Yuansfer? model =
        await ServiceRepository.creatYuansfer(orderId: widget.orderId);
    if (model != null) {
      _customerNo = model.customerNo ?? '';
      _creditType = model.creditType ?? '';
    }
  }

  Future<void> _getPayConf() async {
    ToastUtils.showLoading();
    PayConfigModel? payConfigModel = await ServiceRepository.getPayConf();
    if (payConfigModel != null) {
      _payConfigModel = payConfigModel;
    }
  }

  Future<void> _readyPay() async {
    if (_selectIndex < 0) {
      ToastUtils.showText(text: '请选择付款方式');
      return;
    }
    if (_payConfigModel == null) {
      ToastUtils.showText(text: '支付参数错误');
      return;
    }

    if (_selectIndex < 2) {
      NativeChannel.requestPayment(
        payStatus: _selectIndex,
        orderSN: widget.orderSN,
        amount: widget.totalAmount,
        token: _payConfigModel?.token ?? 'b411bb97eb19adbf3898f1f8367c42b0',
        merchantNo: _payConfigModel?.merchantNo ?? '203148',
        storeNo: _payConfigModel?.storeNo ?? '303402',
        ipnUrl: _payConfigModel?.apiReturnBackUrl ?? '',
        description: widget.description,
        customerNo: _customerNo,
        creditType: _creditType,
      );
    } else {
      ToastUtils.showLoading();
      Map res = await ServiceRepository.verifyCardPaypal(
        merchantNo: _payConfigModel?.merchantNo ?? '203148',
        storeNo: _payConfigModel?.storeNo ?? '303402',
        amount: widget.totalAmount,
        token: _payConfigModel?.token ?? 'b411bb97eb19adbf3898f1f8367c42b0',
        creditType: _creditType,
        customerNo: _customerNo,
        description: widget.description,
        ipnUrl: _payConfigModel?.apipaypelReturnBackUrl ?? '',
        note: '',
        vendor: _selectIndex == 2 ? "creditcard" : "paypal",
      );

      if (res.isNotEmpty) {
        if (res['cashierUrl'] != null &&
            RegexUtils.isURL(res['cashierUrl']) &&
            await canLaunchUrlString(res['cashierUrl'])) {
          final Uri url = Uri.parse(res['cashierUrl']);

          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
            ToastUtils.showText(text: '打开链接失败');
          }
        }
      }
    }
    if (mounted) {
      Navigator.pop(context, _selectIndex);
    }
  }

  @override
  void initState() {
    _creatYuansfer();
    _getPayConf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      constraints: BoxConstraints(maxHeight: Constants.safeAreaH - 100),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _topView(),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 26, bottom: 20),
              child: GoodsPriceText(
                priceStr: widget.totalAmount,
                textFontWeight: FontWeight.w500,
                textFontSize: 40,
                symbolFontSize: 40,
                symbolFontWeight: FontWeight.w500,
              ),
            ),
            const ThemeText(
              text: '选择付款方式',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            const SizedBox(height: 21),
            Column(
              children: List.generate(_payTextList.length, (index) {
                return Visibility(
                    visible: index > 0, child: _payItemView(index));
              }),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: ThemeButton(
                height: 47,
                text: '确定',
                fontSize: 16,
                radius: 16,
                fontWeight: FontWeight.w500,
                onPressed: _readyPay,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const ThemeText(
            text: '支付订单', fontWeight: FontWeight.w600, fontSize: 18),
        GestureDetector(
          onTap: () {
            Navigator.pop(context, -1);
          },
          child: Image.asset('${Constants.iconsPath}close.png',
              width: 16, height: 16),
        ),
      ],
    );
  }

  Widget _payItemView(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectIndex = index;
        });
      },
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: const Color(0xffE4D719).withOpacity(0.8))),
        child: Row(
          children: [
            Image.asset(
              Constants.iconsPath + _payImageList[index],
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 12),
            ThemeText(
              text: _payTextList[index],
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            Expanded(child: Container()),
            Icon(
                _selectIndex == index
                    ? Icons.circle
                    : Icons.radio_button_unchecked,
                size: 16,
                color: const Color(0xffE4D719).withOpacity(0.8)),
          ],
        ),
      ),
    );
  }
}
