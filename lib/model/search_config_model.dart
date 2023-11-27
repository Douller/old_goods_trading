class SearchConfigModel {
  List<Result>? result;
  String? systemId;
  int? returnCode;
  String? returnInfo;

  SearchConfigModel(
      {this.result, this.systemId, this.returnCode, this.returnInfo});

  SearchConfigModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      result = <Result>[];
      json['data'].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
    systemId = json['system_id'];
    returnCode = json['return_code'];
    returnInfo = json['return_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['data'] = result?.map((v) => v.toJson()).toList();
    }
    data['system_id'] = systemId;
    data['return_code'] = returnCode;
    data['return_info'] = returnInfo;
    return data;
  }
}

class Result {
  String? type;
  String? name;
  String? key;
  List<Data>? data;
  String? keyInput;

  Result({this.type, this.name, this.key, this.data, this.keyInput});

  Result.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    key = json['key'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    keyInput = json['key_input'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['key'] = key;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['key_input'] = keyInput;
    return data;
  }
}

class Data {
  String? id;
  String? name;
  int? isDefault;
  String? slug;
  String? isHot;
  String? parentId;
  List<Children>? children;
  String? type;
  String? key;
  List<Data>? data;
  String? keyInput;
  String? subName;

  Data({
    this.id,
    this.name,
    this.isDefault,
    this.slug,
    this.isHot,
    this.parentId,
    this.children,
    this.type,
    this.key,
    this.data,
    this.keyInput,
    this.subName,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    isDefault = json['is_default'];
    slug = json['slug'];
    isHot = json['is_hot'];
    parentId = json['parent_id'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children?.add(Children.fromJson(v));
      });
    }
    type = json['type'];
    key = json['key'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    keyInput = json['key_input'];
    subName = json['sub_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_default'] = isDefault;
    data['slug'] = slug;
    data['is_hot'] = isHot;
    data['parent_id'] = parentId;
    if (children != null) {
      data['children'] = children?.map((v) => v.toJson()).toList();
    }
    data['type'] = type;
    data['key'] = key;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['key_input'] = keyInput;
    data['sub_name'] = subName;

    return data;
  }
}

class Children {
  String? id;
  String? name;
  String? slug;
  String? isHot;
  String? parentId;
  List<Children>? children;

  Children(
      {this.id,
      this.name,
      this.slug,
      this.isHot,
      this.parentId,
      this.children});

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    isHot = json['is_hot'];
    parentId = json['parent_id'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children?.add(Children.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['is_hot'] = isHot;
    data['parent_id'] = parentId;
    if (children != null) {
      data['children'] = children?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
