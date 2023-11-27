import 'add_publish_info_model.dart';

class CategoryModel {
  List<CategoryData>? data;
  String? systemId;
  int? returnCode;
  String? returnInfo;

  CategoryModel({this.data, this.systemId, this.returnCode, this.returnInfo});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data?.add(CategoryData.fromJson(v));
      });
    }
    systemId = json['system_id'];
    returnCode = json['return_code'];
    returnInfo = json['return_info'];
  }
}

class CategoryData {
  String? id;
  String? name;
  String? icon;
  String? status;
  List<Sons>? sons;
  List<Brands>? brands;
  List<Advs>? advs;
  String? sort;

  CategoryData(
      {this.id,
      this.name,
      this.icon,
      this.status,
      this.sons,
      this.brands,
      this.sort,
      this.advs});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    status = json['status'];
    sort = json['sort'];
    if (json['sons'] != null) {
      sons = <Sons>[];
      json['sons'].forEach((v) {
        sons?.add(Sons.fromJson(v));
      });
    }
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands?.add(Brands.fromJson(v));
      });
    }
    if (json['advs'] != null) {
      advs = <Advs>[];
      json['advs'].forEach((v) {
        if (v is Map<String, dynamic>) {
          advs?.add(Advs.fromJson(v));
        }
      });
    }
  }
}

class Sons {
  String? id;
  String? name;
  String? icon;
  String? status;
  String? sort;

  Sons({
    this.id,
    this.name,
    this.icon,
    this.status,
    this.sort,
  });

  Sons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    status = json['status'];
    sort = json['sort'];
  }
}

class Advs {
  String? id;
  String? name;
  String? image;
  String? status;
  Jump? jump;

  Advs({this.id, this.name, this.image, this.status, this.jump});

  Advs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
    jump = json['jump'] != null ? Jump.fromJson(json['jump']) : null;
  }
}

class Jump {
  String? type;
  String? data;
  String? redirectType;

  Jump({this.type, this.data, this.redirectType});

  Jump.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'];
    redirectType = json['redirect_type'];
  }
}
