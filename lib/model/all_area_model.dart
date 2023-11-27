class AllAreaModel {
  List<Area>? data;
  Pages? pages;
  String? systemId;
  int? returnCode;
  String? returnInfo;

  AllAreaModel(
      {this.data, this.pages, this.systemId, this.returnCode, this.returnInfo});

  AllAreaModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Area>[];
      json['data'].forEach((v) {
        data?.add(Area.fromJson(v));
      });
    }
    pages = json['pages'] != null ? Pages.fromJson(json['pages']) : null;
    systemId = json['system_id'];
    returnCode = json['return_code'];
    returnInfo = json['return_info'];
  }
}

class Area {
  String? id;
  String? name;
  String? slug;
  String? isHot;
  String? parentId;
  String? latitude;
  String? longitude;
  List<Children>? children;

  Area(
      {this.id,
      this.name,
      this.slug,
      this.isHot,
      this.parentId,
      this.latitude,
      this.longitude,
      this.children});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    slug = json['slug'];
    isHot = json['is_hot'];
    parentId = json['parent_id'].toString();
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children?.add(Children.fromJson(v));
      });
    }
  }
}

class Children {
  String? id;
  String? name;
  String? slug;
  String? isHot;
  String? parentId;
  String? latitude;
  String? longitude;
  List<Children>? children;

  Children({
    this.id,
    this.name,
    this.slug,
    this.isHot,
    this.parentId,
    this.children,
    this.latitude,
    this.longitude,
  });

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    isHot = json['is_hot'];
    parentId = json['parent_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children?.add(Children.fromJson(v));
      });
    }
  }
}

class Pages {
  String? page;
  int? pageTotal;

  Pages({this.page, this.pageTotal});

  Pages.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    pageTotal = json['page_total'];
  }
}
