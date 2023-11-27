import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:old_goods_trading/page/mine/my_info_page.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/utils/sp_manager.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../states/seller_personal_center_state.dart';
import '../theme_text.dart';

class SellerCenterUserInfoView extends StatelessWidget {
  const SellerCenterUserInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerPersonalCenterViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 219,
              decoration: BoxDecoration(
                color: const Color(0xff000000).withOpacity(0.2),
                image: value.userInfoModel?.avatar == null
                    ? null
                    : DecorationImage(
                        image: CachedNetworkImageProvider(
                            value.userInfoModel?.avatar ?? ''),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 135,
                width: Constants.screenWidth,
                padding: const EdgeInsets.only(left: 21, right: 12, top: 12),
                decoration: const BoxDecoration(
                  color: Color(0xffF2F3F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Container()),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (SharedPreferencesUtils.getUserInfoModel()?.id ==
                                value.userInfoModel?.id) {
                              AppRouter.push(context, const MyInfoPage());
                            } else {
                              if ((value.follow ?? false) == false) {
                                value.collectAndAdd(
                                    supplierId: value.userInfoModel?.id);
                              } else {
                                value.collectDelete(
                                    supplierId: value.userInfoModel?.id);
                              }

                            }
                          },
                          child: Container(
                            height: 28,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              color: (value.follow ?? false) == false
                                  ? const Color(0xffFE734C)
                                  : const Color(0xffCECECE),
                            ),
                            child: ThemeText(
                              text: SharedPreferencesUtils.getUserInfoModel()
                                          ?.id ==
                                      value.userInfoModel?.id
                                  ? '编辑'
                                  : (value.follow ?? false) == false
                                      ? '关注'
                                      : '已关注',
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ThemeText(
                      text: value.userInfoModel?.nickName ?? '',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: ThemeText(
                            text: value.userInfoModel?.content ?? '',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        ThemeText(
                          text: '评分 ${value.userInfoModel?.sorce ?? ''}分',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: List.generate(5, (index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 2),
                              child: Image.asset(
                                scoreImagePath(
                                    index,
                                    num.parse(
                                        value.userInfoModel?.sorce ?? '0')),
                                width: 12,
                                height: 12,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ThemeText(
                          text: value.userInfoModel?.follow ?? '0',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        const SizedBox(width: 4),
                        const ThemeText(
                          text: '关注',
                          fontWeight: FontWeight.w500,
                          color: Color(0xff999999),
                          fontSize: 12,
                        ),
                        const SizedBox(width: 16),
                        ThemeText(
                          text: value.userInfoModel?.follower ?? '0',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        const SizedBox(width: 4),
                        const ThemeText(
                          text: '粉丝',
                          fontWeight: FontWeight.w500,
                          color: Color(0xff999999),
                          fontSize: 12,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 95,
              child: Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(left: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(width: 2, color: Colors.white),
                  color: const Color(0xff000000).withOpacity(0.2),
                  image: value.userInfoModel?.avatar == null
                      ? null
                      : DecorationImage(
                          image: CachedNetworkImageProvider(
                              value.userInfoModel?.avatar ?? ''),
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String scoreImagePath(index, num score) {
    if (score == 0) {
      return "${Constants.iconsPath}empty_star.png";
    } else if (score <= 1) {
      return index == 0
          ? itemImagePath(score)
          : "${Constants.iconsPath}empty_star.png";
    } else if (score > 1 && score <= 2) {
      return index == 1
          ? itemImagePath(score)
          : index < 1
              ? "${Constants.iconsPath}full_star.png"
              : "${Constants.iconsPath}empty_star.png";
    } else if (score > 2 && score <= 3) {
      return index == 2
          ? itemImagePath(score)
          : index < 2
              ? "${Constants.iconsPath}full_star.png"
              : "${Constants.iconsPath}empty_star.png";
    } else if (score > 3 && score <= 4) {
      return index == 3
          ? itemImagePath(score)
          : index < 3
              ? "${Constants.iconsPath}full_star.png"
              : "${Constants.iconsPath}empty_star.png";
    } else if (score > 4 && score <= 5) {
      return index == 4
          ? itemImagePath(score)
          : "${Constants.iconsPath}full_star.png";
    } else {
      return "${Constants.iconsPath}full_star.png";
    }
  }

  String itemImagePath(num score) {
    List splitList = score.toString().split('.');
    if (splitList.length != 2) {
      return "${Constants.iconsPath}empty_star.png";
    }
    if (num.parse(splitList.last) == 0) {
      return "${Constants.iconsPath}full_star.png";
    } else if (num.parse(splitList.last) == 1) {
      return "${Constants.iconsPath}star1.png";
    } else if (num.parse(splitList.last) == 2) {
      return "${Constants.iconsPath}star2.png";
    } else if (num.parse(splitList.last) == 3) {
      return "${Constants.iconsPath}star3.png";
    } else if (num.parse(splitList.last) == 4) {
      return "${Constants.iconsPath}star4.png";
    } else if (num.parse(splitList.last) == 5) {
      return "${Constants.iconsPath}half_star.png";
    } else if (num.parse(splitList.last) == 6) {
      return "${Constants.iconsPath}star6.png";
    } else if (num.parse(splitList.last) == 7) {
      return "${Constants.iconsPath}star7.png";
    } else if (num.parse(splitList.last) == 8) {
      return "${Constants.iconsPath}star8.png";
    } else if (num.parse(splitList.last) == 9) {
      return "${Constants.iconsPath}star9.png";
    } else {
      return "${Constants.iconsPath}full_star.png";
    }
  }
}
