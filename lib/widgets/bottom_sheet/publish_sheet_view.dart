import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

class PublishSheetView extends StatelessWidget {
  final String title;
  final int index;
  final Widget child;

  const PublishSheetView({
    Key? key,
    required this.title,
    required this.index,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _topView(context),
            const SizedBox(height: 29),
            child,
            index == 3
                ? Container()
                : ThemeButton(
                    onPressed: () => Navigator.pop(context, true),
                    margin: const EdgeInsets.symmetric(horizontal: 56),
                    text: '确定',
                    height: 47,
                    radius: 16,
                  )
          ],
        ),
      ),
    );
  }

  Widget _topView(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ThemeText(
            text: title,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.centerRight,
            child: Image.asset(
              '${Constants.iconsPath}close.png',
              width: 12,
              height: 12,
            ),
          ),
        ),
        const SizedBox(width: 22),
      ],
    );
  }
}
