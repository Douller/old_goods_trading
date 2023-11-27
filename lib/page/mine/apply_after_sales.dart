import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../../model/my_sell_goods_model.dart';
import '../../widgets/add/add_photo_btn.dart';
import '../../widgets/aging_degree_view.dart';
import '../../widgets/bottom_sheet/after_refund_reason.dart';
import '../../widgets/bottom_sheet/cream_cupertino_sheet.dart';
import '../../widgets/goods_price_text.dart';
import '../../widgets/theme_image.dart';
import '../../widgets/theme_text.dart';

class ApplyAfterSales extends StatefulWidget {
  final MySellGoodsData model;

  const ApplyAfterSales({Key? key, required this.model}) : super(key: key);

  @override
  State<ApplyAfterSales> createState() => _ApplyAfterSalesState();
}

class _ApplyAfterSalesState extends State<ApplyAfterSales> {
  final TextEditingController _describeTEC = TextEditingController();
  final TextEditingController _nameTEC = TextEditingController();
  final TextEditingController _phoneTEC = TextEditingController();
  List<Widget> _imageListView = [];
  List<AssetEntity> _assets = [];
  final List<String> _chooseImagesPath = [];

  List _reason = [];
  List _types = [];
  String? _chooseType;
  String? _chooseReason;

  //上传图片
  Future<List<String>> uploadImage(List<String> imagesPaths) async {
    ToastUtils.showLoading();
    List<String> imagePathList = [];
    for (String element in imagesPaths) {
      if (!element.contains('upload')) {
        String imagePath = await ServiceRepository.uploadImage(
            imagePath: element, filename: 'uploadImg');
        if (imagePath.isNotEmpty) {
          imagePathList.add(imagePath);
        }
      }
    }
    return imagePathList;
  }

  Future<void> _getOrderAfterCreate() async {
    if ((_chooseType ?? '').isEmpty) {
      ToastUtils.showText(text: '请选择售后类型');
      return;
    }
    if ((_chooseReason ?? '').isEmpty) {
      ToastUtils.showText(text: '请选择售后原因');
      return;
    }
    if (_nameTEC.text.trim().isEmpty) {
      ToastUtils.showText(text: '请填写联系人');
      return;
    }
    if (_phoneTEC.text.trim().isEmpty) {
      ToastUtils.showText(text: '请填写联系电话');
      return;
    }
    if (_describeTEC.text.trim().isEmpty) {
      ToastUtils.showText(text: '请填写详细描述');
      return;
    }
    if (_chooseImagesPath.isEmpty) {
      ToastUtils.showText(text: '未添加商品图片');
      return;
    }

    String thumbs = '';

    List<String> imagePathList = await uploadImage(_chooseImagesPath);

    if (imagePathList.isNotEmpty) {
      thumbs = imagePathList.join('|');
    }

    bool res = await ServiceRepository.orderAfterCreate(
      refundType: _chooseType!,
      userMemo: _describeTEC.text,
      thumbs: thumbs,
      refundReason: _chooseReason!,
      contactName: _nameTEC.text,
      contactPhone: _phoneTEC.text,
      orderId: widget.model.id ?? '',
    );
    if(res){
      ToastUtils.showText(text: '提交成功');
      if(!mounted)return;
      Navigator.pop(context,true);
    }
  }

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

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _pickPhotoOrCamera(int index) async {
    if (index == 0) {
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
              isAfter: true,
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

  Future<void> _orderAfterRefundReason() async {
    Map? dataMap = await ServiceRepository.orderAfterRefundReason();
    if (dataMap != null) {
      _reason = dataMap['reason'];
      _types = dataMap['types'];
    }
  }

  void _afterReasonSheet(int index) {
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
          return AfterReasonSheetView(
            isType: index == 0 ? true : false,
            types: index == 0 ? _types : _reason,
            callBack: (String? id, String? name) {
              setState(() {
                if (index == 0) {
                  _chooseType = id;
                } else {
                  _chooseReason = name;
                }
              });
            },
          );
        });
  }

