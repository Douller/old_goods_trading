class AddPublishInfoModel {
  List<Brands>? brands;
  List<BrushingCondition>? brushingCondition;
  List<BrushingCondition>? purchaseTime;
  List<BrushingCondition>? boxSize;
  String? serviceCharge;
  String? serviceChargeDesc;

  AddPublishInfoModel(
      {this.brands,
        this.brushingCondition,
        this.purchaseTime,
        this.boxSize,
        this.serviceCharge,
        this.serviceChargeDesc});

  AddPublishInfoModel.fromJson(Map<String, dynamic> json) {
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands?.add(Brands.fromJson(v));
      });
    }
    if (json['brushing_condition'] != null) {
      brushingCondition = <BrushingCondition>[];
      json['brushing_condition'].forEach((v) {
        brushingCondition?.add(BrushingCondition.fromJson(v));
      });
    }
    if (json['purchase_time'] != null) {
      purchaseTime =  <BrushingCondition>[];
      json['purchase_time'].forEach((v) {
        purchaseTime?.add( BrushingCondition.fromJson(v));
      });
    }
    if (json['box_size'] != null) {
      boxSize = <BrushingCondition>[];
      json['box_size'].forEach((v) {
        boxSize?.add(BrushingCondition.fromJson(v));
      });
    }
    serviceCharge = json['service_charge'];
    serviceChargeDesc = json['service_charge_desc'];
  }
}

class Brands {
  String? id;
  String? name;
  String? icon;
  String? slug;

  Brands({this.id, this.name, this.icon, this.slug});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    slug = json['slug'];
  }
}

class BrushingCondition {
  int? id;
  String? name;
  int? isDefault;
  String? subName;

  BrushingCondition({this.id, this.name, this.isDefault, this.subName});

  BrushingCondition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isDefault = json['is_default'];
    subName = json['sub_name'];
  }
}
