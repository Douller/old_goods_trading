import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:old_goods_trading/config/Config.dart';
import 'package:old_goods_trading/model/bank_model.dart';
import 'package:old_goods_trading/net/http_manager.dart';
import 'package:old_goods_trading/net/url_path.dart';
import 'package:old_goods_trading/utils/toast.dart';
import '../model/add_publish_info_model.dart';
import '../model/all_area_model.dart';
import '../model/cancel_order_reason.dart';
import '../model/category_model.dart';
import '../model/delivery_info_model.dart';
import '../model/goods_details_model.dart';
import '../model/home_goods_list_model.dart';
import '../model/hot_search_words_model.dart';
import '../model/message_list_model.dart';
import '../model/my_address_model.dart';
import '../model/my_coupon_model.dart';
import '../model/my_sell_goods_model.dart';
import '../model/nearby_address_model.dart';
import '../model/order_after_processing_model.dart';
import '../model/order_buy_confirm_model.dart';
import '../model/order_create_model.dart';
import '../model/pay_config_model.dart';
import '../model/phone_prefix_model.dart';
import '../model/search_config_model.dart';
import '../model/search_goods_list_model.dart';
import '../model/supplier_comment_list_model.dart';
import '../model/user_center_model.dart';
import '../model/user_info_model.dart';
import '../model/version_model.dart';
import '../model/withdraw_record_model.dart';

