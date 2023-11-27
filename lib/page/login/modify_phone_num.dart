import 'dart:async';

import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/page/login/phone_prefix.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';
import 'package:provider/provider.dart';

import '../../model/phone_prefix_model.dart';
import '../../model/user_info_model.dart';
import '../../router/app_router.dart';
import '../../states/user_info_state.dart';
import '../../widgets/theme_text.dart';
import 'change_new_phone_num.dart';

class ModifyPhoneNum extends StatefulWidget {
  final bool isBind;

  const ModifyPhoneNum({Key? key, required this.isBind}) : super(key: key);

  @override
  State<ModifyPhoneNum> createState() => _ModifyPhoneNumState();
}

class _ModifyPhoneNumState extends State<ModifyPhoneNum> {
  final TextEditingController _oldPhoneNum = TextEditingController();
  final TextEditingController _oldPhoneCode = TextEditingController();

  //倒计时
  int _oldMsgCountDown = 0;
  Timer? _timer;

  List<PhonePrefixData> _phonePrefix = [];
  PhonePrefixData? _chooseModel;

  Future<void> _getPhonePrefix() async {
    ToastUtils.showLoading();
    PhonePrefixModel? prefixModel = await ServiceRepository.getPhonePrefix();
    if (prefixModel != null && (prefixModel.data ?? []).isNotEmpty) {
      setState(() {
        _phonePrefix = prefixModel.data ?? [];
        _chooseModel = _phonePrefix.first;
      });
    }
  }

  Future<void> _startCountDown() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_oldPhoneNum.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入手机号码');
      return;
    }

    if (!widget.isBind) {
      String oldPhoneStr =
          Provider.of<UserInfoViewModel>(context, listen: false)
                  .userInfoModel
                  ?.mobile ??
              '';
      if (_oldPhoneNum.text.trim() != oldPhoneStr.trim()) {
        ToastUtils.showText(text: '输入的手机号码和原来的不一致');
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

      await ServiceRepository.getPhoneCode(
        prefix: _chooseModel?.val ?? '',
        phone: _oldPhoneNum.text.trim(),
        type: widget.isBind ? 'bind' : 'edit',
      );
    }
  }

  Future<void> _next() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_oldPhoneNum.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入手机号码');
      return;
    }

    if (!widget.isBind) {
      String oldPhoneStr =
          Provider.of<UserInfoViewModel>(context, listen: false)
                  .userInfoModel
                  ?.mobile ??
              '';
      if (_oldPhoneNum.text.trim() != oldPhoneStr.trim()) {
        ToastUtils.showText(text: '输入的手机号码和原来的不一致');
        return;
      }
    }

    if (_oldPhoneCode.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入验证码');
      return;
    }

    if (widget.isBind) {
      ToastUtils.showLoading();
      UserInfoModel? userInfoModel = await ServiceRepository.bindPhone(
        phone: _oldPhoneNum.text.trim(),
        code: _oldPhoneCode.text.trim(),
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
      // bool res = await ServiceRepository.verifyPhoneCode(
      //   phone: _oldPhoneNum.text.trim(),
      //   code: _oldPhoneCode.text.trim(),
      //   type: 'edit',
      // );
      // if (res && mounted) {
      AppRouter.replace(context,
          newPage: ChangeNewPhoneNum(
            phonePrefixList: _phonePrefix,
            oldPhoneNumber: _oldPhoneNum.text.trim(),
            oldPhonePassCode: _oldPhoneCode.text.trim(),
            oldPhoneCountryCode: _chooseModel?.val ?? '',
          ));
      // }
    }
  }

  @override
  void initState() {
    _oldPhoneNum.text = Provider.of<UserInfoViewModel>(context, listen: false)
            .userInfoModel
            ?.mobile ??
        '';
    _getPhonePrefix();
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
          title: Text(widget.isBind ? '绑定手机号' : '修改手机号码'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                _phoneNumView(
                  title: widget.isBind ? '手机号码' : '旧手机号码',
                  hintText: '请输入手机号码',
                  controller: _oldPhoneNum,
                ),
                const SizedBox(height: 24),
                _phoneCodeView(controller: _oldPhoneCode),
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
          child: Row(
            children: [
              _prefixView(),
              Expanded(
                child: _buildWordInputWidget(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  hintText: hintText,
                  enabled: widget.isBind,
                ),
              )
            ],
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

  Widget _prefixView() {
    return _phonePrefix.isEmpty
        ? Container()
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              AppRouter.push(
                      context, PhonePrefixPage(phonePrefixList: _phonePrefix))
                  .then((value) {
                if (value != null && value is PhonePrefixData) {
                  setState(() {
                    _chooseModel = value;
                  });
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(left: 2),
              padding: const EdgeInsets.only(left: 4),
              height: 50,
              alignment: Alignment.center,
              child: Row(
                children: [
                  ThemeText(
                    text: _chooseModel?.val ?? '',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff223263),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Color(0xff223263)),
                ],
              ),
            ),
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
