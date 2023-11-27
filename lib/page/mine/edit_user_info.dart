import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/page/login/modify_email_page.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../constants/constants.dart';
import '../../model/user_info_model.dart';
import '../../net/service_repository.dart';
import '../../states/user_info_state.dart';
import '../../widgets/bottom_sheet/brith_day_sheet_view.dart';
import '../../widgets/bottom_sheet/cream_cupertino_sheet.dart';
import '../../widgets/theme_image.dart';
import '../../widgets/theme_text.dart';
import '../login/modify_phone_num.dart';

class EditUserInfoPage extends StatefulWidget {
  const EditUserInfoPage({Key? key}) : super(key: key);

  @override
  State<EditUserInfoPage> createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  String? _nicknameString;
  String? _userPhoneString;
  String? _userEmailString;
  String? _sexStr;
  String? _chooseImagesPath;
  String? _birthday;
  String? _remarks;
  final FocusNode _nicknameFn = FocusNode();
  final FocusNode _remarksFn = FocusNode();

  List<AssetEntity> _entityList = [];
  final TextEditingController _nicknameEditingController =
      TextEditingController();

  final TextEditingController _remarksEditingController =
      TextEditingController();

  void _sheetBrithDayView({String? brithStr, bool isSex = false}) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return BrithDaySheetView(
            brithStr: brithStr,
            isSex: isSex,
            callback: (String dateString) {
              if (isSex) {
                setState(() {
                  _sexStr = dateString;
                });
              } else {
                setState(() {
                  _birthday = dateString;
                });
              }
            },
          );
        });
  }

  Future<void> _saveUserInfo() async {
    FocusScope.of(context).requestFocus(FocusNode());
    ToastUtils.showLoading();
    _nicknameString = _nicknameEditingController.text;
    if ((_nicknameString ?? "").isEmpty) {
      _nicknameString = Provider.of<UserInfoViewModel>(context, listen: false)
          .userInfoModel
          ?.nickName;
    }

    _userPhoneString = Provider.of<UserInfoViewModel>(context, listen: false)
        .userInfoModel
        ?.mobile;

    _userEmailString = Provider.of<UserInfoViewModel>(context, listen: false)
        .userInfoModel
        ?.email;

    _remarks = _remarksEditingController.text;
    if ((_remarks ?? "").isEmpty) {
      _remarks = Provider.of<UserInfoViewModel>(context, listen: false)
          .userInfoModel
          ?.remarks;
    }

    String? imagePath;
    if ((_chooseImagesPath ?? '').isNotEmpty) {
      imagePath = await ServiceRepository.uploadImage(
          imagePath: _chooseImagesPath!, filename: 'uploadImg');
    }
    UserInfoModel? model = await ServiceRepository.userEdit(
      nickname: _nicknameString,
      username: _userPhoneString,
      birthday: _birthday ?? '1999-09-09',
      sex: _sexStr,
      remarks: _remarks,
      email: _userEmailString,
      avatar: imagePath,
    );
    if (!mounted) return;
    await Provider.of<UserInfoViewModel>(context, listen: false).getUserInfo();
    if (model != null) {
      ToastUtils.showText(text: '修改成功');
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _pickPhotoOrCamera(int index) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (index == 0) {
      PermissionStatus status;
      if (Platform.isIOS) {
        status = await Permission.photosAddOnly.request();
      } else {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        if (!mounted) return;
        List<AssetEntity>? entityList = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: 1,
            selectedAssets: _entityList,
            requestType: RequestType.image,
          ),
        );
        if (entityList == null) return;
        _entityList = entityList;
      } else {
        openSetting();

        return;
      }
    } else {
      PermissionStatus status = await Permission.camera.request();

      if (status.isGranted) {
        if (!mounted) return;
        AssetEntity? entity = await CameraPicker.pickFromCamera(context);
        if (entity == null) return;
        _entityList.add(entity);
      } else {
        openSetting();
        return;
      }
    }

    File? imgFile = await _entityList.first.file;
    _chooseImagesPath = imgFile?.path;

    if (mounted) {
      setState(() {});
    }
  }

  void openSetting() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('您需要授予权限'),
            content: const Text('需要您在设置页面打开相册相关权限才能使用此功能'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('确认'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<void> _showSheetAction() async {
    FocusScope.of(context).requestFocus(FocusNode());
    var result = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return const CreamCupertinoSheet();
        });

    if (result == 'photo') {
      if (mounted) {
        await _pickPhotoOrCamera(0);
      }
    } else if (result == 'cream') {
      if (mounted) {
        await _pickPhotoOrCamera(1);
      }
    }
  }

  @override
  void initState() {
    var model = Provider.of<UserInfoViewModel>(context, listen: false);
    _sexStr = model.userInfoModel?.sex;
    if ((model.userInfoModel?.nickName ?? '').isNotEmpty) {
      _nicknameEditingController.text = model.userInfoModel!.nickName!;
    }

    if ((model.userInfoModel?.remarks ?? '').isNotEmpty) {
      _remarksEditingController.text = model.userInfoModel!.remarks!;
    }
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
          title: const Text('编辑资料'),
          actions: [
            TextButton(
              onPressed: _saveUserInfo,
              child: const ThemeText(
                text: '保存',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        body: Consumer<UserInfoViewModel>(
            builder: (BuildContext context, value, Widget? child) {
          return ListView(
            children: [
              _userAvatarView(value.userInfoModel?.avatar),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 38, vertical: 30),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xffE4D719).withOpacity(0.8)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _editNickNameView(value.userInfoModel?.nickName),
                    _editUserPhoneView(value.userInfoModel?.mobile ?? ''),
                    _editUserEmail(value.userInfoModel?.email),
                    _chooseSexView(),
                    _birthView(_birthday ?? value.userInfoModel?.birthday),
                    _briefIntroduction(value.userInfoModel?.remarks),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  //头像
  Widget _userAvatarView(String? avatar) {
    return Container(
      padding: const EdgeInsets.only(top: 47, bottom: 29),
      alignment: Alignment.center,
      color: Colors.white,
      child: GestureDetector(
        onTap: _showSheetAction,
        child: SizedBox(
          width: 82,
          height: 82,
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(94),
                child: _entityList.isEmpty
                    ? ThemeNetImage(
                        imageUrl: avatar,
                        width: 82,
                        height: 82,
                      )
                    : AssetEntityImage(
                        _entityList.first,
                        isOriginal: false,
                        width: 82,
                        height: 82,
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.only(top: 9),
                alignment: Alignment.center,
                width: 22,
                height: 22,
                child: Image.asset(
                  '${Constants.iconsPath}carme.png',
                  width: 13,
                  height: 13,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //用户昵称
  Widget _editNickNameView(String? name) {
    return SizedBox(
        height: 72,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _nicknameFn.requestFocus(),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ThemeText(
                      text: '昵称',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      focusNode: _nicknameFn,
                      controller: _nicknameEditingController,
                      style: const TextStyle(
                        color: Color(0xffABABAB),
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                      ),
                      decoration: InputDecoration.collapsed(
                          hintText: name ?? '',
                          hintStyle: const TextStyle(
                            color: Color(0xffABABAB),
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          )),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xffABABAB),
              ),
            ],
          ),
        ));
  }

  //手机号码
  Widget _editUserPhoneView(String phoneNum) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        AppRouter.push(context, ModifyPhoneNum(isBind: phoneNum.isEmpty));
      },
      child: SizedBox(
          height: 72,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ThemeText(
                      text: '手机号码',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 6),
                    // Consumer<UserInfoViewModel>(builder:
                    //     (BuildContext context, provider, Widget? child) {
                    //   return
                    ThemeText(
                      text: phoneNum,
                      color: const Color(0xffABABAB),
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                    // })
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xffABABAB),
              ),
            ],
          )),
    );
  }

  //邮箱
  Widget _editUserEmail(String? email) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        AppRouter.push(context, ModifyEmailPage(isBind: (email ?? '').isEmpty));
      },
      child: SizedBox(
          height: 72,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ThemeText(
                      text: '邮箱',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 6),
                    ThemeText(
                      text: email ?? '',
                      color: const Color(0xffABABAB),
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xffABABAB),
              ),
            ],
          )),
    );
  }

  //性别
  Widget _chooseSexView() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _sheetBrithDayView(isSex: true),
      child: SizedBox(
          height: 72,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ThemeText(
                      text: '性别',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 6),
                    ThemeText(
                      text: _sexStr == '0'
                          ? '保密'
                          : _sexStr == '1'
                              ? '男'
                              : '女',
                      color: const Color(0xffABABAB),
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xffABABAB),
              ),
            ],
          )),
    );
  }

  Widget _birthView(String? text) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _sheetBrithDayView(brithStr: text),
      child: SizedBox(
          height: 72,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ThemeText(
                      text: '生日',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 6),
                    ThemeText(
                      text: text ?? '',
                      color: const Color(0xffABABAB),
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xffABABAB),
              ),
            ],
          )),
    );
  }

  Widget _briefIntroduction(String? hitText) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _remarksFn.requestFocus(),
      child: SizedBox(
          height: 72,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ThemeText(
                      text: '个人简介',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      constraints: const BoxConstraints(
                        minHeight: 44,
                        maxHeight: 200,
                      ),
                      child: TextField(
                        controller: _remarksEditingController,
                        focusNode: _remarksFn,
                        maxLines: null,
                        decoration: InputDecoration.collapsed(
                          hintText: hitText ?? '请输入个人简介',
                          hintStyle: const TextStyle(
                            color: Color(0xffABABAB),
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xffABABAB),
              ),
            ],
          )),
    );
  }
}
