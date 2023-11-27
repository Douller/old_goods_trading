class OrderCreateModel {
  String? id;
  String? orderSn;
  String? totalAmount;
  String? orderStatus;
  String? orderStatusLabel;
  String? consignee;
  UserInfo? userInfo;
  SupplierInfo? supplierInfo;
  GoodsInfo? goodsInfo;
  List<ButtonList>? buttonList;

  OrderCreateModel(
      {this.id,
        this.orderSn,
        this.totalAmount,
        this.orderStatus,
        this.orderStatusLabel,
        this.consignee,
        this.userInfo,
        this.supplierInfo,
        this.goodsInfo,
        this.buttonList});

  OrderCreateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderSn = json['order_sn'];
    totalAmount = (json['total_amount']).toString();
    orderStatus = (json['order_status']).toString();
    orderStatusLabel = json['order_status_label'];
    consignee = json['consignee'];
    userInfo = json['user_info'] != null
        ? UserInfo.fromJson(json['user_info'])
        : null;
    supplierInfo = json['supplier_info'] != null
        ? SupplierInfo.fromJson(json['supplier_info'])
        : null;
    goodsInfo = json['goods_info'] != null
        ? GoodsInfo.fromJson(json['goods_info'])
        : null;
    if (json['buttonList'] != null) {
      buttonList = <ButtonList>[];
      json['buttonList'].forEach((v) {
        buttonList?.add(ButtonList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_sn'] = orderSn;
    data['total_amount'] = totalAmount;
    data['order_status'] = orderStatus;
    data['order_status_label'] = orderStatusLabel;
    data['consignee'] = consignee;
    if (userInfo != null) {
      data['user_info'] = userInfo?.toJson();
    }
    if (supplierInfo != null) {
      data['supplier_info'] = supplierInfo?.toJson();
    }
    if (goodsInfo != null) {
      data['goods_info'] = goodsInfo?.toJson();
    }
    if (buttonList != null) {
      data['buttonList'] = buttonList?.map((v) => v.toJson()).toList();
    }
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatar'] = avatar;
    data['mobile'] = mobile;
    data['nick_name'] = nickName;
    data['user_name'] = userName;
    data['sex'] = sex;
    data['sex_label'] = sexLabel;
    data['remarks'] = remarks;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['thumb'] = thumb;
    data['name'] = name;
    return data;
  }
}

class GoodsInfo {
  String? id;
  String? goodsId;
  String? goodsName;
  String? thumb;
  String? totalAmount;

  GoodsInfo(
      {this.id, this.goodsId, this.goodsName, this.thumb, this.totalAmount});

  GoodsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goodsId = json['goods_id'];
    goodsName = json['goods_name'];
    thumb = json['thumb'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['goods_id'] = goodsId;
    data['goods_name'] = goodsName;
    data['thumb'] = thumb;
    data['total_amount'] = totalAmount;
    return data;
  }
}

class ButtonList {
  String? bType;
  String? bName;
  String? actions;

  ButtonList({this.bType, this.bName, this.actions});

  ButtonList.fromJson(Map<String, dynamic> json) {
    bType = json['bType'];
    bName = json['bName'];
    actions = json['actions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bType'] = bType;
    data['bName'] = bName;
    data['actions'] = actions;
    return data;
  }
}
