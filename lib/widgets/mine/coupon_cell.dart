import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../model/my_coupon_model.dart';
import '../goods_price_text.dart';
import '../theme_button.dart';
import '../theme_text.dart';

class CouponCell extends StatelessWidget {
  final MyCouponModel model;

  const CouponCell({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            model.useStatus == '9'
                ? '${Constants.placeholderPath}coupon_expired.png'
                : '${Constants.placeholderPath}coupon_available.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 75,
            child: Row(
              children: [
                SizedBox(
                  width: 97,
                  child: GoodsPriceText(
                    priceStr: model.value ?? '',
                    textFontWeight: FontWeight.w600,
                    textFontSize: 30,
                    symbolFontWeight: FontWeight.w600,
                    symbolFontSize: 20,
                    color: model.useStatus == '9'
                        ? const Color(0xff2F3033)
                        : const Color(0xffFF3800),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ThemeText(
                          text: model.name ?? '',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: model.useStatus == '9'
                              ? const Color(0xff2F3033)
                              : const Color(0xffFF3800),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ThemeText(
                              text: '',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff999999),
                            ),
                            ThemeButton(
                              width: 70,
                              height: 30,
                              text: model.useStatus == '9'
                                  ? '已过期'
                                  : model.useStatus == '0'
                                      ? '未使用'
                                      : '已使用',
                              bgColor: model.useStatus == '9'
                                  ? const Color(0xffCECECE)
                                  : const Color(0xffFE734C).withOpacity(0.1),
                              textColor: model.useStatus == '9'
                                  ? Colors.white
                                  : const Color(0xffFE734C),
                            ),
                          ],
                        ),
                        ThemeText(
                          text: '${model.useBeginTime} ~ ${model.useEndTime}',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff999999),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 25,
            alignment: Alignment.centerLeft,
            child: const ThemeText(
              text: '通用优惠券',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff999999),
            ),
          ),
        ],
      ),
    );
  }
}