  @override
  void initState() {
    _imageListView = [AddPhotoBtn(onTap: _showSheetAction)];
    _orderAfterRefundReason();
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
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('我的售后'),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _goodsInfoView(),
            _reasonView(),
            _drawbackView(),
            _describeView(),
            GestureDetector(
              onTap: _getOrderAfterCreate,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffFE734C),
                  borderRadius: BorderRadius.circular(44),
                ),
                child: const Text(
                  '提交申请',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reasonView() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _afterReasonSheet(0),
            child: Container(
              height: 55,
              margin: const EdgeInsets.only(right: 30),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffF6F6F6)))),
              child: Row(
                children: [
                  const ThemeText(text: '申请类型'),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ThemeText(
                      text: (_chooseType ?? '').isEmpty
                          ? '请选择'
                          : _types[int.parse(_chooseType!)]['name'],
                      color: (_chooseType ?? '').isEmpty
                          ? const Color(0xffCECECE)
                          : const Color(0xff2F3033),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Image.asset(
                    '${Constants.iconsPath}right_arrow.png',
                    width: 8,
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _afterReasonSheet(1),
            child: Container(
              height: 55,
              margin: const EdgeInsets.only(right: 30),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffF6F6F6)))),
              child: Row(
                children: [
                  const ThemeText(text: '申请原因'),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ThemeText(
                      text: (_chooseReason ?? '').isEmpty
                          ? '请选择'
                          : _chooseReason!,
                      color: (_chooseReason ?? '').isEmpty
                          ? const Color(0xffCECECE)
                          : const Color(0xff2F3033),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Image.asset(
                    '${Constants.iconsPath}right_arrow.png',
                    width: 8,
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 55,
            margin: const EdgeInsets.only(right: 30),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffF6F6F6)))),
            child: Row(
              children: [
                const ThemeText(text: '联系人名称'),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.end,
                    controller: _nameTEC,
                    decoration: const InputDecoration(
                      hintText: '请输入联系人名称',
                      hintStyle:
                          TextStyle(color: Color(0xffCECECE), fontSize: 16),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                      disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
          Container(
            height: 55,
            margin: const EdgeInsets.only(right: 30),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffF6F6F6)))),
            child: Row(
              children: [
                const ThemeText(text: '联系人电话'),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.end,
                    controller: _phoneTEC,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: '请输入联系人电话',
                      hintStyle:
                          TextStyle(color: Color(0xffCECECE), fontSize: 16),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                      disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _goodsInfoView() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ThemeNetImage(
                  imageUrl: widget.model.goodsInfo?.thumb,
                  height: 73,
                  width: 73,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ThemeText(
                            text: widget.model.goodsInfo?.goodsName ?? '',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GoodsPriceText(
                              priceStr:
                                  widget.model.goodsInfo?.totalAmount ?? '',
                              symbolFontSize: 10,
                              textFontSize: 20,
                              symbolFontWeight: FontWeight.w500,
                              textFontWeight: FontWeight.w500,
                              color: const Color(0xff2F3033),
                            ),
                            const SizedBox(height: 4),
                            const ThemeText(
                              text: 'x1',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xff999999),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    AgingDegreeView(
                      agingDegreeStr:
                          widget.model.goodsInfo?.brushingCondition ?? '',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawbackView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ThemeText(
                text: '申请售后商品数量',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              ThemeText(text: 'x1'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ThemeText(
                text: '退款总额',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              GoodsPriceText(
                priceStr: widget.model.goodsInfo?.totalAmount ?? '',
                symbolFontSize: 10,
                textFontSize: 20,
                symbolFontWeight: FontWeight.w500,
                textFontWeight: FontWeight.w500,
                color: const Color(0xffFE734C),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ThemeText(
            text: '若退款成功，将原路返还您的支付账户',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xff999999),
          ),
        ],
      ),
    );
  }

  Widget _describeView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ThemeText(
            text: '详情描述',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 150, minHeight: 50),
            child: TextField(
              controller: _describeTEC,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 10),
                border: InputBorder.none,
                hintText: '必填，请输入详情描述',
                hintStyle: TextStyle(
                  color: Color(0xff999999),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              maxLength: 180,
              maxLines: null,
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _imageListView,
          ),
        ],
      ),
    );
  }
}
