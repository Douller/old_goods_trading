import 'package:flutter/material.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../page/mine/edit_user_info.dart';
import '../../page/mine/seller_personal_center.dart';
import '../../states/user_info_state.dart';
import 'not_login_view.dart';

class MineUserInfoView extends StatelessWidget {
  const MineUserInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        if (value.userInfoModel != null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      AppRouter.push(
                          context,
                          SellerPersonalCenter(
                              supplierId: value.userInfoModel?.id ?? ''));
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: ThemeNetImage(
                            imageUrl: value.userInfoModel?.avatar,
                            width: 64,
                            height: 64,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value.userInfoModel?.nickName ?? '未设置昵称',
                                style: const TextStyle(
                                  color: Color(0xff2F3033),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                value.userInfoModel?.mobile ?? '',
                                style: const TextStyle(
                                  color: Color(0xff484C52),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                value.userInfoModel?.email ?? '',
                                style: const TextStyle(
                                  color: Color(0xff484C52),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    AppRouter.push(context, const EditUserInfoPage());
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                    decoration: BoxDecoration(
                        color: const Color(0xffEDE573),
                        borderRadius: BorderRadius.circular(4)),
                    child: const ThemeText(
                      text: '编辑资料',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    value.btnClick(context, MinePageClickType.setting);
                  },
                  child: Container(
                    width: 28,
                    height: 31,
                    decoration: BoxDecoration(
                        color: const Color(0xffEDE573),
                        borderRadius: BorderRadius.circular(4)),
                    child: const Icon(
                      Icons.settings,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const NotLoginView();
        }
      },
    );
  }
}
