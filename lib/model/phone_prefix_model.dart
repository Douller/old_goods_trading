class PhonePrefixModel {
  List<PhonePrefixData>? data;
  String? systemId;
  int? returnCode;
  String? returnInfo;

  PhonePrefixModel(
      {this.data, this.systemId, this.returnCode, this.returnInfo});

  PhonePrefixModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PhonePrefixData>[];
      json['data'].forEach((v) {
        data!.add(PhonePrefixData.fromJson(v));
      });
    }
    systemId = json['system_id'];
    returnCode = json['return_code'];
    returnInfo = json['return_info'];
  }

}

class PhonePrefixData {
  int? id;
  String? val;
  String? name;

  PhonePrefixData({this.id, this.val, this.name});

  PhonePrefixData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    val = json['val'];
    name = json['name'];
  }
}
