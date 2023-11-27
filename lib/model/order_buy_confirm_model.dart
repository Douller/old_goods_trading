class SubmitOrderModel {
  String? deliveryName;
  num? deliveryAmount;
  AddressModelInfo? addressInfo;
  List<CouponInfo>? couponInfo;

  SubmitOrderModel(
      {this.deliveryName,
      this.deliveryAmount,
      this.addressInfo,
      this.couponInfo});

  SubmitOrderModel.fromJson(Map<String, dynamic> json) {
    deliveryName = json['delivery_name'];
    deliveryAmount = json['delivery_amount'];
    addressInfo = (json['address_info'] != null &&
            json['address_info'] is Map<String, dynamic>)
        ? AddressModelInfo.fromJson(json['address_info'])
        : null;
    if (json['coupon_info'] != null) {
      couponInfo = <CouponInfo>[];
      json['coupon_info'].forEach((v) {
        couponInfo?.add(CouponInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['delivery_name'] = deliveryName;
    data['delivery_amount'] = deliveryAmount;
    if (addressInfo != null) {
      data['address_info'] = addressInfo?.toJson();
    }
    if (couponInfo != null) {
      data['coupon_info'] = couponInfo?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CouponInfo {
  String? id;
  String? name;
  String? userId;
  String? value;
  String? bindValue;
  String? useStatus;
  String? useBeginTime;
  String? useEndTime;

  CouponInfo(
      {this.id,
      this.name,
      this.userId,
      this.value,
      this.bindValue,
      this.useStatus,
      this.useBeginTime,
      this.useEndTime});

  CouponInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    value = json['value'];
    bindValue = json['bind_value'];
    useStatus = json['useStatus'];
    useBeginTime = json['useBeginTime'];
    useEndTime = json['useEndTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_id'] = userId;
    data['value'] = value;
    data['bind_value'] = bindValue;
    data['useStatus'] = useStatus;
    data['useBeginTime'] = useBeginTime;
    data['useEndTime'] = useEndTime;
    return data;
  }
}

class AddressModelInfo {
  String? id;
  String? consignee;
  String? xing;
  String? address;
  String? address2;
  String? telephone;
  String? isDefault;
  String? countryId;
  String? countryName;
  String? quanId;
  String? cityId;
  String? cityName;
  String? provinceId;
  String? provinceName;
  String? delivery;
  String? zipcode;
  String? xpoint;
  String? ypoint;
  String? addressAll;

  AddressModelInfo(
      {this.id,
      this.consignee,
      this.xing,
      this.address,
      this.address2,
      this.telephone,
      this.isDefault,
      this.countryId,
      this.cityName,
      this.quanId,
      this.cityId,
      this.countryName,
      this.provinceId,
      this.provinceName,
      this.delivery,
      this.xpoint,
      this.zipcode,
      this.ypoint,
        this.addressAll,
      });

  AddressModelInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    consignee = json['consignee'];
    xing = json['xing'];
    address = json['address'];
    address2 = json['address2'];
    telephone = json['telephone'];
    isDefault = json['is_default'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    cityName = json['city_name'];
    provinceName = json['province_name'];
    quanId = json['quan_id'];
    cityId = json['city_id'];
    provinceId = json['province_id'];
    delivery = json['delivery'];
    zipcode = json['zipcode'];
    xpoint = json['xpoint'];
    ypoint = json['ypoint'];
    addressAll = json['address_all'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['consignee'] = consignee;
    data['address'] = address;
    data['telephone'] = telephone;
    data['is_default'] = isDefault;
    data['quan_id'] = quanId;
    data['city_id'] = cityId;
    data['province_id'] = provinceId;
    data['delivery'] = delivery;
    data['xpoint'] = xpoint;
    data['ypoint'] = ypoint;
    return data;
  }
}
