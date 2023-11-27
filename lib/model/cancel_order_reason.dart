class CancelOrderReasonModel {
  List<Item>? item;
  String ?systemId;
  int? returnCode;
  String? returnInfo;

  CancelOrderReasonModel(
      {this.item, this.systemId, this.returnCode, this.returnInfo});

  CancelOrderReasonModel.fromJson(Map<String, dynamic> json) {
    if (json['item'] != null) {
      item = <Item>[];
      json['item'].forEach((v) {
        item?.add(Item.fromJson(v));
      });
    }
    systemId = json['system_id'];
    returnCode = json['return_code'];
    returnInfo = json['return_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (item != null) {
      data['item'] = item?.map((v) => v.toJson()).toList();
    }
    data['system_id'] = systemId;
    data['return_code'] = returnCode;
    data['return_info'] = returnInfo;
    return data;
  }
}

class Item {
  int? id;
  String? name;

  Item({this.id, this.name});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
