import 'package:flutter/material.dart';
import '../constants/constants.dart';

class BackArrowButton extends StatelessWidget {
  final Color? color;

  const BackArrowButton({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 15,
        height: 15,
        alignment: Alignment.center,
        child: Image.asset(
          '${Constants.iconsPath}back_arrow.png',
          width: 15,
          height: 15,
          fit: BoxFit.contain,
          color: color,
        ),
      ),
    );
  }
}
