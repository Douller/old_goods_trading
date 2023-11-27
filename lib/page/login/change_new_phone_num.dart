import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/phone_prefix_model.dart';
import '../../model/user_info_model.dart';
import '../../net/service_repository.dart';
import '../../router/app_router.dart';
import '../../states/user_info_state.dart';
import '../../utils/toast.dart';
import '../../widgets/theme_button.dart';
import '../../widgets/theme_text.dart';
import 'phone_prefix.dart';

class ChangeNewPhoneNum extends StatefulWidget {
  final List<PhonePrefixData> phonePrefixList;
  final String oldPhoneNumber;
  final String oldPhonePassCode;
  final String oldPhoneCountryCode;

  const ChangeNewPhoneNum(
      {Key? key,
      required this.phonePrefixList,
      required this.oldPhoneNumber,
      required this.oldPhonePassCode,
      required this.oldPhoneCountryCode})
      : super(key: key);

  @override
  State<ChangeNewPhoneNum> createState() => _ChangeNewPhoneNumState();
}

class _ChangeNewPhoneNumState extends State<ChangeNewPhoneNum> {
  final TextEditingController _newPhoneNum = TextEditingController();
  final TextEditingController _newPhoneCode = TextEditingController();
  int _newMsgCountDown = 0;
  Timer? _timer;

  List<PhonePrefixData> _phonePrefix = [];
  PhonePrefixData? _chooseModel;

  Future<void> _startCountDown() async {
    if (_newPhoneNum.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入手机号码');
      return;
    }
    if (_newMsgCountDown == 0 && _timer == null) {
      _newMsgCountDown = 60;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _newMsgCountDown--;
          });
        }
        if (_newMsgCountDown <= 0) {
          _timer?.cancel();
          _timer = null;
        }
      });

      await ServiceRepository.getPhoneCode(
        prefix: _chooseModel?.val ?? '',
        phone: _newPhoneNum.text.trim(),
        type: 'edit_new',
      );
    }
  }

  Future<void> _next() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_newPhoneNum.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入手机号码');
      return;
    }

    if (_newPhoneCode.text.trim().isEmpty) {
      ToastUtils.showText(text: '请输入验证码');
      return;
    }
    ToastUtils.showLoading();
    UserInfoModel? userInfoModel = await ServiceRepository.editMobile(
      prefix: _chooseModel?.val ?? '',
      phone: _newPhoneNum.text.trim(),
      code: _newPhoneCode.text.trim(),
      type: 'edit_new',
      oldPhoneNumber: widget.oldPhoneNumber,
      oldPhonePassCode: widget.oldPhonePassCode,
      oldPhoneCountryCode: widget.oldPhoneCountryCode,
    );
    if (userInfoModel != null) {
      if (!mounted) return;
      await Provider.of<UserInfoViewModel>(context, listen: false)
          .getUserInfo();

      ToastUtils.showText(text: '修改成功');
      if (!mounted) return;
      Navigator.pop(context);
    }
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
  void initState() {
    _phonePrefix = widget.phonePrefixList;
    _chooseModel = _phonePrefix.first;
    super.initState();
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
          title: const Text('修改手机号码'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                _phoneNumView(
                    title: '新手机号码',
                    hintText: '请输入新的手机号码',
                    controller: _newPhoneNum),
                const SizedBox(height: 24),
                _phoneCodeView(controller: _newPhoneCode),
                const SizedBox(height: 58),
                ThemeButton(
                  onPressed: _next,
                  height: 50,
                  text: '完成',
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
                    text: _newMsgCountDown <= 0
                        ? "获取验证码"
                        : "${_newMsgCountDown}s后重试",
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
