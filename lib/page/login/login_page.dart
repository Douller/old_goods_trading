// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:old_goods_trading/states/user_info_state.dart';
// import 'package:old_goods_trading/utils/regex.dart';
// import 'package:provider/provider.dart';
//
// class LoginPage extends StatefulWidget {
//   final bool? replace;
//
//   const LoginPage({Key? key, this.replace}) : super(key: key);
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   late final TextEditingController _phoneTEC = TextEditingController()
//     ..addListener(_loginBtnStatus);
//   late final TextEditingController _passwordTEC = TextEditingController()
//     ..addListener(_loginBtnStatus);
//
//   bool _isLogin = false;
//
//   void _loginBtnStatus() {
//     if (RegexUtils.isMobileExact(_phoneTEC.text) &&
//         _passwordTEC.text.isNotEmpty) {
//       setState(() {
//         _isLogin = true;
//       });
//     } else {
//       setState(() {
//         _isLogin = false;
//       });
//     }
//   }
//
//   Future<void> _loginIN() async {
//     bool login = await Provider.of<UserInfoViewModel>(context, listen: false)
//         .login();
//
//     if (mounted) {
//       Navigator.pop(context, login);
//     }
//     // MethodChannel channel = const MethodChannel('Authing');
//     // dynamic result = await channel.invokeMethod('login');
//     // print('flutter 接受的userInfo  ------- $result');
//   }
//
//   @override
//   void dispose() {
//     _phoneTEC.removeListener(_loginBtnStatus);
//     _passwordTEC.removeListener(_loginBtnStatus);
//     _phoneTEC.dispose();
//     _passwordTEC.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F6),
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               '手机号登录',
//               style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xff2F3033)),
//             ),
//             const SizedBox(height: 60),
//             _textFieldView(
//               controller: _phoneTEC,
//               hintText: '请输入手机号码',
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 20),
//             _textFieldView(
//               controller: _passwordTEC,
//               hintText: '请输入密码',
//               obscureText: true,
//             ),
//             const SizedBox(height: 40),
//             GestureDetector(
//               onTap: _loginIN,
//               child: Container(
//                 height: 44,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: _isLogin
//                       ? const Color(0xffFE734C)
//                       : const Color(0xffCECECE),
//                   borderRadius: BorderRadius.circular(44),
//                 ),
//                 child: const Text(
//                   '登录',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 18),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _textFieldView({
//     required TextEditingController controller,
//     required String hintText,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: const TextStyle(
//           color: Color(0xffCECECE),
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xffEEEEEE),
//             width: 1.0,
//           ),
//         ),
//       ),
//     );
//   }
// }
