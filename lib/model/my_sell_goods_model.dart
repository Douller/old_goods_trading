import 'goods_details_model.dart';

class MySellGoodsModel {
  List<MySellGoodsData>? data;
  String? systemId;
  int? returnCode;
  String? returnInfo;

  MySellGoodsModel(
      {this.data, this.systemId, this.returnCode, this.returnInfo});

  MySellGoodsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MySellGoodsData>[];
      json['data'].forEach((v) {
        data?.add(MySellGoodsData.fromJson(v));
      });
    }
    systemId = json['system_id'];
    returnCode = json['return_code'];
    returnInfo = json['return_info'];
  }
}

class MySellGoodsData {
  String? id;
  String? orderSn;
  String? totalAmount;
  String? goodsAmount;
  String? fare;
  String? discountAmount;
  String? orderStatus;
  String? orderStatusLabel;
  String? userMemo;
  String? consignee;
  UserInfo? userInfo;
  SupplierInfo? supplierInfo;
  GoodsInfo? goodsInfo;
  List<ButtonList>? buttonList;
  AddressInfo? addressInfo;
  String? createTime;
  String? paymentId;
  String? deliveryNo;
  String? deliveryCompany;
  String? addressAll;
  int? statusLujing;
  int? lastPayTime;
  List<StatusLiucheng>? statusLiucheng;
  String? refundType;
  String? refundTypeName;
  String? refundReason;
  String? statusContent;
  LastLog? lastLog;
  List<CommentList>? commentList;
  DeliveryInfo? deliveryInfo;

  MySellGoodsData({
    this.id,
    this.orderSn,
    this.totalAmount,
    this.orderStatus,
    this.goodsAmount,
    this.discountAmount,
    this.fare,
    this.orderStatusLabel,
    this.userMemo,
    this.consignee,
    this.userInfo,
    this.supplierInfo,
    this.goodsInfo,
    this.buttonList,
    this.addressInfo,
    this.paymentId,
    this.deliveryNo,
    this.deliveryCompany,
    this.addressAll,
    this.statusLujing,
    this.createTime,
    this.statusLiucheng,
    this.lastPayTime,
    this.refundType,
    this.refundTypeName,
    this.refundReason,
    this.statusContent,
    this.lastLog,
    this.commentList,
    this.deliveryInfo,
  });

  MySellGoodsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderSn = json['order_sn'];
    totalAmount = json['total_amount'];
    orderStatus = json['order_status'];
    orderStatusLabel = json['order_status_label'];
    userMemo = json['user_memo'];
    consignee = json['consignee'];
    goodsAmount = json['goods_amount'];
    fare = json['fare'];
    discountAmount = json['discount_amount'];
    createTime = json['create_time'];
    paymentId = json['payment_id'];
    deliveryNo = json['delivery_no'];
    deliveryCompany = json['delivery_company'];
    statusLujing = json['status_lujing'];
    addressAll = json['addressAll'];
    lastPayTime = json['last_pay_time'];
    refundType = json['refund_type'];
    refundTypeName = json['refund_type_name'];
    refundReason = json['refund_reason'];
    statusContent = json['status_content'];
    lastLog =
        json['last_log'] != null ? LastLog.fromJson(json['last_log']) : null;
    userInfo =
        json['user_info'] != null ? UserInfo.fromJson(json['user_info']) : null;
    supplierInfo = json['supplier_info'] != null
        ? SupplierInfo.fromJson(json['supplier_info'])
        : null;
    goodsInfo = json['goods_info'] != null
        ? GoodsInfo.fromJson(json['goods_info'])
        : null;
    addressInfo = json['address_info'] != null
        ? AddressInfo.fromJson(json['address_info'])
        : null;
    deliveryInfo = json['delivery_info'] != null
        ? DeliveryInfo.fromJson(json['delivery_info'])
        : null;
    if (json['buttonList'] != null) {
      buttonList = <ButtonList>[];
      json['buttonList'].forEach((v) {
        buttonList?.add(ButtonList.fromJson(v));
      });
    }
    if (json['status_liucheng'] != null) {
      statusLiucheng = <StatusLiucheng>[];
      json['status_liucheng'].forEach((v) {
        statusLiucheng?.add(StatusLiucheng.fromJson(v));
      });
    }
    if (json['comment'] != null) {
      commentList = <CommentList>[];
      json['comment'].forEach((v) {
        commentList?.add(CommentList.fromJson(v));
      });
    }
  }
}

