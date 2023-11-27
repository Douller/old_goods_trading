import 'package:flutter/material.dart';
import 'package:old_goods_trading/model/bank_model.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';

import '../../constants/constants.dart';
import '../../page/mine/add_band_card_page.dart';
import '../theme_text.dart';

class ChooseCardSheet extends StatefulWidget {
  final  List<Bank> bankCardList;
  const ChooseCardSheet({Key? key, required this.bankCardList}) : super(key: key);

  @override
  State<ChooseCardSheet> createState() => _ChooseCardSheetState();
}

class _ChooseCardSheetState extends State<ChooseCardSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      constraints: const BoxConstraints(maxHeight: 450),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ThemeText(text: '选择提现的银行卡', fontSize: 18),
            const SizedBox(height: 19),
            const Divider(color: Color(0xFFF2F3F5)),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.bankCardList.length,
                  itemBuilder: (context, index) {
                    return _listCellView(index);
                  }),
            ),
            const SizedBox(height: 17),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
                AppRouter.push(context, const AddBandCardPage());
              },
              child: Row(
                children: [
                  Image.asset(
                    '${Constants.iconsPath}add_card.png',
                    width: 20,
                    height: 14,
                  ),
                  const SizedBox(width: 9),
                  const ThemeText(text: '添加银行卡'),
                  Expanded(child: Container()),
                  Image.asset(
                    '${Constants.iconsPath}right_arrow.png',
                    width: 10,
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF2F3F5)),
          ],
        ),
      ),
    );
  }

  Widget _listCellView(int index) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ThemeNetImage(imageUrl: widget.bankCardList[index].bankImg,  width: 20,
            height: 20,),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                ThemeText(
                  text:  widget.bankCardList[index].bankName??'',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 4),
                const ThemeText(
                  text: '2小时到账',
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF2F3F5)),
              ],
            ),
          ),
          const Icon(
            Icons.check,
            color: Color(0xFFFE734C),
            size: 18,
          ),
        ],
      ),
    );
  }
}
