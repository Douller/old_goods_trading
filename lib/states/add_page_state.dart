import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:old_goods_trading/app.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/add/product_size_sheet_view.dart';
import '../dialog/dialog.dart';
import '../model/add_publish_info_model.dart';
import '../model/category_model.dart';
import '../model/home_goods_list_model.dart';
import '../net/service_repository.dart';
import '../utils/location_utils.dart';
import '../widgets/add/add_category_sheet_view.dart';
import '../widgets/add/add_delivery_sheet_view.dart';
import '../widgets/add/time_user_item.dart';
import '../widgets/bottom_sheet/publish_sheet_view.dart';

class AddPageViewModel extends ChangeNotifier {
  ///使用程度 购入时间 产品尺寸 手续费 等数据模型
  AddPublishInfoModel? model;
  TextEditingController titleTEC = TextEditingController(); //标题
  TextEditingController describeTEC = TextEditingController(); //描述
  TextEditingController shopPriceController = TextEditingController(); //现价TF
  TextEditingController marketPriceController = TextEditingController(); //原价TF
  String brushingCondition = ''; //使用程度
  String purchaseTime = ''; //购入时间
  String boxSize = ''; //产品尺寸
  String? _deliveryAmount; //邮费
  String deliveryType = '4'; //邮寄类型 1：包邮 2：有邮费  4未选择
  String? categoryId; //选中商品类别分类
  String? brandId; //选中商品类别子选项
  List<CategoryData> _categoryList = []; //商品类别数组
  String chooseCategoryString = '';
  String locationText = '正在定位...';
  String longitude = '';
  String latitude = '';
  String selfPickup = '0'; //自取 0未选中 1选中

  GoodsInfoModel? _publishModel; //草稿箱数据

  ///更改位置信息
  void changeAddressLocation(
    String latitude1,
    String longitude1,
    String locationText1,
  ) {
    latitude = latitude1;
    longitude = longitude1;
    locationText = locationText1;
    notifyListeners();
  }

  ///获取经纬度
  Future<void> requestLocationPermission(BuildContext context) async {
    bool res = await LocationUtils().requestLocationPermission();
    if (!res) {
      bool? dialogRes = await DialogUtils.openSetting(context);
      if ((dialogRes ?? false) == false) {
        return;
      }
    } else {
      LocationData locationData = await LocationUtils().getLocationData();

      latitude = locationData.latitude.toString();
      longitude = locationData.longitude.toString();

      locationText =
          await _getAddress(locationData.latitude, locationData.longitude);
      notifyListeners();
    }
  }

