import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/widgets/custom_stepper.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

import '../../model/my_sell_goods_model.dart';
import '../bottom_sheet/deliver_info_view.dart';

class OrderStepperView extends StatelessWidget {
  final bool isSell;
  final MySellGoodsData? model;

  const OrderStepperView({Key? key, this.model, required this.isSell})
      : super(key: key);

  void _pushDeliverInfoView(BuildContext context, bool isSell) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          return DeliverInfoView(isSell: isSell, orderId: model!.id!,);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: _buildStepper(context),
    );
  }

  Widget _buildStepper(BuildContext context) {
    return GestureDetector(
      onTap: () => _pushDeliverInfoView(context, isSell),
      child: CustomStepper(
        currentStep: 0,
        type: StepperType.vertical,
        steps: [
          Step(
            title: Row(
              children: [
                ThemeText(
                  text: model?.deliveryInfo?.statusName ?? '',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                const SizedBox(width: 12),
                ThemeText(
                  text: model?.deliveryInfo?.statusDesc ?? '',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                Expanded(child: Container()),
                const ThemeText(
                  text: '查看详情',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
                const SizedBox(width: 6),
                Image.asset(
                  '${Constants.iconsPath}right_arrow.png',
                  width: 7,
                  height: 7,
                )
              ],
            ),
            content: ThemeText(
              text: model?.deliveryInfo?.statusInfo ?? '',
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: const Color(0xFF999999),
            ),
          ),
          Step(
            title: ThemeText(
              text: model?.addressAll ?? '',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            content: ThemeText(
              text:
                  "${model?.addressInfo?.consignee ?? ''} ${model?.addressInfo?.telephone ?? ''}",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: const Color(0xFF999999),
            ),
          ),
        ],
        circleView: List.generate(2, (index) {
          return Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: index == 0 ? const Color(0xFFFE734C) : Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0xFFFE734C)),
            ),
          );
        }).toList(),
        lineColor: const Color(0xFFFE734C),
      ),
    );
  }
}