class ServiceRepository {
  ///获取首页商品列表
  static Future<HomeGoodsListModel?> getHomeGoodsList(
      {required String page, String? pageSize}) async {
    String url = Config.hostUrl + UrlPath.homeGoodsList;

    Map<String, dynamic> parma = {'page': page, 'pageSize': pageSize};
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        HomeGoodsListModel model = HomeGoodsListModel.fromJson(response.data);
        return model;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return null;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return null;
    }
  }

  ///获取商品详情
  static Future<GoodsDetailsModel?> getGoodsInfo({required String id}) async {
    String url = Config.hostUrl + UrlPath.goodsInfo;

    Map<String, dynamic> parma = {'id': id};
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        GoodsDetailsModel model = GoodsDetailsModel.fromJson(response.data);
        return model;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return null;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return null;
    }
  }

  ///获取商品分类
  static Future<CategoryModel?> getGoodsCategory() async {
    String url = Config.hostUrl + UrlPath.goodsCategory;

    Response<dynamic> response = await HttpManager().get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        CategoryModel model = CategoryModel.fromJson(response.data);
        return model;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return null;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return null;
    }
  }

  ///获取热门商品关键词
  static Future<HotSearchWordsModel?> getHotSearchWords() async {
    String url = Config.hostUrl + UrlPath.hotSearchWords;

    Response<dynamic> response = await HttpManager().get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        HotSearchWordsModel model = HotSearchWordsModel.fromJson(response.data);
        return model;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return null;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return null;
    }
  }

  ///取消关注和收藏  关注 supplier_id  收藏 goods_id
  static Future<bool> postCollectDelete({
    String? goodsId,
    String? supplierId,
  }) async {
    String url = Config.hostUrl + UrlPath.collectDel;

    Map<String, dynamic> parma = {
      'goods_id': goodsId,
      'supplier_id': supplierId
    };
    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        return true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return false;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return false;
    }
  }

  ///关注和收藏  关注 supplier_id  收藏 goods_id
  static Future<bool> postCollectAndeAdd({
    String? goodsId,
    String? supplierId,
  }) async {
    String url = Config.hostUrl + UrlPath.collectAndAdd;

    Map<String, dynamic> parma = {
      'goods_id': goodsId,
      'supplier_id': supplierId
    };
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        return true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return false;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return false;
    }
  }

  ///搜索配置
  static Future<SearchConfigModel?> getGoodsSearchConfig({
    String? categoryId,
    String? brandId,
    String? keywords,
  }) async {
    String url = Config.hostUrl + UrlPath.goodsSearchConfig;

    Map<String, dynamic> parma = {
      'category_id': categoryId,
      'brand_id': brandId,
      'keywords': keywords,
    };
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        SearchConfigModel? model = SearchConfigModel.fromJson(response.data);
        return model;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return null;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return null;
    }
  }

  ///搜索列表
  static Future<SearchGoodsListModel?> getGoodsSearchList({
    String? page,
    String? pageSize,
    String? keywords,
    String? minPrice,
    String? maxPrice,
    String? configKey,
    String? configId,
    String? brandId,
    String? categoryId,
    String? sonCategoryId,
  }) async {
    String url = Config.hostUrl + UrlPath.goodsSearchList;

    Map<String, dynamic> parma = {
      'page': page,
      'pageSize': pageSize,
      'keywords': keywords,
      'min_price': minPrice,
      'max_price': maxPrice,
      'config_key': configKey,
      'config_id': configId,
      'brand_id': brandId,
      'category_id': categoryId,
      'son_category_id': sonCategoryId,
    };
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        SearchGoodsListModel? model =
            SearchGoodsListModel.fromJson(response.data);
        return model;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return null;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return null;
    }
  }

  ///订单提交前
  static Future<SubmitOrderModel?> getOrderBuyConfirm(
      {required String goodsId, String? addressId}) async {
    String url = Config.hostUrl + UrlPath.orderBuyConfirm;

    Map<String, dynamic> parma = {
      'goods_id': goodsId,
      'address_id': addressId,
    };

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    SubmitOrderModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        if (response.data['item'] != null &&
            response.data['item'] is Map<String, dynamic>) {
          model = SubmitOrderModel.fromJson(response.data['item']);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///创建订单
  static Future<OrderCreateModel?> getOrderCreate({
    required String goodsId,
    required String addressId,
    String? paymentId,
    String? userMemo,
    String? couponId,
  }) async {
    String url = Config.hostUrl + UrlPath.orderCreate;

    Map<String, dynamic> parma = {
      'goods_id': goodsId,
      'address_id': addressId,
      'payment_id': paymentId,
      'user_memo': userMemo,
      'coupon_id': couponId,
    };

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    OrderCreateModel? orderCreateModel;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        if (response.data['item'] != null &&
            response.data['item'] is Map<String, dynamic>) {
          orderCreateModel = OrderCreateModel.fromJson(response.data['item']);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return orderCreateModel;
  }

  // /// 支付
  // static Future<OrderCreateModel?> getPayInfo(
  //     {String? orderId, String? type}) async {
  //   String url = Config.hostUrl + UrlPath.orderPay;
  //
  //   Map<String, dynamic> parma = {
  //     'order_id': orderId,
  //     'type': type,
  //   };
  //   OrderCreateModel? orderCreateModel;
  //   Response<dynamic> response =
  //       await HttpManager().post(url, queryParameters: parma);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     if (response.data['return_code'] == 1) {
  //       if (response.data['item'] != null &&
  //           response.data['item'] is Map<String, dynamic>) {
  //         orderCreateModel = OrderCreateModel.fromJson(response.data['item']);
  //       }
  //     } else {
  //       ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
  //     }
  //   } else {
  //     ToastUtils.showText(text: response.statusMessage ?? '网络错误');
  //   }
  //   return orderCreateModel;
  // }

  ///获取用户信息
  static Future<UserInfoModel?> getUserInfo() async {
    String url = Config.hostUrl + UrlPath.userInfo;

    Response<dynamic> response = await HttpManager().get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        UserInfoModel? model;
        if (response.data['item'] is Map<String, dynamic>) {
          model = UserInfoModel.fromJson(response.data['item']);
        }
        return model;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return null;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return null;
    }
  }

  ///获取个人中心首页数据
  static Future<UserCenterModel?> getUserCenterInfo() async {
    String url = Config.hostUrl + UrlPath.userIndex;

    Response<dynamic> response = await HttpManager().get(url);
    UserCenterModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        if (response.data['item'] is Map<String, dynamic>) {
          model = UserCenterModel.fromJson(response.data['item']);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///删除地址
  static Future<bool> deleteAddress({required String addressId}) async {
    String url = Config.hostUrl + UrlPath.deleteAddress;
    Map<String, dynamic> parma = {'id': addressId};

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    bool res = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.showText(text: response.data['return_info']);
        res = true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  ///获取国家
  static Future<List<Area>> getAreaCountry() async {
    String url = Config.hostUrl + UrlPath.areaCountry;

    Response<dynamic> response = await HttpManager().get(url);

    List<Area> countryList = [];
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 && response.data['data'] != null) {
        List data = response.data['data'];
        for (var element in data) {
          Area areaModel = Area.fromJson(element);
          countryList.add(areaModel);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return countryList;
  }

  ///根据国家获取省份或者城市
  static Future<AllAreaModel?> getAreaList(
      {required String level,
      required String countryId,
      String? parentId}) async {
    String url = Config.hostUrl + UrlPath.areaList;

    Map<String, dynamic> parma = {
      'level': level,
      'country_id': countryId,
      'parent_id': parentId,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);

    AllAreaModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 && response.data['data'] != null) {
        model = AllAreaModel.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取所有地址
  static Future<AllAreaModel?> getAllArea() async {
    String url = Config.hostUrl + UrlPath.allArea;

    Response<dynamic> response = await HttpManager().get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1) {
        AllAreaModel? model = AllAreaModel.fromJson(response.data);
        return model;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return null;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return null;
    }
  }

  ///获取用户地址列表
  static Future<MyAddressModel?> getUserAddress() async {
    String url = Config.hostUrl + UrlPath.userAddress;

    Response<dynamic> response = await HttpManager().get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        MyAddressModel? model = MyAddressModel.fromJson(response.data);
        return model;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return null;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return null;
    }
  }

  ///添加地址
  static Future<String> addAddress({
    String? id,
    String? countryId,
    String? xing,
    String? consignee,
    String? telephone,
    String? address1,
    String? address2,
    String? isDefault,
    String? zipcode,
    String? cityId,
    String? provinceId,
    required String city,
    required String province,
    required String latitude,
    required String longitude,
    required String addressId,
    required String addressInfo,
  }) async {
    String url = Config.hostUrl + UrlPath.addAddress;

    Map<String, dynamic> parma = {
      'id': id,
      'country_id': countryId,
      'xing': xing,
      'consignee': consignee,
      'address': address1,
      'address2': address2,
      'city_id': cityId,
      'province_id': provinceId,
      'zipcode': zipcode,
      'telephone': telephone,
      'is_default': isDefault,
      'city': city,
      'province': province,
      'latitude': latitude,
      'longitude': longitude,
      'address_id': addressId,
      'address_info': addressInfo,
    };

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    String resId = '';
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1) {
        resId = response.data['id'];
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return resId;
  }

  ///设置默认地址
  static Future<String> setDefaultAddAddress({
    String? id,
  }) async {
    String url = Config.hostUrl + UrlPath.setDefaultAddAddress;

    Map<String, dynamic> parma = {'id': id};

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    String resId = '';
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1) {
        resId = response.data['id'];
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return resId;
  }

  ///获取发布商品的品牌和成色信息
  static Future<AddPublishInfoModel?> getPublishInfo() async {
    String url = Config.hostUrl + UrlPath.publishInfo;

    Response<dynamic> response = await HttpManager().get(url);

    AddPublishInfoModel? model;

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        if (response.data['data'] != null &&
            response.data['data'] is Map<String, dynamic>) {
          model = AddPublishInfoModel.fromJson(response.data['data']);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取我的收藏
  static Future<GoodsLists?> getMyCollectList(
      {String? page, String? pageSize}) async {
    String url = Config.hostUrl + UrlPath.collectList;

    Map<String, dynamic> parma = {
      'page': page,
      'page_size': pageSize,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    GoodsLists? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        model = GoodsLists.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取我发布的
  static Future<GoodsLists?> getMyPublishedList(
      {required String supplierId,
      String? status,
      String? page,
      String? pageSize}) async {
    String url = Config.hostUrl + UrlPath.supplierGoods;
    Map<String, dynamic> parma = {
      'supplier_id': supplierId,
      'status': status,
      'page': page,
      'page_size': pageSize,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    GoodsLists? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        model = GoodsLists.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取我卖的
  static Future<MySellGoodsModel?> getMySellGoodsData(
      {String? status, String? page, String? pageSize}) async {
    String url = Config.hostUrl + UrlPath.supplierOrders;
    Map<String, dynamic> parma = {
      'status': status,
      'page': page,
      'page_size': pageSize,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    MySellGoodsModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1) {
        model = MySellGoodsModel.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取我的订单列表
  static Future<MySellGoodsModel?> getMyOrderList({
    String? status,
    String? page,
    String? pageSize,
  }) async {
    String url = Config.hostUrl + UrlPath.orderList;
    Map<String, dynamic> parma = {
      'status': status,
      'page': page,
      'page_size': pageSize,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    MySellGoodsModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        model = MySellGoodsModel.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///上传图片
  static Future<String> uploadImage({
    required String imagePath,
    required String filename,
  }) async {
    String url = Config.hostUrl + UrlPath.uploadImg;

    String name =
        imagePath.substring(imagePath.lastIndexOf("/") + 1, imagePath.length);

    FormData formData = FormData.fromMap({
      filename: await MultipartFile.fromFile(
        imagePath,
        filename: name,
      )
    });
    String imgPath = '';
    Response<dynamic> response = await HttpManager().post(url, data: formData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        imgPath = response.data['imgPath'] ?? '';
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return imgPath;
  }

  ///发布商品
  static Future<bool> publishCreate({
    String? id,
    String? name,
    String? categoryId,
    required String marketPrice,
    required String shopPrice,
    required String thumb,
    required String brief,
    required String longitude,
    required String latitude,
    required String selfPickup,
    String? brushingCondition,
    String? purchaseTime,
    String? thumbs,
    String? deliveryType,
    String? brandId,
    String? deliveryAmount,
    String? status,
    String? boxSize,
  }) async {
    String url = Config.hostUrl + UrlPath.publishCreate;

    Map<String, dynamic> parma = {
      'name': name,
      'category_id': categoryId,
      'market_price': marketPrice,
      'shop_price': shopPrice,
      'thumb': thumb,
      'brief': brief,
      'latitude': latitude,
      'longitude': longitude,
      'brushing_condition': brushingCondition,
      'thumbs': thumbs,
      'delivery_type': deliveryType,
      'brand_id': brandId,
      'delivery_amount': deliveryAmount,
      'id': id,
      'status': status,
      'purchase_time': purchaseTime,
      'box_size': boxSize,
      'self_pickup': selfPickup,
    };

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    bool res = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1 &&
          response.data['return_info'] != null) {
        return true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  ///修改用户资料
  static Future<UserInfoModel?> userEdit({
    String? nickname,
    String? birthday,
    String? sex,
    String? remarks,
    String? avatar,
    String? username,
    String? email,
  }) async {
    String url = Config.hostUrl + UrlPath.userEdit;

    Map<String, dynamic> parma = {
      'nickname': nickname,
      'birthday': birthday,
      'sex': sex,
      'remarks': remarks,
      'avatar': avatar,
      'username': username,
      'email': email,
    };
    UserInfoModel? model;
    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        if (response.data['item'] is Map<String, dynamic>) {
          model = UserInfoModel.fromJson(response.data['item']);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取优惠券
  static Future<List<MyCouponModel>> getCouponList({String? status}) async {
    String url = Config.hostUrl + UrlPath.couponList;

    Map<String, dynamic> parma = {'status': status};
    List<MyCouponModel> modelList = [];
    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1) {
        if (response.data is Map<String, dynamic>) {
          List dataList = response.data['data'];
          if (dataList.isNotEmpty) {
            for (Map<String, dynamic> element in dataList) {
              MyCouponModel model = MyCouponModel.fromJson(element);
              modelList.add(model);
            }
            return modelList;
          }
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return modelList;
  }

  /// 订单cell按钮点击
  static Future<OrderCreateModel?> cellBtnClick(
      {required String orderId, required String actions}) async {
    String url = Config.hostUrl + actions;

    Map<String, dynamic> parma = {
      'order_id': orderId,
    };
    OrderCreateModel? orderCreateModel;
    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        if (response.data['item'] != null &&
            response.data['item'] is Map<String, dynamic>) {
          orderCreateModel = OrderCreateModel.fromJson(response.data['item']);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return orderCreateModel;
  }

  ///获取消息分类接口
  static Future<List> getMessageCategory() async {
    String url = Config.hostUrl + UrlPath.messageCategory;

    Response<dynamic> response = await HttpManager().post(url);
    List dataList = [];
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        if (response.data['data'] != null && response.data['data'] is List) {
          dataList = response.data['data'];
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return dataList;
  }

  /// 消息列表
  static Future<List<MessageListModel>> getMessageList(
      {required String categoryId}) async {
    String url = Config.hostUrl + UrlPath.messageList;

    Map<String, dynamic> parma = {'category_id': categoryId};

    List<MessageListModel> dataList = [];

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        if (response.data['data'] != null &&
            response.data['data'] is List &&
            response.data['data'].isNotEmpty) {
          for (Map<String, dynamic> item in response.data['data']) {
            MessageListModel model = MessageListModel.fromJson(item);
            dataList.add(model);
          }
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return dataList;
  }

  /// 我的订单详情
  static Future<MySellGoodsData?> getMyOrderDetails(
      {required String orderId}) async {
    String url = Config.hostUrl + UrlPath.myOrderDetails;

    Map<String, dynamic> parma = {'order_id': orderId};

    MySellGoodsData? model;

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        if (response.data['item'] != null &&
            response.data['item'] is Map<String, dynamic>) {
          model = MySellGoodsData.fromJson(response.data['item']);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  /// 取消我的订单
  static Future<OrderCreateModel?> cancelMyOrder({
    required String orderId,
    required String reason,
  }) async {
    String url = Config.hostUrl + UrlPath.orderCancel;

    Map<String, dynamic> parma = {'order_id': orderId, 'reason': reason};

    OrderCreateModel? model;

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        if (response.data['item'] != null &&
            response.data['item'] is Map<String, dynamic>) {
          model = OrderCreateModel.fromJson(response.data['item']);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  /// 取消订单选项
  static Future<CancelOrderReasonModel?> cancelMyOrderReason() async {
    String url = Config.hostUrl + UrlPath.cancelReason;

    CancelOrderReasonModel? model;

    Response<dynamic> response = await HttpManager().get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        if (response.data['item'] != null &&
            response.data['item'] is List &&
            response.data['item'].isNotEmpty) {
          model = CancelOrderReasonModel.fromJson(response.data);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  /// 下架商品
  static Future<bool> publishOffSale({required String goodsId}) async {
    String url = Config.hostUrl + UrlPath.publishOffSale;

    Map<String, dynamic> map = {'goods_id': goodsId};

    bool res = false;
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        res = true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  /// 重新上架
  static Future<bool> publishOnSale({required String goodsId}) async {
    String url = Config.hostUrl + UrlPath.publishOnSale;

    Map<String, dynamic> map = {'goods_id': goodsId};
    bool res = false;

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        res = true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  /// d登录
  static Future<UserInfoModel?> login(
      {String? mobile,
      String? verifyCode,
      String? parentId,
      String? email,
      String? dataInfo}) async {
    String url = Config.hostUrl + UrlPath.login;

    Map<String, dynamic> map = {
      'mobile': mobile,
      'verifyCode': verifyCode,
      'parent_id': parentId,
      'data_info': dataInfo,
      'email': email,
    };
    UserInfoModel? userInfoModel;

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        if (response.data['returnInfo'] != null &&
            response.data['returnInfo']['info'] != null &&
            response.data['returnInfo']['info'] is Map) {
          userInfoModel =
              UserInfoModel.fromJson(response.data['returnInfo']['info']);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return userInfoModel;
  }

  ///获取发布商品的分类信息
  static Future<List<CategoryData>> getPublishCategory() async {
    String url = Config.hostUrl + UrlPath.publishCategory;

    Response<dynamic> response = await HttpManager().get(url);

    List<CategoryData> dataList = [];

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        CategoryModel model = CategoryModel.fromJson(response.data);
        dataList = model.data ?? [];
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return dataList;
  }

  ///获取更多发布分类
  static Future<CategoryModel?> getMorePublishCategory(
      String? categoryId, String? keywords) async {
    Map<String, dynamic> map = {
      'category_id': categoryId,
      'keywords': keywords
    };
    String url = Config.hostUrl + UrlPath.morePublishCategorys;

    CategoryModel? model;
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        model = CategoryModel.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取更多发布品牌
  static Future<List<Brands>> getMorePublishBrands(
      String? categoryId, String? keywords) async {
    Map<String, dynamic> map = {
      'category_id': categoryId,
      'keywords': keywords
    };
    String url = Config.hostUrl + UrlPath.morePublishBrands;

    List<Brands> dataList = [];
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 &&
          response.data['data'] != null &&
          response.data['data'] is List) {
        for (var element in response.data['data']) {
          Brands model = Brands.fromJson(element);
          dataList.add(model);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return dataList;
  }

  ///获取我的足迹
  static Future<GoodsLists?> getMyCollectHistory(
      {String? page, String? pageSize}) async {
    String url = Config.hostUrl + UrlPath.collectHistory;

    Map<String, dynamic> parma = {
      'page': page,
      'page_size': pageSize,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    GoodsLists? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        model = GoodsLists.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///删除足迹历史
  static Future<bool> deletedHistory({
    String? goodsId,
    String? supplierId,
  }) async {
    String url = Config.hostUrl + UrlPath.deletedHistory;

    Map<String, dynamic> parma = {
      'goods_id': goodsId,
      'supplier_id': supplierId
    };
    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        return true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return false;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return false;
    }
  }

  ///我的订单tabBar Title
  static Future<List> myOrderStatus(bool isMyOrder) async {
    String url = Config.hostUrl +
        (isMyOrder ? UrlPath.myOrderStatus : UrlPath.supplierOrderStatus);

    List data = [];
    Response<dynamic> response = await HttpManager().post(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1 &&
          response.data['data'] != null &&
          response.data['data'] is List) {
        data = response.data['data'];
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return data;
  }

  ///消息已读
  static Future<bool> messageRead({String? messageId}) async {
    String url = Config.hostUrl + UrlPath.messageRead;

    Map<String, dynamic> map = {'message_id': messageId};

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        return true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return false;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return false;
    }
  }

  ///我卖的订单详情
  static Future<MySellGoodsData?> supplierOrderInfo(String orderId) async {
    String url = Config.hostUrl + UrlPath.supplierOrderInfo;

    Map<String, dynamic> map = {'order_id': orderId};

    MySellGoodsData? modelData;

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 &&
          response.data['item'] != null &&
          response.data['item'] is Map) {
        modelData = MySellGoodsData.fromJson(response.data['item']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return modelData;
  }

  ///买家评论
  static Future<bool> commentAdd({
    required String orderId,
    required String content,
    required String score,
  }) async {
    String url = Config.hostUrl + UrlPath.commentAdd;

    Map<String, dynamic> map = {
      'order_id': orderId,
      'content': content,
      'score': score,
    };

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      if (response.data['return_code'] == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return false;
    }
  }

  ///客服和关于我们
  static Future<String?> articleAbout({required String type}) async {
    String url = Config.hostUrl + UrlPath.articleAbout;

    Map<String, dynamic> map = {'type': type};

    String? dataString;
    ToastUtils.showLoading();
    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1) {
        dataString = response.data['data'];
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return dataString;
  }

  ///获取买家正在售后申请列表
  static Future<MySellGoodsModel?> getMyOrderAfterList({
    String? page,
    String? pageSize,
  }) async {
    String url = Config.hostUrl + UrlPath.orderAfterList;
    Map<String, dynamic> parma = {
      'page': page,
      'page_size': pageSize,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    MySellGoodsModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        model = MySellGoodsModel.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取买家处理中的售后列表
  static Future<OrderAfterProcessingModel?> getMyOrderAfterProcessing({
    String? page,
    String? pageSize,
  }) async {
    String url = Config.hostUrl + UrlPath.orderAfterProcessing;
    Map<String, dynamic> parma = {
      'page': page,
      'page_size': pageSize,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    OrderAfterProcessingModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        model = OrderAfterProcessingModel.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取买家售后列表的申请记录
  static Future<OrderAfterProcessingModel?> getMyOrderAfterHistory({
    String? page,
    String? pageSize,
  }) async {
    String url = Config.hostUrl + UrlPath.orderAfterHistory;
    Map<String, dynamic> parma = {
      'page': page,
      'page_size': pageSize,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    OrderAfterProcessingModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        model = OrderAfterProcessingModel.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  /// 售后原因选择
  static Future<Map?> orderAfterRefundReason() async {
    ToastUtils.showLoading();
    String url = Config.hostUrl + UrlPath.orderAfterRefundReason;

    Map? dataMap;

    Response<dynamic> response = await HttpManager().get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        if (response.data['reason'] is List &&
            response.data['reason'].isNotEmpty &&
            response.data['types'] is List &&
            response.data['types'].isNotEmpty) {
          dataMap = response.data;
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return dataMap;
  }

  /// 提交售后申请
  static Future<bool> orderAfterCreate({
    required String orderId,
    required String refundType,
    required String userMemo,
    required String thumbs,
    required String refundReason,
    required String contactName,
    required String contactPhone,
  }) async {
    ToastUtils.showLoading();
    String url = Config.hostUrl + UrlPath.orderAfterCreate;

    Map<String, dynamic> parma = {
      'order_id': orderId,
      'refund_type': refundType,
      'user_memo': userMemo,
      'thumbs': thumbs,
      'refund_reason': refundReason,
      'contact_name': contactName,
      'contact_phone': contactPhone,
    };

    bool data = false;

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1 &&
          response.data['return_info'] == '操作成功') {
        ToastUtils.hiddenAllToast();
        data = true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return data;
  }

  ///卖家售后
  static Future<OrderAfterProcessingModel?> getSupplierAfterOrder({
    String? page,
    String? pageSize,
    String? type,
  }) async {
    String url = Config.hostUrl + UrlPath.supplierAfterOrder;
    Map<String, dynamic> parma = {
      'page': page,
      'page_size': pageSize,
      'type': type,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    OrderAfterProcessingModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        model = OrderAfterProcessingModel.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取卖家主页
  static Future<UserInfoModel?> getSupplierInfo(
      {required String supplierId}) async {
    String url = Config.hostUrl + UrlPath.supplierInfo;

    Map<String, dynamic> parma = {'supplier_id': supplierId};

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    UserInfoModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1 && response.data['item'] != null) {
        model = UserInfoModel.fromJson(response.data['item']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取卖家主页
  static Future<SupplierCommentListModel?> getSupplierCommentList(
      {String? type, required String supplierId}) async {
    String url = Config.hostUrl + UrlPath.supplierCommentList;

    Map<String, dynamic> parma = {'supplier_id': supplierId, 'type': type};

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    SupplierCommentListModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1 && response.data != null) {
        ToastUtils.hiddenAllToast();
        model = SupplierCommentListModel.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///卖家评论
  static Future<bool> commentSupplierAdd({
    required String orderId,
    required String content,
    required String score,
  }) async {
    String url = Config.hostUrl + UrlPath.commentSupplierAdd;

    Map<String, dynamic> map = {
      'order_id': orderId,
      'content': content,
      'score': score,
    };

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      if (response.data['return_code'] == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return false;
    }
  }

  /// 售后详情
  static Future<MySellGoodsData?> getAfterSalesDetails(
      {required bool isSupplier, required String orderId}) async {
    String url = Config.hostUrl +
        (isSupplier ? UrlPath.supplierAfterOrderView : UrlPath.orderAfterView);

    Map<String, dynamic> map = {'order_id': orderId};

    MySellGoodsData? modelData;

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 &&
          response.data['item'] != null &&
          response.data['item'] is Map) {
        modelData = MySellGoodsData.fromJson(response.data['item']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return modelData;
  }

  /// 关联商品和用户的会话
  static Future<bool> messageAddRalation({
    required String messageId,
    required String goodsId,
    required String type,
  }) async {
    String url = Config.hostUrl + UrlPath.messageAddRalation;

    Map<String, dynamic> map = {
      'message_id': messageId,
      'goods_id': goodsId,
      'type': type
    };

    bool res = false;

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      res = true;
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  /// 聊天页面获取关联商品的信息
  static Future<GoodsInfoModel?> messageGetRalation({
    required String messageId,
    required String type,
  }) async {
    String url = Config.hostUrl + UrlPath.messageGetRalation;

    Map<String, dynamic> map = {'message_id': messageId, 'type': type};

    GoodsInfoModel? res;

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: map);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 &&
          response.data['item'] != null &&
          response.data['item'] is Map) {
        res = GoodsInfoModel.fromJson(response.data['item']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  /// 查询版本更新
  static Future<VersionModel?> getVersion() async {
    String url = Config.hostUrl + UrlPath.version;

    VersionModel? res;

    Response<dynamic> response = await HttpManager().get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['data'] != null) {
        res = VersionModel.fromJson(response.data['data']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  ///获取用户收入记录
  static Future<List<WithdrawRecordModel>> getRevenueRecordsList(
      {String? type = '7', String? page, String? pageSize}) async {
    String url = Config.hostUrl + UrlPath.revenueRecords;

    Map<String, dynamic> parma = {
      'type': type,
      'page': page,
      'page_size': pageSize,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);

    List<WithdrawRecordModel> dataList = [];
    ToastUtils.hiddenAllToast();
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        if (response.data['data'] != null) {
          response.data['data'].forEach((v) {
            dataList.add(WithdrawRecordModel.fromJson(v));
          });

          return dataList;
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return dataList;
  }

  ///获取用户提现记录
  static Future<List<WithdrawRecordModel>> getWithdrawRecordsList(
      {String? page, String? pageSize}) async {
    String url = Config.hostUrl + UrlPath.withdrawRecords;

    Map<String, dynamic> parma = {
      'page': page,
      'page_size': pageSize,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);

    List<WithdrawRecordModel> dataList = [];

    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1) {
        if (response.data['data'] != null) {
          response.data['data'].forEach((v) {
            dataList.add(WithdrawRecordModel.fromJson(v));
          });

          return dataList;
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return dataList;
  }

  ///获取用户提现余额
  static Future<UserInfoModel?> getWithdrawAmount() async {
    String url = Config.hostUrl + UrlPath.getWithdrawAmount;

    Response<dynamic> response = await HttpManager().get(url);
    UserInfoModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        model = UserInfoModel.fromJson(response.data['item']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取用户绑定的银行卡
  static Future<List<Bank>> getUserBankList() async {
    String url = Config.hostUrl + UrlPath.userBankList;

    Map<String, dynamic> parma = {
      'page': '1',
      'page_size': '50',
    };
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    List<Bank> resList = [];
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1 && response.data['data'] != null) {
        ToastUtils.hiddenAllToast();
        List res = response.data['data'] ?? [];
        for (var element in res) {
          Bank model = Bank.fromJson(element);
          resList.add(model);
        }
        return resList;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return resList;
  }

  ///获取收款银行
  static Future<List<Bank>> getUserPaymentList() async {
    String url = Config.hostUrl + UrlPath.paymentList;

    Map<String, dynamic> parma = {
      'page': '1',
      'page_size': '50',
    };
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    List<Bank> resList = [];
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1 && response.data['data'] != null) {
        ToastUtils.hiddenAllToast();
        List res = response.data['data'] ?? [];
        for (var element in res) {
          Bank model = Bank.fromJson(element);
          resList.add(model);
        }
        return resList;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return resList;
  }

  ///获取可选择银行列表
  static Future<BankModel?> getBankList() async {
    String url = Config.hostUrl + UrlPath.banksList;

    Map<String, dynamic> parma = {
      'page': '1',
      'page_size': '100',
    };
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    BankModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        model = BankModel.fromJson(response.data['returnInfo']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取可选择银行列表
  static Future<bool> addBankCard({
    required String bankUser,
    // required String bankName,
    required String year,
    required String month,
    required String bankAcc,
    required String cvc,
    required String address,
  }) async {
    String url = Config.hostUrl + UrlPath.addBankCard;

    Map<String, dynamic> parma = {
      'bank_user': bankUser,
      'bank_name': '1',
      'bank_acc': bankAcc,
      'cvc': cvc,
      'address': address,
      'month': month,
      'year': year,
    };
    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    bool addResult = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        addResult = true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return addResult;
  }

  ///提现
  static Future<bool> withdraw({
    required String bandId,
    required String amount,
    String? remark,
  }) async {
    String url = Config.hostUrl + UrlPath.withdraw;

    Map<String, dynamic> parma = {
      'band_id': bandId,
      'amount': amount,
      'remark': remark,
    };
    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    bool res = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        res = true;

        ToastUtils.showText(
            text: response.data['message'] ??
                response.data['return_info'] ??
                '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  ///获取首页附近的商品列表
  static Future<HomeGoodsListModel?> getNearbyGoodsList(
      {required String page,
      required String longitude,
      required String latitude,
      String? pageSize}) async {
    String url = Config.hostUrl + UrlPath.nearby;

    Map<String, dynamic> parma = {
      'page': page,
      'pageSize': pageSize,
      'longitude': longitude,
      'latitude': latitude,
    };
    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        HomeGoodsListModel model = HomeGoodsListModel.fromJson(response.data);
        return model;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
        return null;
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      return null;
    }
  }

  static Future<DeliveryInfoModel?> getDeliveryInfo(
      {required bool isSell, required String orderId}) async {
    String url = Config.hostUrl +
        (isSell ? UrlPath.afterOrderDeliveryInfo : UrlPath.orderDeliveryInfo);

    Map<String, dynamic> parma = {'order_id': orderId};

    DeliveryInfoModel? model;

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        if (response.data['item'] != null &&
            response.data['item'] is Map<String, dynamic>) {
          model = DeliveryInfoModel.fromJson(response.data);
        }
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  static Future<NearbyAddressModel?> getAreaGetListByLonlat({
    String? keywords,
    String? latitude,
    String? longitude,
  }) async {
    String url = Config.hostUrl + UrlPath.areaGetListByLonlat;

    Map<String, dynamic> parma = {
      'keywords': keywords,
      'latitude': latitude,
      'longitude': longitude,
    };

    NearbyAddressModel? model;

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();

        model = NearbyAddressModel.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  static Future<List> getKuaidi() async {
    String url = Config.hostUrl + UrlPath.getKuaidi;

    List dataList = [];

    Response<dynamic> response = await HttpManager().post(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        dataList = response.data['data'] ?? [];
        return dataList;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return dataList;
  }

  static Future<bool> supplierDelivery(
      {required String orderId,
      required String deliveryWay,
      required String deliveryNo}) async {
    String url = Config.hostUrl + UrlPath.supplierDelivery;

    Map<String, dynamic> parma = {
      'order_id': orderId,
      'delivery_way': deliveryWay,
      'delivery_no': deliveryNo,
    };
    bool data = false;

    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        data = true;
        return data;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return data;
  }

  static Future<bool> removeUser() async {
    String url = Config.hostUrl + UrlPath.userDel;

    bool res = false;
    Response<dynamic> response = await HttpManager().post(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['return_code'] == 1) {
        ToastUtils.hiddenAllToast();
        res = true;
        return res;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  static Future<bool> couponAdd({required String couponSn}) async {
    String url = Config.hostUrl + UrlPath.couponAdd;

    Map<String, dynamic> parma = {'coupon_sn': couponSn};

    bool res = false;
    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1) {
        res = true;
        return res;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  ///计算运费
  static Future<String> getPublishShipPrice({
    required String boxSize,
    required String longitude,
    required String latitude,
  }) async {
    String url = Config.hostUrl + UrlPath.publishShipPrice;

    Map<String, dynamic> parma = {
      'box_size': boxSize,
      'longitude': longitude,
      'latitude': latitude
    };

    String res = '';
    Response<dynamic> response =
        await HttpManager().post(url, queryParameters: parma);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1) {
        res = response.data['return_info'];
        return res;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  ///
  static Future<Yuansfer?> creatYuansfer({required String orderId}) async {
    String url = Config.hostUrl + UrlPath.creatYuansfer;
    Map<String, dynamic> parma = {'order_id': orderId};

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    Yuansfer? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 && response.data['item'] != null) {
        model = Yuansfer.fromJson(response.data['item']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取手机号码地区
  static Future<PhonePrefixModel?> getPhonePrefix() async {
    String url = Config.hostUrl + UrlPath.userPrefix;

    Response<dynamic> response = await HttpManager().get(url);
    PhonePrefixModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1) {
        model = PhonePrefixModel.fromJson(response.data);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取手机号验证码
  ///请求参数 prefix手机前缀  代表是哪个国家，  phone  手机号码，  type  类型  edit:old  edit_new:新手机验证码
  static Future<bool> getPhoneCode(
      {required String prefix,
      required String phone,
      required String type}) async {
    String url = Config.hostUrl + UrlPath.sendPhoneCode;

    Map<String, dynamic> parma = {
      'prefix': prefix,
      'phone': phone,
      'type': type
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    bool res = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 &&
          response.data['returnCode'] == 1) {
        ToastUtils.showText(text: '发送成功');
        res = true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  ///获取邮箱验证码
  ///请求参数 email 手机号码，  type  类型  edit:old  edit_new:新手机验证码
  static Future<bool> getEmailCode({
    required String email,
    required String type,
  }) async {
    String url = Config.hostUrl + UrlPath.sendEmailCode;

    Map<String, dynamic> parma = {'email': email, 'type': type};

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    bool res = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 &&
          response.data['returnCode'] == 1) {
        ToastUtils.showText(text: '发送成功');
        res = true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  ///验证手机号验证码是否争取
  ///请求参数 phone  手机号码，  type  类型  edit:old  edit_new:新手机验证码
  static Future<bool> verifyPhoneCode({
    required String phone,
    required String code,
    required String type,
  }) async {
    String url = Config.hostUrl + UrlPath.verifyPhoneCode;

    Map<String, dynamic> parma = {'phone': phone, 'code': code, 'type': type};

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    bool res = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 &&
          response.data['returnCode'] == 1) {
        res = true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  ///验证邮箱
  ///请求参数 email  邮箱，  type  类型  edit:old  edit_new:新手机验证码
  static Future<bool> verifyEmailCode({
    required String email,
    required String code,
    required String type,
  }) async {
    String url = Config.hostUrl + UrlPath.verifyEmailCode;

    Map<String, dynamic> parma = {'email': email, 'code': code, 'type': type};

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    bool res = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 &&
          response.data['returnCode'] == 1) {
        res = true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '获取数据失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  ///更换手机号码
  ///请求参数 phone  手机号码，  type  类型  edit:old  edit_new:新手机验证码
  static Future<UserInfoModel?> editMobile({
    required String prefix,
    required String phone,
    required String code,
    required String type,
    required String oldPhoneNumber,
    required String oldPhonePassCode,
    required String oldPhoneCountryCode,
  }) async {
    String url = Config.hostUrl + UrlPath.editMobile;

    Map<String, dynamic> parma = {
      'prefix': prefix,
      'phone': phone,
      'code': code,
      'type': type,
      'oldPhoneNumber': oldPhoneNumber,
      'oldPhonePassCode': oldPhonePassCode,
      'oldPhoneCountryCode': oldPhoneCountryCode,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    UserInfoModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 && response.data['item'] != null) {
        model = UserInfoModel.fromJson(response.data['item']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '更改失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///更换邮箱
  ///请求参数 email  邮箱   type  类型  edit:old  edit_new:新手机验证码
  static Future<UserInfoModel?> editEmail({
    required String email,
    required String code,
    required String type,
    required String oldEmail,
    required String oldEmailPassCode,
  }) async {
    String url = Config.hostUrl + UrlPath.editEmail;

    Map<String, dynamic> parma = {
      'email': email,
      'code': code,
      'type': type,
      'oldEmail': oldEmail,
      'oldEmailPassCode': oldEmailPassCode,
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    UserInfoModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 && response.data['item'] != null) {
        model = UserInfoModel.fromJson(response.data['item']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '更改失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///修改密码
  ///请求参数 old_password 旧密码  password 新密码  re_password 确认新密码
  static Future<bool> editPassword({
    required String oldPassword,
    required String password,
    required String rePassword,
  }) async {
    String url = Config.hostUrl + UrlPath.editPassword;

    Map<String, dynamic> parma = {
      'old_password': oldPassword,
      'password': password,
      're_password': rePassword
    };

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    bool res = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 &&
          response.data['returnCode'] == 1) {
        ToastUtils.showText(text: '修改成功');
        res = true;
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '更改失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return res;
  }

  ///绑定手机号
  static Future<UserInfoModel?> bindPhone({
    required String phone,
    required String code,
    required String type,
  }) async {
    String url = Config.hostUrl + UrlPath.bindPhone;

    Map<String, dynamic> parma = {'phone': phone, 'code': code, 'type': type};

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    UserInfoModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 && response.data['item'] != null) {
        model = UserInfoModel.fromJson(response.data['item']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '更改失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///绑定邮箱
  static Future<UserInfoModel?> bindEmail({
    required String email,
    required String code,
    required String type,
  }) async {
    String url = Config.hostUrl + UrlPath.bindEmail;

    Map<String, dynamic> parma = {'email': email, 'code': code, 'type': type};

    Response<dynamic> response =
        await HttpManager().get(url, queryParameters: parma);
    UserInfoModel? model;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 && response.data['item'] != null) {
        model = UserInfoModel.fromJson(response.data['item']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '更改失败');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return model;
  }

  ///获取支付参数
  static Future<PayConfigModel?> getPayConf() async {
    String url = Config.hostUrl + UrlPath.payConfig;

    Response<dynamic> response = await HttpManager().get(url);
    PayConfigModel? payConfigModel;
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastUtils.hiddenAllToast();
      if (response.data['return_code'] == 1 && response.data['data'] != null) {
        payConfigModel = PayConfigModel.fromJson(response.data['data']);
      } else {
        ToastUtils.showText(text: response.data['return_info'] ?? '网络错误');
      }
    } else {
      ToastUtils.showText(text: response.statusMessage ?? '网络错误');
    }
    return payConfigModel;
  }

  ///验证银行卡或者PayPal
  static Future<Map> verifyCardPaypal({
    required String merchantNo,
    required String storeNo,
    required String amount,
    required String token,
    required String creditType,
    required String customerNo,
    required String description,
    required String ipnUrl,
    required String note,
    required String vendor, //creditcard 银行卡  paypal
  }) async {
    String refNo = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> dict = {
      "merchantNo": merchantNo,
      "storeNo": storeNo,
      "amount": amount,
      "creditType": creditType,
      "customerNo": customerNo,
      "description": description,
      "ipnUrl": ipnUrl,
      // "note": "iosDropInUI",
      "reference": refNo,
      "currency": "USD",
      "settleCurrency": "USD",
      "terminal": "APP",
      "timeout": "120",
      "vendor": vendor //creditcard 银行卡  paypal
    };

    String params = sortedDictionary(dict);
    String md5Token = generateMD5(token);
    String sign = '$params&$md5Token';
    print('pay_sign = $sign');
    // Map<String,dynamic> paramsMap = {"verifySign":generateMD5(sign)};

    dict['verifySign'] = generateMD5(sign);

    String url = Config.payHostUrl + UrlPath.cardPaypal;

    Map dataMap = {};
    try {
      Response<dynamic> response = await HttpManager().post(url, data: dict);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastUtils.hiddenAllToast();
        if (response.data != null && response.data['ret_code'] == "000100") {
          dataMap = response.data['result'];
        } else {
          ToastUtils.showText(text: response.data['ret_msg":"'] ?? '支付失败');
        }
      } else {
        ToastUtils.showText(text: response.statusMessage ?? '网络错误');
      }
    } catch (e) {
      ToastUtils.showText(text: '请求失败');
    }
    return dataMap;
  }

  static Future<bool> checkUpApp() async {
    String url = 'https://pro.ossott.com/adTest/enable';

    bool data = true;

    Response<dynamic> response = await HttpManager().get(url);
    if (response.statusCode == 200) {
      if (response.data['data'] == 0) {
        return false;
      }
    }
    return data;
  }

  static String sortedDictionary(Map<String, dynamic> dict) {
    // 将所有的key放进数组
    List<String> allKeyArray = dict.keys.toList();

    // 排序数组
    allKeyArray.sort();

    String tempStr = "";

    // 通过排列的key值获取value
    List<String> valueArray = [];

    for (String key in allKeyArray) {
      // 格式化一下，防止有些value不是string
      String valueString = dict[key].toString();

      if (valueString.isNotEmpty) {
        valueArray.add(valueString);
        tempStr = "$tempStr$key=$valueString&";
      }
    }

    // 去除最后一个&符号
    if (tempStr.isNotEmpty) {
      tempStr = tempStr.substring(0, tempStr.length - 1);
    }

    // 最终参数
    print("tempStr: $tempStr");
    return tempStr;
  }

  static String generateMD5(String input) {
    // 创建一个UTF8编码的字节数组
    Uint8List data = Uint8List.fromList(utf8.encode(input));

    // 计算MD5哈希
    Digest digest = md5.convert(data);

    // 将哈希结果转换为十六进制字符串
    String md5Value = digest.toString();

    return md5Value;
  }
}