class UserInfo {
  String? id;
  String? avatar;
  String? mobile;
  String? nickName;
  String? userName;
  String? sex;
  String? sexLabel;
  String? remarks;

  UserInfo(
      {this.id,
      this.avatar,
      this.mobile,
      this.nickName,
      this.userName,
      this.sex,
      this.sexLabel,
      this.remarks});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    mobile = json['mobile'];
    nickName = json['nick_name'];
    userName = json['user_name'];
    sex = json['sex'];
    sexLabel = json['sex_label'];
    remarks = json['remarks'];
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
}

class DeliveryInfo {
  String? statusName;
  String? statusDesc;
  String? statusInfo;

  DeliveryInfo({this.statusName, this.statusDesc, this.statusInfo});

  DeliveryInfo.fromJson(Map<String, dynamic> json) {
    statusName = json['status_name'];
    statusDesc = json['status_desc'];
    statusInfo = json['status_info'];
  }
}

class GoodsInfo {
  String? id;
  String? goodsId;
  String? goodsName;
  String? name;
  String? thumb;
  String? thumbUrl;
  String? totalAmount;
  String? brushingCondition;
  String? shopPrice;

  GoodsInfo(
      {this.id,
      this.goodsId,
      this.goodsName,
      this.name,
      this.thumb,
      this.thumbUrl,
      this.totalAmount,
      this.shopPrice,
      this.brushingCondition});

  GoodsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    shopPrice = json['shop_price'];
    name = json['name'];
    thumb = json['thumb'];
    thumbUrl = json['thumb_url'];
    totalAmount = json['total_amount'];
    brushingCondition = json['brushing_condition'];
  }
}

class ButtonList {
  String? bType;
  String? bName;
  String? actions;
  String? optionTitle;

  ButtonList({this.bType, this.bName, this.actions, this.optionTitle});

  ButtonList.fromJson(Map<String, dynamic> json) {
    bType = json['bType'];
    bName = json['bName'];
    actions = json['actions'];
    optionTitle = json['option_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bType'] = bType;
    data['bName'] = bName;
    data['actions'] = actions;
    return data;
  }
}

class AddressInfo {
  String? id;
  String? consignee;
  String? address;
  String? telephone;
  String? isDefault;
  String? quanId;
  String? cityId;
  String? provinceId;
  String? delivery;
  String? xpoint;
  String? ypoint;

  AddressInfo(
      {this.id,
      this.consignee,
      this.address,
      this.telephone,
      this.isDefault,
      this.quanId,
      this.cityId,
      this.provinceId,
      this.delivery,
      this.xpoint,
      this.ypoint});

  AddressInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    consignee = json['consignee'];
    address = json['address'];
    telephone = json['telephone'];
    isDefault = json['is_default'];
    quanId = json['quan_id'];
    cityId = json['city_id'];
    provinceId = json['province_id'];
    delivery = json['delivery'];
    xpoint = json['xpoint'];
    ypoint = json['ypoint'];
  }
}

class StatusLiucheng {
  String? name;
  int? isSelect;
  int? status;

  StatusLiucheng({this.name, this.isSelect, this.status});

  StatusLiucheng.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isSelect = json['is_select'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['is_select'] = isSelect;
    data['status'] = status;
    return data;
  }
}

class LastLog {
  int? id;
  String? name;
  String? content;

  LastLog({this.id, this.name, this.content});

  LastLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    content = json['content'];
  }
}


class Yuansfer {
  String? customerNo;
  String? creditType;

  Yuansfer({this.customerNo,this.creditType});

  Yuansfer.fromJson(Map<String, dynamic> json) {
    customerNo = json['customerNo'];
    creditType = json['creditType'];
  }
}