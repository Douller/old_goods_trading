class OrderAfterProcessingModel {
  List<AfterProcessingModel>? afterProcessingModel;
  String? systemId;
  int? returnCode;
  String? returnInfo;

  OrderAfterProcessingModel(
      {this.afterProcessingModel,
        this.systemId,
        this.returnCode,
        this.returnInfo});

  OrderAfterProcessingModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      afterProcessingModel = <AfterProcessingModel>[];
      json['data'].forEach((v) {
        afterProcessingModel?.add(AfterProcessingModel.fromJson(v));
      });
    }
    systemId = json['system_id'];
    returnCode = json['return_code'];
    returnInfo = json['return_info'];
  }
}

class AfterProcessingModel {
  String? id;
  String? orderSn;
  String? totalAmount;
  String? refundType;
  String? refundTypeName;
  String? orderStatus;
  String? orderStatusLabel;
  String? userMemo;
  UserInfo? userInfo;
  SupplierInfo? supplierInfo;
  GoodsInfo? goodsInfo;
  List<ButtonList>? buttonList;
  String? statusContent;
  String? optionTitle;
  AfterProcessingModel(
      {this.id,
        this.orderSn,
        this.totalAmount,
        this.refundType,
        this.refundTypeName,
        this.orderStatus,
        this.orderStatusLabel,
        this.userMemo,
        this.userInfo,
        this.supplierInfo,
        this.goodsInfo,
        this.buttonList,
        this.statusContent,this.optionTitle});

  AfterProcessingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderSn = json['order_sn'];
    totalAmount = json['total_amount'];
    refundType = json['refund_type'];
    refundTypeName = json['refund_type_name'];
    orderStatus = json['order_status'];
    orderStatusLabel = json['order_status_label'];
    userMemo = json['user_memo'];
    optionTitle = json['option_title'];
    userInfo = json['user_info'] != null
        ?  UserInfo.fromJson(json['user_info'])
        : null;
    supplierInfo = json['supplier_info'] != null
        ?  SupplierInfo.fromJson(json['supplier_info'])
        : null;
    goodsInfo = json['goods_info'] != null
        ?  GoodsInfo.fromJson(json['goods_info'])
        : null;
    if (json['buttonList'] != null) {
      buttonList =  <ButtonList>[];
      json['buttonList'].forEach((v) {
        buttonList?.add( ButtonList.fromJson(v));
      });
    }
    statusContent = json['status_content'];
  }

}

class UserInfo {
  String? id;
  String? uid;
  String? avatar;
  String? mobile;
  String? nickName;
  String? userName;
  String? sex;
  String? sexLabel;
  String? remarks;
  String? birthday;

  UserInfo(
      {this.id,
        this.uid,
        this.avatar,
        this.mobile,
        this.nickName,
        this.userName,
        this.sex,
        this.sexLabel,
        this.remarks,
        this.birthday});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    avatar = json['avatar'];
    mobile = json['mobile'];
    nickName = json['nick_name'];
    userName = json['user_name'];
    sex = json['sex'];
    sexLabel = json['sex_label'];
    remarks = json['remarks'];
    birthday = json['birthday'];
  }
}

class SupplierInfo {
  String? id;
  String? thumb;
  String? name;

  SupplierInfo({this.id, this.thumb, this.name});

  SupplierInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumb = json['thumb'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['thumb'] = thumb;
    data['name'] = name;
    return data;
  }
}

class GoodsInfo {
  String? id;
  String? thumb;
  String? thumbUrl;
  String? name;
  String? categoryId;
  String? categoryName;
  String? shopPrice;
  String? marketPrice;
  String? brief;
  String? score;
  String? tags;
  String? brushingCondition;
  String? deliveryType;
  String? deliveryAmount;
  String? brandId;
  String? brandName;
  String? status;
  String? statusName;
  List<Gallery>? gallery;
  SupplierInfo? supplierInfo;

  GoodsInfo(
      {this.id,
        this.thumb,
        this.thumbUrl,
        this.name,
        this.categoryId,
        this.categoryName,
        this.shopPrice,
        this.marketPrice,
        this.brief,
        this.score,
        this.tags,
        this.brushingCondition,
        this.deliveryType,
        this.deliveryAmount,
        this.brandId,
        this.brandName,
        this.status,
        this.statusName,
        this.gallery,
        this.supplierInfo});

  GoodsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumb = json['thumb'];
    thumbUrl = json['thumb_url'];
    name = json['name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    shopPrice = json['shop_price'];
    marketPrice = json['market_price'];
    brief = json['brief'];
    score = json['score'];
    tags = json['tags'];
    brushingCondition = json['brushing_condition'];
    deliveryType = json['delivery_type'];
    deliveryAmount = json['delivery_amount'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    status = json['status'];
    statusName = json['status_name'];
    if (json['gallery'] != null) {
      gallery =  <Gallery>[];
      json['gallery'].forEach((v) {
        gallery?.add( Gallery.fromJson(v));
      });
    }
    supplierInfo = json['supplier_info'] != null
        ?  SupplierInfo.fromJson(json['supplier_info'])
        : null;
  }
}

class Gallery {
  String? image;
  String? url;

  Gallery({this.image, this.url});

  Gallery.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    url = json['url'];
  }
}

class ButtonList {
  String? bType;
  String? bName;
  String? actions;
  String? optionTitle;
  ButtonList({this.bType, this.bName, this.actions,this.optionTitle});

  ButtonList.fromJson(Map<String, dynamic> json) {
    bType = json['bType'];
    bName = json['bName'];
    actions = json['actions'];
    optionTitle = json['option_title'];
  }
}
