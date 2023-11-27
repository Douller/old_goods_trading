import 'package:flutter/material.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import '../../model/add_publish_info_model.dart';
import '../../utils/custom_number_textinput.dart';

typedef PriceBottomSheetCallBack = void Function(
  String shopPrice,
  String marketPrice,
  String deliveryType,
  String? deliveryAmount,
);

class AddPriceBottomSheet extends StatefulWidget {
  final PriceBottomSheetCallBack callBack;
  final AddPublishInfoModel? model;
  final String? shopPrice;
  final String? marketPrice;
  final String? deliveryType;
  final String? deliveryAmount;

  const AddPriceBottomSheet(
      {Key? key,
      required this.callBack,
      this.shopPrice,
      this.marketPrice,
      this.deliveryType,
      this.deliveryAmount, this.model})
      : super(key: key);

  @override
  State<AddPriceBottomSheet> createState() => _AddPriceBottomSheetState();
}

class _AddPriceBottomSheetState extends State<AddPriceBottomSheet> {
  final TextEditingController _shopPriceController = TextEditingController();
  final TextEditingController _marketPriceController = TextEditingController();
  final TextEditingController _deliveryController = TextEditingController();

  bool _freeShipping = true;

  void _deliverySelect() {
    setState(() {
      _freeShipping = !_freeShipping;
    });
  }

  void _suerClick() {
    if (_shopPriceController.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入出售价格');
      return;
    }
    if (_marketPriceController.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入原价');
      return;
    }
    if (!_freeShipping && _deliveryController.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入邮费');
      return;
    }
    String shopPrice = _shopPriceController.text.trim();
    String marketPrice = _marketPriceController.text.trim();
    String deliveryType = _freeShipping ? '1' : '2';
    String? deliveryAmount = _deliveryController.text.trim().isEmpty
        ? '0'
        : _deliveryController.text.trim();

    widget.callBack(shopPrice, marketPrice, deliveryType, deliveryAmount);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    _shopPriceController.text = widget.shopPrice ?? '';
    if (num.parse(widget.shopPrice ?? '0') <= 0) {
      _shopPriceController.text = '';
    }
    _marketPriceController.text = widget.marketPrice ?? '';
    _deliveryController.text = widget.deliveryAmount ?? '';
    _freeShipping = (widget.deliveryType ?? '') == '2' ? false : true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        duration: Duration.zero,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 16),
              _shopPriceView(),
             widget.model == null?Container(): Row(
                children: [
                  ThemeText(
                    text: widget.model?.serviceChargeDesc??'',
                    fontSize: 12,
                  ),
                  ThemeText(
                    text: widget.model?.serviceCharge??'',
                    fontSize: 12,
                    color: const Color(0xFFFE734C),
                  )
                ],
              ),
              const Divider(color: Color(0xffCECECE)),
              const SizedBox(height: 8),
              _marketPriceView(),
              const Divider(color: Color(0xffCECECE)),
              _deliveryView(),
              const Divider(color: Color(0xffCECECE)),
              const SizedBox(height: 8),
              _sureBtn(),
              const SizedBox(height: 18),
            ],
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
          Container(
            padding: const EdgeInsets.only(top: 6),
            child: const ThemeText(
              text: '\$',
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _shopPriceController,
              autofocus: true,
              style: const TextStyle(
                color: Color(0xff2F3033),
                fontWeight: FontWeight.w700,
                fontSize: 30,
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
                hintText: '想卖多少钱',
                hintStyle: TextStyle(
                  color: Color(0xffCECECE),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _marketPriceView() {
    return Container(
      alignment: Alignment.center,
      height: 46,
      child: Row(
        children: [
          const ThemeText(
            text: '原价：',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _marketPriceController,
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
                hintText: '原来购买价格',
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

  Widget _deliveryView() {
    return SizedBox(
      height: 46,
      child: Row(
        children: [
          const ThemeText(
            text: '运费：',
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          Expanded(
            child: Container(
              height: 30,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: _freeShipping
                  ? const ThemeText(
                      text: '包邮',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    )
                  : TextField(
                      controller: _deliveryController,
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
                        hintText: '请输入邮费',
                        hintStyle: TextStyle(
                          color: Color(0xffCECECE),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _deliverySelect,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Icon(
                    _freeShipping
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: _freeShipping
                        ? const Color(0xffFE734C)
                        : const Color(0xff999999),
                    size: 16,
                  ),
                ),
                const ThemeText(
                  text: '包邮',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _deliverySelect();
            },
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Icon(
                    _freeShipping
                        ? Icons.radio_button_unchecked
                        : Icons.check_circle,
                    color: _freeShipping
                        ? const Color(0xff999999)
                        : const Color(0xffFE734C),
                    size: 16,
                  ),
                ),
                const ThemeText(
                  text: '按距离预估',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sureBtn() {
    return GestureDetector(
      onTap: _suerClick,
      child: Container(
        height: 30,
        width: 80,
        margin: const EdgeInsets.only(left: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xffFE734C),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text(
          '确定',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
