import 'dart:async';

import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/goods_price_text.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';


import '../../model/my_sell_goods_model.dart';
import '../../router/app_router.dart';
import '../mine/my_order_page.dart';

class PayStatusPage extends StatefulWidget {
  final String amount;
  final String orderId;

  const PayStatusPage({Key? key, required this.amount, required this.orderId})
      : super(key: key);

  @override
  State<PayStatusPage> createState() => _PayStatusPageState();
}

class _PayStatusPageState extends State<PayStatusPage>
    with WidgetsBindingObserver {
  String _orderPay = "正在支付中...";
  int _orderPayStatus = -1;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    ToastUtils.showLoading();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // print("app进入前台");
      _getOrderDetails();
    }
    // else if (state == AppLifecycleState.inactive) {
    //   print("app在前台但不响应事件，比如电话，touch id等");
    // } else if (state == AppLifecycleState.paused) {
    //   print("app进入后台");
    // } else if (state == AppLifecycleState.detached) {
    //   print("没有宿主视图但是flutter引擎仍然有效");
    // }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _getOrderDetails() async {
    MySellGoodsData? orderModel =
        await ServiceRepository.getMyOrderDetails(orderId: widget.orderId);
    ToastUtils.hiddenAllToast();
    if (orderModel != null && orderModel.orderStatus != null) {
      setState(() {
        if ('0,9,99'.contains(orderModel.orderStatus!)) {
          _orderPay = "支付失败";
          _orderPayStatus = 0;
        } else {
          _orderPay = "支付成功";
          _orderPayStatus = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text(_orderPay),
      ),
      body: SafeArea(
        child: _orderPayStatus == -1
            ? Container()
            : Column(
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    _orderPayStatus == 1
                        ? '${Constants.placeholderPath}pay_success.png'
                        : '${Constants.placeholderPath}pay_fail.png',
                    width: 211,
                    height: 164,
                  ),
                  const SizedBox(height: 16),
                  GoodsPriceText(
                    priceStr: widget.amount,
                    textFontWeight: FontWeight.w600,
                    textFontSize: 40,
                    symbolFontWeight: FontWeight.w600,
                    symbolFontSize: 24,
                  ),
                  Expanded(child: Container()),
                  ThemeButton(
                    height: 40,
                    width: 177,
                    text: '确定',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    onPressed: () {
                      AppRouter.replace(context,
                          newPage:
                              MyOrderPage(index: _orderPayStatus == 1 ? 0 : 2));
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
      ),
    );
  }
}
