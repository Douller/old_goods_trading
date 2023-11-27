import 'package:flutter/material.dart';

class AgingDegreeView extends StatelessWidget {
  final double? width;
  final double? height;
  final String agingDegreeStr;
  final double? fontSize;
  final FontWeight? fontWeight;

  const AgingDegreeView({
    Key? key,
    required this.agingDegreeStr,
    this.width = 50,
    this.height,
    this.fontSize = 10,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return agingDegreeStr.isEmpty
        ? Container()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            height: height,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xff2AA4E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              agingDegreeStr,
              style: TextStyle(
                color: const Color(0xff2AA4E5),
                fontWeight: fontWeight ?? FontWeight.w500,
                fontSize: fontSize,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
  }
}
