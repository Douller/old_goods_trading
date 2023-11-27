import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/page/add/choose_location_page.dart';
import 'package:old_goods_trading/page/mine/add_address_page.dart';
import 'package:old_goods_trading/page/mine/my_address_page.dart';
import 'package:old_goods_trading/states/add_page_state.dart';
import 'package:old_goods_trading/states/user_info_state.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../../model/home_goods_list_model.dart';
import '../../router/app_router.dart';
import '../../utils/refresh_publish_event_bus.dart';
import '../../widgets/add/add_goods_describe_text_field.dart';
import '../../widgets/add/add_photo_btn.dart';
import '../../widgets/add/add_price_view.dart';
import '../../widgets/bottom_sheet/cream_cupertino_sheet.dart';
import '../mine/my_publish_page.dart';

class AddPage extends StatefulWidget {
  final GoodsInfoModel? publishModel;

  const AddPage({Key? key, this.publishModel}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final AddPageViewModel _addPageViewModel = AddPageViewModel();

  List<Widget> _imageListView = [];

  List<AssetEntity> _assets = [];

  final List _oldImages = [];

  final List<String> _chooseImagesPath = [];

  StreamSubscription? subscription;

  //删除选中图片
  Future<void> removeAsset(AssetEntity entity) async {
    _assets.remove(entity);
    File? imgFile = await entity.file;
    if (imgFile == null) return;
    _chooseImagesPath.remove(imgFile.path);

    _imageListView.clear();
    _imageListView.add(AddPhotoBtn(onTap: _showSheetAction));
    for (var entity in _assets) {
      _imageListView.insert(
          _imageListView.length - 1,
          AddImageView(
            entity: entity,
            index: _imageListView.length - 1,
            previewAssets: _assets,
            callBack: (AssetEntity entity) {
              removeAsset(entity);
            },
          ));
    }
    for (Gallery item in _oldImages) {
      _imageListView.insert(
        _imageListView.length - 1,
        PublishNetWorkImage(
          model: item,
          index: _imageListView.length - 1,
          callBack: (Gallery item) {
            _removePublishNetWorkImage(item);
          },
        ),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _openSetting() {
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

  Future<void> _pickPhotoOrCamera(int index) async {
    if (index == 0) {
      PermissionStatus status;
      if (Platform.isIOS) {
        status = await Permission.photosAddOnly.request();
      } else {
        status = await Permission.storage.request();
      }
      if (!status.isGranted) {
        _openSetting();
        return;
      }
      if (!mounted) return;
      List<AssetEntity>? entityList = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: 9,
          selectedAssets: _assets,
          requestType: RequestType.image,
        ),
      );
      if (entityList == null) return;
      _assets = entityList;
    } else {
      PermissionStatus status = await Permission.camera.request();

      if (!status.isGranted) {
        _openSetting();
        return;
      }
      if (!mounted) return;
      AssetEntity? entity = await CameraPicker.pickFromCamera(context);
      if (entity == null) return;
      _assets.add(entity);
    }

    for (var model in _assets) {
      File? imgFile = await model.file;
      if (imgFile == null) return;

      if (!_chooseImagesPath.contains(imgFile.path)) {
        _chooseImagesPath.add(imgFile.path);
        _imageListView.insert(
            _imageListView.length - 1,
            AddImageView(
              entity: model,
              index: _imageListView.length - 1,
              previewAssets: _assets,
              callBack: (AssetEntity entity) => removeAsset(entity),
            ));
      }

      if (_imageListView.length == 10) {
        _imageListView.removeLast();
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _showSheetAction() async {
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

  //删除编辑页面传过来的图片
  void _removePublishNetWorkImage(Gallery item) {
    _chooseImagesPath.remove(item.image);
    _oldImages.remove(item);

    _imageListView.clear();
    _imageListView.add(AddPhotoBtn(onTap: _showSheetAction));

    for (Gallery item in _oldImages) {
      _imageListView.insert(
        _imageListView.length - 1,
        PublishNetWorkImage(
          index: _imageListView.length - 1,
          model: item,
          callBack: (Gallery item) {
            _removePublishNetWorkImage(item);
          },
        ),
      );
    }
    for (var entity in _assets) {
      _imageListView.insert(
          _imageListView.length - 1,
          AddImageView(
            entity: entity,
            index: _imageListView.length - 1,
            previewAssets: _assets,
            callBack: (AssetEntity entity) {
              removeAsset(entity);
            },
          ));
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _addPageViewModel.getAddCategoryData();
    _addPageViewModel.getPublishCategoryData();
    _addPageViewModel.requestLocationPermission(context);
    _imageListView = [AddPhotoBtn(onTap: _showSheetAction)];

    subscription = eventBus.on<ChooseLocation>().listen((event) {
      _addPageViewModel.changeAddressLocation(
          event.latitude, event.longitude, event.address);
    });

    ///从草稿箱进入
    if (widget.publishModel != null) {
      _addPageViewModel.setOriginalValue(widget.publishModel!);

      _oldImages.addAll(widget.publishModel!.gallery ?? []);
      if (_oldImages.isNotEmpty) {
        for (Gallery item in _oldImages) {
          _chooseImagesPath.add(item.image ?? '');
          _imageListView.insert(
            _imageListView.length - 1,
            PublishNetWorkImage(
              index: _imageListView.length - 1,
              model: item,
              callBack: (Gallery item) {
                _removePublishNetWorkImage(item);
              },
            ),
          );
        }
      }

      if (_imageListView.length == 10) {
        _imageListView.removeLast();
      }
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
      child: ChangeNotifierProvider(
        create: (BuildContext context) => _addPageViewModel,
        child: Scaffold(
          backgroundColor: const Color(0xffFAFAFA),
          appBar: AppBar(),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _imageListView,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _addPageViewModel.titleTEC,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 5),
                  border: InputBorder.none,
                  hintText: '添加标题',
                  hintStyle: TextStyle(
                    color: const Color(0xff484C52).withOpacity(0.4),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                maxLines: 1,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 1,
                color: const Color(0xffE4D719).withOpacity(0.2),
              ),
              const AddGoodsDescribeTextField(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _locationView(),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 1,
                color: const Color(0xffE4D719).withOpacity(0.2),
              ),
              const SizedBox(height: 20),
              const AddPriceView(),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 1,
                color: const Color(0xffE4D719).withOpacity(0.2),
              ),
              _goodsInfoChooseView(
                '产品信息',
                () => _addPageViewModel.showBottomSheet(
                  context,
                  0,
                  '产品信息：时间/使用程度',
                ),
                '${_addPageViewModel.purchaseTime} ${_addPageViewModel.brushingCondition}',
              ),
              _goodsInfoChooseView(
                '产品尺寸',
                () => _addPageViewModel.showBottomSheet(context, 1, '产品尺寸'),
                _addPageViewModel.boxSize,
              ),
              _goodsInfoChooseView(
                '发货方式',
                () =>
                    _addPageViewModel.showBottomSheet(context, 2, '发货方式：包邮/自提'),
                _addPageViewModel.selfPickup == '1'
                    ? '线下自取'
                    : _addPageViewModel.deliveryType == '4'
                        ? '未选择'
                        : _addPageViewModel.deliveryType == '1'
                            ? '包邮'
                            : '快递',
              ),
              _goodsInfoChooseView(
                '商品类别',
                () => _addPageViewModel.showBottomSheet(context, 3, '商品类别'),
                _addPageViewModel.chooseCategoryString,
              ),
              const SizedBox(height: 24),
              _bottomView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationView() {
    return Consumer<AddPageViewModel>(
      builder: (BuildContext context, provider, Widget? child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            AppRouter.push(
                context,
                ChooseLocationPage(
                  latitude: provider.latitude,
                  longitude: provider.longitude,
                  keywords: provider.locationText,
                  locationCallBack: (
                    String latitude,
                    String longitude,
                    String address,
                    String city,
                    String provinceName,
                    String addressId,
                    String addressInfo,
                    String zipcode,
                    String addressAll,
                  ) {
                    provider.changeAddressLocation(
                      latitude,
                      longitude,
                      address,
                    );
                  },
                ));
          },
          child: Container(
              height: 26,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 24,
                    color: const Color(0xff484C52).withOpacity(0.4),
                  ),
                  ThemeText(
                    text: provider.locationText,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff484C52).withOpacity(0.4),
                  ),
                ],
              )),
        );
      },
    );
  }

  Widget _goodsInfoChooseView(
      String title, GestureTapCallback? onTap, String subtitle) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 53,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                    child: ThemeText(
                  text: title,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                )),
                ThemeText(
                  text: subtitle.isEmpty ? '未选择' : subtitle,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black26,
                ),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xff231F20).withOpacity(0.4),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 1,
            color: const Color(0xffE4D719).withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _bottomView() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 14),
          if (widget.publishModel != null)
            Container()
          else
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    bool push1 = await _addPageViewModel.publishGoods(
                      _chooseImagesPath,
                      isPublish: false,
                      editId: widget.publishModel?.id,
                    );
                    if (push1 && mounted) {
                      AppRouter.replace(context,
                          newPage: const MyPublishPage(isAddPage: false));
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(4),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Image.asset('${Constants.iconsPath}cao_gao.png'),
                  ),
                ),
                ThemeText(
                  text: '草稿箱',
                  color: const Color(0xff484C52).withOpacity(0.4),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                )
              ],
            ),
          const SizedBox(width: 40),
          Expanded(
            child: ThemeButton(
              height: 47,
              text: '发布',
              radius: 16,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              onPressed: () async {
                ToastUtils.showLoading();
                await context.read<UserInfoViewModel>().getUserInfo();
                if (!mounted) return;
                String? defaultAddress = context
                    .read<UserInfoViewModel>()
                    .userInfoModel
                    ?.defaultAddress;
                if (defaultAddress != '1') {
                  //跳转地址页面
                  showDialog(
                      barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("提示"),
                          content: Text(
                            context
                                    .read<UserInfoViewModel>()
                                    .userInfoModel
                                    ?.defaultAddressNotice ??
                                '',
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("取消"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: const Text("确定"),
                              onPressed: () {
                                Navigator.pop(context);
                                AppRouter.push(context, const MyAddressPage());
                              },
                            )
                          ],
                        );
                      });
                } else {
                  bool push = await _addPageViewModel.publishGoods(
                      _chooseImagesPath,
                      editId: widget.publishModel?.id);
                  if (push && mounted) {
                    if (widget.publishModel == null) {
                      //第一次发布
                      AppRouter.replace(context,
                          newPage: const MyPublishPage(isAddPage: true));
                    } else {
                      //已发布再次编辑
                      eventBus.fire(RefreshPublishPage(true));
                      Navigator.pop(context);
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
