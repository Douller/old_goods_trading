import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';

import '../../constants/constants.dart';
import '../../model/cancel_order_reason.dart';
import '../../model/order_create_model.dart';
import '../theme_button.dart';
import '../theme_text.dart';

class CancelReasonSheetView extends StatefulWidget {
  final String orderId;
  final CancelOrderReasonModel reasonModel;

  const CancelReasonSheetView(
      {Key? key, required this.reasonModel, required this.orderId})
      : super(key: key);

  @override
  State<CancelReasonSheetView> createState() => _CancelReasonSheetViewState();
}

class _CancelReasonSheetViewState extends State<CancelReasonSheetView> {
  int _selectIndex = -1;


  Future<void> _cancelOrder() async {
    ToastUtils.showLoading();
    OrderCreateModel? model = await ServiceRepository.cancelMyOrder(orderId: widget.orderId,
        reason: widget.reasonModel.item![_selectIndex].name!);
    if(model !=null){
      ToastUtils.showText(text: '已取消订单');
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context,true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 14),
      constraints: BoxConstraints(maxHeight: Constants.safeAreaH - 100),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _topView(),
            ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 40),
                shrinkWrap: true,
                itemCount: (widget.reasonModel.item ?? []).length,
                itemBuilder: (context, index) {
                  return _payItemView(index);
                }),
            ThemeButton(
              height: 40,
              text: '确定',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              onPressed: () => _cancelOrder(),
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
            text: '取消订单', fontWeight: FontWeight.w600, fontSize: 18),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset('${Constants.iconsPath}close.png',
              width: 16, height: 16),
        ),
      ],
    );
  }

  Widget _payItemView(int index) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 25),
      child: Row(
        children: [
          ThemeText(
            text: widget.reasonModel.item![index].name ?? '',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectIndex = index;
              });
            },
            child: Icon(
              _selectIndex == index
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              size: 20,
              color: _selectIndex == index
                  ? const Color(0xffFE734C)
                  : const Color(0xff999999),
            ),
          ),
        ],
      ),
    );
  }
}
