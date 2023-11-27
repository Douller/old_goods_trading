import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/add/publish_sheetItem_child.dart';

import '../../utils/custom_number_textinput.dart';
import '../theme_text.dart';

typedef DeliveryCallback = void Function(
    String deliveryType, String? deliveryPrice);

typedef SelfPickupCallback = void Function(String selfPickup);

class PublishDeliverySheetView extends StatefulWidget {
  final String deliveryType;
  final String? deliveryPrice;
  final String? boxSize;
  final String? longitude;
  final String? latitude;
  final String selfPickup;
  final DeliveryCallback callback;
  final SelfPickupCallback pickUpCallback;

  const PublishDeliverySheetView({
    Key? key,
    required this.callback,
    required this.deliveryType,
    this.deliveryPrice,
    this.boxSize,
    this.longitude,
    this.latitude,
    required this.selfPickup,
    required this.pickUpCallback,
  }) : super(key: key);

  @override
  State<PublishDeliverySheetView> createState() =>
      _PublishDeliverySheetViewState();
}

class _PublishDeliverySheetViewState extends State<PublishDeliverySheetView> {
  final TextEditingController _deliveryController = TextEditingController();

  int _deliveryType = 1;
  int _pickUpType = 0;

  Future<void> _calculatePostage() async {
    if ((widget.boxSize ?? "").isEmpty) {
      ToastUtils.showText(text: '请先选择产品尺寸');
      return;
    }
    if ((widget.longitude ?? "").isEmpty && (widget.latitude ?? "").isEmpty) {
      ToastUtils.showText(text: '未获取到位置信息');
      return;
    }

    if (_deliveryType == 2) {
      setState(() {
        _deliveryType = 4;
        _deliveryController.clear();
      });
    } else {
      ToastUtils.showLoading();
      String resStr = await ServiceRepository.getPublishShipPrice(
          boxSize: widget.boxSize!,
          longitude: widget.longitude!,
          latitude: widget.latitude!);
      setState(() {
        _deliveryType = 2;
        _deliveryController.text = resStr;
      });
    }
    widget.callback(_deliveryType.toString(), _deliveryController.text);
  }

  @override
  void initState() {
    _deliveryType = int.parse(widget.deliveryType);
    _pickUpType = int.parse(widget.selfPickup);
    if (_deliveryType < 3) {
      _deliveryController.text = widget.deliveryPrice ?? '包邮';
    }

    // _deliveryController.addListener(() {
    //   // if (_deliveryController.text.isNotEmpty &&
    //   // (num.tryParse(_deliveryController.text) ?? 0) > 0) {
    //   widget.callback(_deliveryType.toString(), _deliveryController.text);
    //   // }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: Duration.zero,
      child: Column(
        children: [
          _youJiView(),
          const SizedBox(height: 16),
          _ziQuView(),
          const SizedBox(height: 26),
        ],
      ),
    );
  }

  //统一定义一个圆角样式
  var customBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(style: BorderStyle.none));

  Widget _youJiView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: ThemeText(
                  text: '邮寄',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_deliveryType < 3) {
                    setState(() {
                      _deliveryType = 4;
                      _deliveryController.clear();
                    });
                  }
                  widget.callback(_deliveryType.toString(), _deliveryController.text);
                },
                child: _checkView(_deliveryType < 3),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _deliveryController,
            enabled: false,
            style: const TextStyle(
              color: Color(0xff484C52),
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              NumberTextInputFormatter(
                maxIntegerLength: null,
                maxDecimalLength: null,
                isAllowDecimal: true,
              ),
            ],
            decoration: InputDecoration(
              filled: true,
              border: customBorder,
              enabledBorder: customBorder,
              focusedBorder: customBorder,
              focusedErrorBorder: customBorder,
              errorBorder: customBorder,
              disabledBorder: customBorder,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              fillColor: const Color(0xffD9D9D9).withOpacity(0.4),
              hintText: '请选择邮寄方式',
              hintStyle: const TextStyle(
                color: Color(0xffCECECE),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 19),
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    if (_deliveryType == 1) {
                      _deliveryType = 4;
                      _deliveryController.clear();
                    } else {
                      _deliveryType = 1;
                      _deliveryController.text = '包邮';
                    }
                  });
                  widget.callback(_deliveryType.toString(), '包邮');
                },
                child: SizedBox(
                  width: 60,
                  child: PublishSheetItemChildView(
                    title: '包邮',
                    isSelected: _deliveryType == 1,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _calculatePostage();
                },
                child: SizedBox(
                  width: 100,
                  child: PublishSheetItemChildView(
                    title: '按距离估计',
                    isSelected: _deliveryType == 2,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _ziQuView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_pickUpType == 0) {
            _pickUpType = 1;
          } else {
            _pickUpType = 0;
          }
        });
        widget.pickUpCallback(_pickUpType.toString());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
        ),
        child: Row(
          children: [
            const Expanded(
              child: ThemeText(
                text: '线下自取',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            _checkView(_pickUpType == 1),
          ],
        ),
      ),
    );
  }

  Widget _checkView(bool isChoose) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xffE4D719).withOpacity(0.8),
      ),
      child: isChoose
          ? const Icon(
              Icons.check,
              size: 10,
            )
          : Container(),
    );
  }
}
