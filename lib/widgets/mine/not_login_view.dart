import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../page/login/login_page.dart';
import '../../router/app_router.dart';
import '../../states/user_info_state.dart';

class NotLoginView extends StatelessWidget {
  const NotLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Text(
            'Hi，小可爱',
            style: TextStyle(
                color: Color(0xff2F3033),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          Expanded(child: Container()),
          GestureDetector(
            // onTap: () => AppRouter.push(context, const LoginPage()),
            onTap: () async {
              bool login = await Provider.of<UserInfoViewModel>(
                  context,
                  listen: false)
                  .login();
            },
            child: Container(
              height: 30,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xffFE734C),
                borderRadius: BorderRadius.circular(44),
              ),
              child: const Text(
                '立即登录',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
