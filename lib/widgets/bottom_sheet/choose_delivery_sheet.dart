import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';
import '../../constants/constants.dart';
import '../../page/mine/choose_delivery_page.dart';
import '../../utils/custom_number_textinput.dart';
import '../theme_text.dart';

class ChooseDeliverySheetView extends StatefulWidget {
  final String orderId;

  const ChooseDeliverySheetView({Key? key, required this.orderId})
      : super(key: key);

  @override
  State<ChooseDeliverySheetView> createState() =>
      _ChooseDeliverySheetViewState();
}

class _ChooseDeliverySheetViewState extends State<ChooseDeliverySheetView> {
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _trackingNumberController =
      TextEditingController();

  String _code = '';

  Future<void> _fahuo() async {
    if (_code.isEmpty) {
      ToastUtils.showText(text: '请选择快递公司');
      return;
    }
    if (_trackingNumberController.text.trim().isEmpty) {
      ToastUtils.showText(text: '请填写快递单号');
      return;
    }
    ToastUtils.showLoading();
    bool data = await ServiceRepository.supplierDelivery(
        deliveryWay: _code,
        deliveryNo: _trackingNumberController.text,
        orderId: widget.orderId);
    if (data == true) {
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _topView(),
              _companyControllerView(),
              const Divider(color: Color(0xFFEEEEEE)),
              _trackingNumberView(),
              const Divider(color: Color(0xFFEEEEEE)),
              const SizedBox(height: 33),
              ThemeButton(
                text: '确认',
                height: 40,
                onPressed: _fahuo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topView() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Container()),
            const ThemeText(
              text: '选择发货',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                '${Constants.iconsPath}close.png',
                width: 16,
                height: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 19),
        const Divider(color: Color(0xFFEEEEEE))
      ],
    );
  }

  Widget _companyControllerView() {
    return GestureDetector(
      onTap: () {
        AppRouter.push(context, const ChooseDeliveryPage()).then((value) {
          if (value != null) {
            setState(() {
              _companyController.text = value['name'] ?? '';
              _code = value['code'] ?? '';
            });
          }
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        height: 60,
        child: Row(
          children: [
            const ThemeText(
              text: '快递公司：',
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                enabled: false,
                controller: _companyController,
                style: const TextStyle(
                  color: Color(0xff2F3033),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
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
                  hintText: '',
                  hintStyle: TextStyle(
                    color: Color(0xffCECECE),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Image.asset(
              '${Constants.iconsPath}right_arrow.png',
              width: 10,
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _trackingNumberView() {
    return Container(
      alignment: Alignment.center,
      height: 60,
      child: Row(
        children: [
          const ThemeText(
            text: '快递单号：',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _trackingNumberController,
              style: const TextStyle(
                color: Color(0xff2F3033),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              // keyboardType:
              //     const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                NumberTextInputFormatter(
                  maxIntegerLength: null,
                  maxDecimalLength: null,
                  isAllowDecimal: true,
                ),
              ],
              decoration: const InputDecoration.collapsed(
                hintText: '请输入快递单号',
                hintStyle: TextStyle(
                  color: Color(0xffCECECE),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
