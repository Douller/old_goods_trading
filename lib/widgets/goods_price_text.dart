import 'package:flutter/material.dart';

class GoodsPriceText extends StatelessWidget {
  final String priceStr;
  final double? symbolFontSize;
  final double? textFontSize;
  final FontWeight? symbolFontWeight;
  final FontWeight textFontWeight;
  final Color? color;

  const GoodsPriceText({
    Key? key,
    required this.priceStr,
    this.color,
    this.symbolFontWeight,
    required this.textFontWeight,
    this.symbolFontSize,
    this.textFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '\$',
        children: [
          TextSpan(
            text: priceStr,
            style: TextStyle(
              fontSize: textFontSize,
              fontWeight: textFontWeight,
            ),
          ),
        ],
        style: TextStyle(
          fontSize: symbolFontSize,
          fontWeight: symbolFontWeight,
        ),
      ),
      style: TextStyle(
        color: color ?? const Color(0xffEA4545).withOpacity(0.8),
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
