import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/back_button.dart';
import 'package:old_goods_trading/widgets/goods_star_view.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

import '../../constants/constants.dart';
import '../../page/mine/seller_personal_center.dart';
import '../../router/app_router.dart';
import '../theme_image.dart';

class GoodsDetailsAppBar extends StatelessWidget {
  final String? userIcon;
  final String? userName;
  final String? star;
  final String starIcon;
  final bool isFollow;
  final bool isSeller;
  final GestureTapCallback? onTap;
  final GestureTapCallback? userInfoOnTap;

  const GoodsDetailsAppBar({
    Key? key,
    this.userIcon,
    this.userName,
    this.star,
    required this.starIcon,
    this.isFollow = false,
    this.onTap,
    this.isSeller = false,
    this.userInfoOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const BackArrowButton(),
          const SizedBox(width: 11),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: userInfoOnTap,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: ThemeNetImage(
                    imageUrl: userIcon,
                    placeholderPath:
                        "${Constants.placeholderPath}user_placeholder.png",
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 8),
                ThemeText(
                  text: userName ?? '',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          const SizedBox(width: 13),
          GoodsStarView(
            starStr: star ?? '0',
            width: 14,
            height: 14,
            space: 6,
            fontSize: 16,
            starIcon: starIcon,
          ),
          Expanded(child: Container()),
          isSeller
              ? Container()
              : ThemeButton(
                  width: 60,
                  height: 26,
                  text: isFollow ? '已关注' : '关注',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  bgColor: isFollow
                      ? const Color(0xffCECECE)
                      : const Color(0xffDFD86D),
                  onPressed: onTap,
                ),
        ],
      ),
    );
  }
}
