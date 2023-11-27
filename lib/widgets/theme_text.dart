import 'package:flutter/material.dart';

class ThemeText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final double? height;

  const ThemeText({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.color,
    this.textAlign,
    this.letterSpacing,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? const Color(0xff484C52),
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w500,
        letterSpacing: letterSpacing,
        height: height,
      ),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
