import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

class OrderButtonDialog extends StatelessWidget {
  final String title;

  const OrderButtonDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 62),
        padding:
            const EdgeInsets.only(left: 22, right: 22, top: 43, bottom: 20),
        constraints: const BoxConstraints(
          minHeight: 100,
          maxHeight: 600,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ThemeText(text: title, fontSize: 16, fontWeight: FontWeight.w700),
            // const SizedBox(height: 14),
            // const ThemeText(
            //   text: '如您的问题未解决完毕，请勿取消服务单。',
            //   fontSize: 14,
            //   fontWeight: FontWeight.w500,
            //   color: Color(0xff666666),
            // ),
            const SizedBox(height: 34),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xffFE734C))),
                      child: const ThemeText(
                        text: '返回',
                        color: Color(0xffFE734C),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xffFE734C),
                      ),
                      child: const ThemeText(
                        text: '确认',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
