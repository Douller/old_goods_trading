import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';

import '../../widgets/theme_button.dart';
import '../../widgets/theme_text.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordTF = TextEditingController();
  final TextEditingController _newPasswordTF = TextEditingController();
  final TextEditingController _againPasswordTF = TextEditingController();

  bool _oldObscure = true;
  bool _newObscure = true;
  bool _againObscure = true;

  Future<void> _next() async {
    if (_oldPasswordTF.text.isEmpty) {
      ToastUtils.showText(text: '旧密码不能为空');
      return;
    }
    if (_newPasswordTF.text.isEmpty) {
      ToastUtils.showText(text: '新密码不能为空');
      return;
    }

    if (_newPasswordTF.text != _againPasswordTF.text) {
      ToastUtils.showText(text: '两次密码不一致');
      return;
    }
    ToastUtils.showLoading();
    bool res = await ServiceRepository.editPassword(
      oldPassword: _oldPasswordTF.text,
      password: _newPasswordTF.text,
      rePassword: _againPasswordTF.text,
    );
    if (res && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('修改密码'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                _passwordView(
                    title: '旧密码',
                    hintText: '请输入旧密码',
                    controller: _oldPasswordTF,
                    obscureText: _oldObscure,
                    onPressed: () {
                      setState(() {
                        _oldObscure = !_oldObscure;
                      });
                    }),
                const SizedBox(height: 24),
                _passwordView(
                    title: '新密码',
                    hintText: '请输入新密码',
                    controller: _newPasswordTF,
                    obscureText: _newObscure,
                    onPressed: () {
                      setState(() {
                        _newObscure = !_newObscure;
                      });
                    }),
                const SizedBox(height: 24),
                _passwordView(
                    title: '确认密码',
                    hintText: '请确认新密码',
                    controller: _againPasswordTF,
                    obscureText: _againObscure,
                    onPressed: () {
                      setState(() {
                        _againObscure = !_againObscure;
                      });
                    }),
                const SizedBox(height: 58),
                ThemeButton(
                  onPressed: _next,
                  height: 50,
                  text: '确认',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordView({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    VoidCallback? onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleView(title),
        const SizedBox(height: 12),
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
          ),
          child: _buildWordInputWidget(
            controller: controller,
            hintText: hintText,
            obscureText: obscureText,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }

  Widget _titleView(String text) {
    return ThemeText(
      text: text,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color(0xff223263),
    );
  }

  /// 单词输入框
  Widget _buildWordInputWidget({
    String? hintText,
    int? maxLines,
    TextInputType? keyboardType,
    TextEditingController? controller,
    required bool obscureText,
    VoidCallback? onPressed,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        focusedBorder: _inputBorder,
        disabledBorder: _inputBorder,
        enabledBorder: _inputBorder,
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
        ),
        border: _inputBorder,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        hintStyle: const TextStyle(
          color: Color(0xffCECECE),
          fontSize: 14,
        ),
      ),
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
    );
  }
}

InputBorder get _inputBorder {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(width: 1, color: Colors.transparent),
  );
}
