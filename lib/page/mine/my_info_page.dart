import 'package:flutter/material.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/states/user_info_state.dart';
import 'package:old_goods_trading/page/mine/edit_user_info.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({Key? key}) : super(key: key);

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final List<String> _itemTitleList = [
    '昵称',
    '性别',
    '出生日期',
    '个人简介',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('个人资料'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 34),
            _userAvatarView(),
            const SizedBox(height: 50),
            _itemView(),
          ],
        ),
      ),
    );
  }

  Widget _userAvatarView() {
    return Consumer<UserInfoViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            AppRouter.push(context, const EditUserInfoPage());
          },
          child: SizedBox(
            width: 94,
            height: 94,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(94),
              child: ThemeNetImage(
                imageUrl: value.userInfoModel?.avatar,
                width: 94,
                height: 94,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _itemView() {
    return Consumer<UserInfoViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        return Expanded(
          child: ListView.builder(
            itemCount: _itemTitleList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  AppRouter.push(context, const EditUserInfoPage());
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: [
                      ThemeText(
                        text: _itemTitleList[index],
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: ThemeText(
                          text: index == 0
                              ? value.userInfoModel?.nickName ?? ''
                              : index == 1
                                  ? value.userInfoModel?.sexLabel ?? ''
                                  : index == 2
                                      ? value.userInfoModel?.birthday ?? ''
                                      : value.userInfoModel?.remarks ?? '',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        '${Constants.iconsPath}right_arrow.png',
                        width: 8,
                        height: 8,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
