import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/delivery_info_model.dart';
import '../custom_stepper.dart';

class DeliverInfoView extends StatefulWidget {
  final bool isSell;
  final String orderId;

  const DeliverInfoView({Key? key, required this.isSell, required this.orderId})
      : super(key: key);

  @override
  State<DeliverInfoView> createState() => _DeliverInfoViewState();
}

class _DeliverInfoViewState extends State<DeliverInfoView> {
  DeliveryInfoModel? _deliveryInfoModel;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    ToastUtils.showLoading();
    DeliveryInfoModel? data = await ServiceRepository.getDeliveryInfo(
        orderId: widget.orderId, isSell: widget.isSell);
    ToastUtils.hiddenAllToast();
    if (data != null && data.item != null) {
      setState(() {
        _deliveryInfoModel = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      constraints: const BoxConstraints(maxHeight: 800),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _topView(),
              (_deliveryInfoModel == null ||
                      (_deliveryInfoModel?.item?.deliveryList ?? []).isEmpty)
                  ? Container()
                  : _stepView(),
              const Divider(color: Color(0xFFF2F3F5)),
              _bottomView(),
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
              text: '详细信息',
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
        const SizedBox(height: 20),
        Row(
          children: [
            ThemeNetImage(
              imageUrl: _deliveryInfoModel?.item?.deliveryImgage,
              width: 29,
              height: 29,
            ),
            const SizedBox(width: 7),
            ThemeText(
              text:
                  '${_deliveryInfoModel?.item?.deliveryCompany ?? ''} ${_deliveryInfoModel?.item?.deliveryNo ?? ''}',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            Expanded(child: Container()),
            (_deliveryInfoModel?.item?.deliveryPhone ?? '').isEmpty
                ? Container()
                : GestureDetector(
                    onTap: () => launchUrl(Uri(
                      scheme: 'tel',
                      path: _deliveryInfoModel?.item?.deliveryPhone,
                    )),
                    child: Image.asset(
                      '${Constants.iconsPath}phone.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Color(0xFFF2F3F5))
      ],
    );
  }

  Widget _stepView() {
    return CustomStepper(
      currentStep: 0,
      type: StepperType.vertical,
      steps: List.generate(
          (_deliveryInfoModel?.item?.deliveryList ?? []).length, (index) {
        return Step(
          title: Row(
            children: [
              ThemeText(
                text:
                    _deliveryInfoModel?.item?.deliveryList?[index].statusName ??
                        '',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              const SizedBox(width: 12),
              ThemeText(
                text:
                    _deliveryInfoModel?.item?.deliveryList?[index].statusInfo ??
                        '',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ],
          ),
          content: ThemeText(
            text:
                _deliveryInfoModel?.item?.deliveryList?[index].statusDesc ?? '',
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: const Color(0xFF999999),
          ),
        );
      }),
      circleView: List.generate(
          (_deliveryInfoModel?.item?.deliveryList ?? []).length, (index) {
        return Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color:
                index == 0 ? const Color(0xFFFE734C) : const Color(0xFFCECECE),
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
      lineColor: const Color(0xFFCECECE),
    );
  }

  Widget _bottomView() {
    return Row(
      children: [
        Image.asset(
          '${Constants.iconsPath}shou.png',
          width: 18,
          height: 18,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemeText(
                text: _deliveryInfoModel?.item?.addressAll ?? '',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              const SizedBox(height: 4),
              ThemeText(
                text: (_deliveryInfoModel?.item?.consignee ?? '') +
                    (_deliveryInfoModel?.item?.addressInfo?.telephone ?? ''),
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: const Color(0xFF999999),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
