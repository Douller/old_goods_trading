import 'dart:async';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';
import 'package:provider/provider.dart';
import '../../model/user_info_model.dart';
import '../../router/app_router.dart';
import '../../states/user_info_state.dart';
import '../../widgets/theme_text.dart';
import 'change_new_email.dart';

class ModifyEmailPage extends StatefulWidget {
  final bool isBind;

  const ModifyEmailPage({Key? key, required this.isBind}) : super(key: key);

  @override
  State<ModifyEmailPage> createState() => _ModifyEmailPageState();
}

class _ModifyEmailPageState extends State<ModifyEmailPage> {
  final TextEditingController _oldEmailTF = TextEditingController();
  final TextEditingController _oldEmailCode = TextEditingController();

  //倒计时
  int _oldMsgCountDown = 0;
  Timer? _timer;

  Future<void> _startCountDown() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_oldEmailTF.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入邮箱地址');
      return;
    }

    if (!widget.isBind) {
      String oldEmail = Provider.of<UserInfoViewModel>(context, listen: false)
              .userInfoModel
              ?.email ??
          '';
      if (_oldEmailTF.text.trim() != oldEmail.trim()) {
        ToastUtils.showText(text: '输入的邮箱和原来的不一致');
        return;
      }
    }

    if (_oldMsgCountDown == 0 && _timer == null) {
      _oldMsgCountDown = 60;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _oldMsgCountDown--;
          });
        }
        if (_oldMsgCountDown <= 0) {
          _timer?.cancel();
          _timer = null;
        }
      });

      await ServiceRepository.getEmailCode(
        email: _oldEmailTF.text.trim(),
        type: widget.isBind ? 'bind' : 'edit',
      );
    }
  }

  Future<void> _next() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_oldEmailTF.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入邮箱');
      return;
    }

    if (!widget.isBind) {
      String oldEmail = Provider.of<UserInfoViewModel>(context, listen: false)
              .userInfoModel
              ?.email ??
          '';
      if (_oldEmailTF.text.trim() != oldEmail.trim()) {
        ToastUtils.showText(text: '输入的邮箱和原来的不一致');
        return;
      }
    }

    if (_oldEmailCode.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入验证码');
      return;
    }

    if (widget.isBind) {
      ToastUtils.showLoading();
      UserInfoModel? userInfoModel = await ServiceRepository.bindEmail(
        email: _oldEmailTF.text.trim(),
        code: _oldEmailCode.text.trim(),
        type: 'bind',
      );

      if (userInfoModel != null) {
        if (!mounted) return;
        await Provider.of<UserInfoViewModel>(context, listen: false)
            .getUserInfo();

        ToastUtils.showText(text: '绑定成功');
        if (!mounted) return;
        Navigator.pop(context);
      }
    } else {
      // bool res = await ServiceRepository.verifyEmailCode(
      //   email: _oldEmailTF.text.trim(),
      //   code: _oldEmailCode.text.trim(),
      //   type: 'edit',
      // );
      // if (res && mounted) {
      AppRouter.replace(context,
          newPage: ChangeNewEmail(
            oldEmail: _oldEmailTF.text.trim(),
            oldEmailPassCode: _oldEmailCode.text.trim(),
          ));
      // }
    }
  }

  @override
  void initState() {
    _oldEmailTF.text = Provider.of<UserInfoViewModel>(context, listen: false)
            .userInfoModel
            ?.email ??
        '';

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
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
          title: Text(widget.isBind ? '绑定邮箱' : '修改邮箱'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                _phoneNumView(
                    title: widget.isBind ? '邮箱地址' : '旧邮箱地址',
                    hintText: '请输入邮箱地址',
                    controller: _oldEmailTF),
                const SizedBox(height: 24),
                _phoneCodeView(controller: _oldEmailCode),
                const SizedBox(height: 58),
                ThemeButton(
                  onPressed: _next,
                  height: 50,
                  text: widget.isBind ? '提交' : '下一步',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _phoneNumView({
    required String title,
    required String hintText,
    required TextEditingController controller,
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
            keyboardType: TextInputType.emailAddress,
            hintText: hintText,
          ),
        ),
      ],
    );
  }

  Widget _phoneCodeView({required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleView('验证码'),
        const SizedBox(height: 12),
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildWordInputWidget(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    hintText: '请输入验证码'),
              ),
              GestureDetector(
                onTap: () => _startCountDown(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  child: ThemeText(
                    text: _oldMsgCountDown <= 0
                        ? "获取验证码"
                        : "${_oldMsgCountDown}s后重试",
                    color: Colors.blue,
                  ),
                ),
              )
            ],
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
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        focusedBorder: _inputBorder,
        disabledBorder: _inputBorder,
        enabledBorder: _inputBorder,
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
