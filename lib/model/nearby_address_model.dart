class NearbyAddressModel {
  List<Data>? data;
  String? systemId;
  int? returnCode;
  String? returnInfo;

  NearbyAddressModel(
      {this.data, this.systemId, this.returnCode, this.returnInfo});

  NearbyAddressModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    systemId = json['system_id'];
    returnCode = json['return_code'];
    returnInfo = json['return_info'];
  }
}

class Data {
  String? id;
  String? name;
  String? addres;
  String? longitude;
  String? latitude;
  String? city;
  String? province;
  String? addressId;
  String? addressInfo;
  String? zipcode;

  Data({
    this.id,
    this.name,
    this.addres,
    this.longitude,
    this.latitude,
    this.city,
    this.province,
    this.addressId,
    this.addressInfo,
    this.zipcode,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    addres = json['addres'];
    longitude = json['longitude'].toString();
    latitude = json['latitude'].toString();
    city = json['city'];
    province = json['province'];
    addressInfo = json['address_info'];
    addressId = json['address_id'].toString();
    zipcode = json['zipcode'].toString();
  }
}