  Future<String> _getAddress(double? lat, double? lang) async {
    if (lat == null || lang == null) return "";
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lang);
    return '${placeMarks.first.locality} ${placeMarks.first.subLocality}';
  }

  //草稿箱进入 设置初始值
  void setOriginalValue(GoodsInfoModel publishModel) {
    _publishModel = publishModel;
    titleTEC.text = publishModel.name ?? '';
    describeTEC.text = publishModel.brief ?? '';
    shopPriceController.text = publishModel.shopPrice ?? '0';
    marketPriceController.text = publishModel.marketPrice ?? '0';
    purchaseTime = publishModel.purchaseTime ?? '';
    brushingCondition = publishModel.brushingCondition ?? '';
    deliveryType = publishModel.deliveryTypes ?? '4';
    _deliveryAmount = publishModel.deliveryAmount;
    selfPickup = publishModel.selfPickup ?? '0';
    chooseCategoryString = publishModel.categoryName ?? '';
    categoryId = publishModel.categoryId;
    brandId = publishModel.brandId;
    boxSize = publishModel.boxSize ?? '';
  }

  //上传图片
  Future<List<String>> uploadImage(List<String> imagesPaths) async {
    ToastUtils.showLoading();
    List<String> imagePathList = [];
    List<String> uploadList = []; //草稿箱上传过的图片地址
    for (String element in imagesPaths) {
      if (!element.contains('upload')) {
        String imagePath = await ServiceRepository.uploadImage(
            imagePath: element, filename: 'uploadImg');
        if (imagePath.isNotEmpty) {
          imagePathList.add(imagePath);
        }
      } else {
        uploadList.add(element);
      }
    }

    List<String> allImage = [];
    allImage.addAll(imagePathList);
    allImage.addAll(uploadList);
    return allImage;
  }

  //获取产品信息 使用程度 购入时间 等数据
  Future<void> getAddCategoryData() async {
    AddPublishInfoModel? addModel = await ServiceRepository.getPublishInfo();
    if (addModel != null) {
      model = addModel;
      notifyListeners();
    }
  }

  //获取产品分类
  Future<void> getPublishCategoryData() async {
    _categoryList = await ServiceRepository.getPublishCategory();
  }

  //发布商品
  Future<bool> publishGoods(List<String> chooseImagesPath,
      {bool isPublish = true, String? editId}) async {

    if (chooseImagesPath.isEmpty) {
      ToastUtils.showText(text: '未添加商品图片');
      return false;
    }

    if (titleTEC.text.trim().isEmpty) {
      ToastUtils.showText(text: '未填写标题');
      return false;
    }

    if (describeTEC.text.trim().isEmpty) {
      ToastUtils.showText(text: '未填写商品描述');
      return false;
    }

    String shopPriceValue =
        shopPriceController.text.isEmpty ? '0' : shopPriceController.text;
    String marketPriceValue =
        marketPriceController.text.isEmpty ? '0' : marketPriceController.text;
    if (num.parse(shopPriceValue) <= 0 || num.parse(marketPriceValue) <= 0) {
      ToastUtils.showText(text: '价格不能为空');
      return false;
    }

    if (longitude.isEmpty || latitude.isEmpty) {
      ToastUtils.showText(text: '未获取到位置信息');
      return false;
    }

    if (brushingCondition.isEmpty || purchaseTime.isEmpty) {
      ToastUtils.showText(text: '请选择产品信息');
      return false;
    }

    if ((categoryId ?? '').isEmpty) {
      ToastUtils.showText(text: '请选择商品类别');
      return false;
    }

    String thumb = _publishModel?.gallery?.first.image ?? '';
    String thumbs = ''; //所有图片路径

    List<String> imagePathList = await uploadImage(chooseImagesPath);

    if (imagePathList.isNotEmpty) {
      if (thumb.isEmpty) {
        thumb = imagePathList.first;
      }
      thumbs = imagePathList.join('|');
    }

    if (thumb.isEmpty) {
      ToastUtils.showText(text: '上传图片失败');
      return false;
    }

    bool res = await ServiceRepository.publishCreate(
      name: titleTEC.text.trim(),
      categoryId: categoryId,
      marketPrice: marketPriceValue,
      shopPrice: shopPriceValue,
      thumb: thumb,
      brief: describeTEC.text.trim(),
      brushingCondition: brushingCondition,
      thumbs: thumbs,
      deliveryType: deliveryType,
      deliveryAmount: _deliveryAmount,
      id: editId,
      brandId: brandId,
      status: isPublish ? '1' : '2',
      longitude: longitude,
      latitude: latitude,
      purchaseTime: purchaseTime,
      boxSize: boxSize,
      selfPickup: selfPickup,
    );
    if (res) {
      ToastUtils.showText(text: isPublish ? '发布成功' : '保存成功');
      return true;
    } else {
      return false;
    }
  }

  //底部弹出产品信息选择
  void showBottomSheet(BuildContext context, int index, String title) {
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
          return PublishSheetView(
            title: title,
            index: index,
            child: _childView(index),
          );
        }).then((value) {
      if (value == null) return;
      if (index == 3) {
        categoryId = value[0];
        brandId = value[1];
        chooseCategoryString = value[2];
      }
    });
  }

  Widget _childView(index) {
    if (index == 0) {
      return TimeAndUserItemView(
        model1: model,
        purchaseTimeSel: purchaseTime,
        brushingConditionSel: brushingCondition,
        callback: (timeChoose, useChoose) {
          purchaseTime = timeChoose;
          brushingCondition = useChoose;
        },
      );
    } else if (index == 1) {
      return ProductSizeSheetView(
        addPublishInfoModel: model,
        sizeName: boxSize,
        callback: (String sizeName) {
          boxSize = sizeName;
        },
      );
    } else if (index == 2) {
      return PublishDeliverySheetView(
        deliveryType: deliveryType,
        deliveryPrice: _deliveryAmount,
        boxSize: boxSize,
        latitude: latitude,
        longitude: longitude,
        selfPickup: selfPickup,
        callback: (String deliveryTypeS, String? deliveryPrice) {
          deliveryType = deliveryTypeS;
          _deliveryAmount = deliveryPrice;
        },
        pickUpCallback: (String selfPickupStr) {
          selfPickup = selfPickupStr;
        },
      );
    } else if (index == 3) {
      return AddCateGorySheetView(
        sonsId: categoryId,
        dataId: brandId,
        categoryList: _categoryList,
      );
    }
    return Container();
  }
}
