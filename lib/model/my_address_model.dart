import 'order_buy_confirm_model.dart';

class MyAddressModel {
  List<AddressModelInfo>? data;
  String? systemId;
  int? returnCode;
  String? returnInfo;

  MyAddressModel({this.data, this.systemId, this.returnCode, this.returnInfo});

  MyAddressModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AddressModelInfo>[];
      json['data'].forEach((v) {
        if (v is Map<String, dynamic>) {
          data?.add(AddressModelInfo.fromJson(v));
        }
      });
    }
    systemId = json['system_id'];
    returnCode = json['return_code'];
    returnInfo = json['return_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['system_id'] = systemId;
    data['return_code'] = returnCode;
    data['return_info'] = returnInfo;
    return data;
  }
}

// class AddressModel {
//   String? id;
//   String? consignee;
//   String? address;
//   String? telephone;
//   String? isDefault;
//   String? quanId;
//   String? cityId;
//   String? provinceId;
//   String? delivery;
//   String? xpoint;
//   String? ypoint;
//
//   AddressModel(
//       {this.id,
//       this.consignee,
//       this.address,
//       this.telephone,
//       this.isDefault,
//       this.quanId,
//       this.cityId,
//       this.provinceId,
//       this.delivery,
//       this.xpoint,
//       this.ypoint});
//
//   AddressModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     consignee = json['consignee'];
//     address = json['address'];
//     telephone = json['telephone'];
//     isDefault = json['is_default'];
//     quanId = json['quan_id'];
//     cityId = json['city_id'];
//     provinceId = json['province_id'];
//     delivery = json['delivery'];
//     xpoint = json['xpoint'];
//     ypoint = json['ypoint'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['consignee'] = consignee;
//     data['address'] = address;
//     data['telephone'] = telephone;
//     data['is_default'] = isDefault;
//     data['quan_id'] = quanId;
//     data['city_id'] = cityId;
//     data['province_id'] = provinceId;
//     data['delivery'] = delivery;
//     data['xpoint'] = xpoint;
//     data['ypoint'] = ypoint;
//     return data;
//   }
// }
