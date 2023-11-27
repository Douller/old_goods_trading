import 'package:flutter/material.dart';

class GoodsStarView extends StatelessWidget {
  final String starStr;
  final String starIcon;
  final double? fontSize;
  final double? space;
  final double width;
  final double height;

  const GoodsStarView({
    Key? key,
    required this.starStr,
    this.fontSize,
    this.space = 5,
    required this.width,
    required this.height,
    required this.starIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          starIcon,
          width: width,
          height: height,
          color: const Color(0xffE4D719).withOpacity(0.8),
        ),
        SizedBox(width: space),
        Text(
          starStr,
          style: TextStyle(
            color: const Color(0xffE4D719).withOpacity(0.8),
            fontWeight: FontWeight.w400,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
