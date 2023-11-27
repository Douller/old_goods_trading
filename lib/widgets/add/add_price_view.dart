import 'package:flutter/material.dart';
import 'package:old_goods_trading/states/add_page_state.dart';
import 'package:old_goods_trading/widgets/bottom_sheet/add_price_sheet.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../model/add_publish_info_model.dart';
import '../../utils/custom_number_textinput.dart';
import '../theme_text.dart';

class AddPriceView extends StatelessWidget {

  const AddPriceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPageViewModel>(
        builder: (BuildContext context, value, Widget? child) {
      return Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 2),
        child: Column(
          children: [
            _priceTFView('购入价格', value.marketPriceController),
            const SizedBox(height: 14),
            _priceTFView('出售价格', value.shopPriceController),
            const SizedBox(height: 3),
            value.model == null
                ? Container()
                : Row(
                    children: [
                      ThemeText(
                        text: value.model?.serviceChargeDesc ?? '',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff484C52).withOpacity(0.4),
                      ),
                      ThemeText(
                        text: value.model?.serviceCharge ?? '',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFEA3F49),
                      )
                    ],
                  ),
          ],
        ),
      );
    });
  }

  Widget _priceTFView(String title, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: ThemeText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const ThemeText(
          text: '\$',
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Color(0xffEA3F49),
        ),
        IntrinsicWidth(
          child: TextField(
            controller: controller,
            style: const TextStyle(
              color: Color(0xffEA3F49),
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              NumberTextInputFormatter(
                maxIntegerLength: null,
                maxDecimalLength: null,
                isAllowDecimal: true,
              ),
            ],
            decoration: const InputDecoration.collapsed(
              hintText: '0.00',
              hintStyle: TextStyle(
                color: Color(0xffEA3F49),
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
