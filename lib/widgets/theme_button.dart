import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final Color? bgColor;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final VoidCallback? onPressed;
  final double? radius;
  final EdgeInsetsGeometry? margin;
  const ThemeButton({
    Key? key,
    required this.text,
    this.width,
    this.height,
    this.bgColor,
    this.textColor,
    this.fontWeight,
    this.fontSize,
    this.onPressed,
    this.radius, this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        margin: margin,
        decoration: BoxDecoration(
          color: bgColor ?? const Color(0xffE4D719).withOpacity(0.8),
          borderRadius: BorderRadius.circular(radius ?? 100),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? const Color(0xff484C52),
            fontWeight: fontWeight ?? FontWeight.w500,
            fontSize: fontSize ?? 16,
          ),
        ),
      ),
    );
  }
}
