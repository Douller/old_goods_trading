import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';

class TabPickBtn extends StatelessWidget {
  final String text;
  final Color textColor;
  final String? btnIcon;
  final MainAxisAlignment mainAxisAlignment;
  final GestureTapCallback? onTap;

  const TabPickBtn({
    Key? key,
    required this.text,
    required this.textColor,
    this.btnIcon,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: Constants.screenWidth / 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 6),
            (btnIcon ?? '').isEmpty
                ? Container()
                : Image.network(
                    btnIcon!,
                    width: 10,
                    height: 10,
                    color: const Color(0xff999999),
                  )
          ],
        ),
      ),
    );
  }
}
