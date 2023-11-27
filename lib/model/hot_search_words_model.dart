class HotSearchWordsModel {
  List<Data>? data;
  String? systemId;
  int? returnCode;
  String? returnInfo;

  HotSearchWordsModel(
      {this.data, this.systemId, this.returnCode, this.returnInfo});

  HotSearchWordsModel.fromJson(Map<String, dynamic> json) {
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

class Data {
  String? keyword;
  String? count;

  Data({this.keyword, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keyword'] = keyword;
    data['count'] = count;
    return data;
  }
}
