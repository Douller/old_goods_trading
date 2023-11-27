import 'home_goods_list_model.dart';

class SearchGoodsListModel {
  List<GoodsInfoModel>? data;
  // Search? search;
  Page? page;
  String? systemId;
  int? returnCode;
  String? returnInfo;

  SearchGoodsListModel(
      {this.data,
      // this.search,
      this.page,
      this.systemId,
      this.returnCode,
      this.returnInfo});

  SearchGoodsListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GoodsInfoModel>[];
      json['data'].forEach((v) {
        data?.add(GoodsInfoModel.fromJson(v));
      });
    }
    // search = json['search'] != null ? Search.fromJson(json['search']) : null;
    page = json['page'] != null ? Page.fromJson(json['page']) : null;
    systemId = json['system_id'];
    returnCode = json['return_code'];
    returnInfo = json['return_info'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   if (this.data != null) {
  //     data['data'] = this.data?.map((v) => v.toJson()).toList();
  //   }
  //   // if (search != null) {
  //   //   data['search'] = search?.toJson();
  //   // }
  //   if (page != null) {
  //     data['page'] = page?.toJson();
  //   }
  //   data['system_id'] = systemId;
  //   data['return_code'] = returnCode;
  //   data['return_info'] = returnInfo;
  //   return data;
  // }
}

// class SearchGoods {
//   String? id;
//   String? thumb;
//   String? thumbUrl;
//   String? name;
//   String? categoryId;
//   String? categoryName;
//   String? shopPrice;
//   String? marketPrice;
//   String? brief;
//   String? score;
//   String? tags;
//   String? brushingCondition;
//   String? status;
//   String? statusName;
//   List<Gallery>? gallery;
//   SupplierInfo? supplierInfo;
//
//   SearchGoods(
//       {this.id,
//       this.thumb,
//       this.thumbUrl,
//       this.name,
//       this.categoryId,
//       this.categoryName,
//       this.shopPrice,
//       this.marketPrice,
//       this.brief,
//       this.score,
//       this.tags,
//       this.brushingCondition,
//       this.status,
//       this.statusName,
//       this.gallery,
//       this.supplierInfo});
//
//   SearchGoods.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     thumb = json['thumb'];
//     thumbUrl = json['thumb_url'];
//     name = json['name'];
//     categoryId = json['category_id'];
//     categoryName = json['category_name'];
//     shopPrice = json['shop_price'];
//     marketPrice = json['market_price'];
//     brief = json['brief'];
//     score = json['score'];
//     tags = json['tags'];
//     brushingCondition = json['brushing_condition'];
//     status = json['status'];
//     statusName = json['status_name'];
//     if (json['gallery'] != null) {
//       gallery = <Gallery>[];
//       json['gallery'].forEach((v) {
//         gallery?.add(Gallery.fromJson(v));
//       });
//     }
//     supplierInfo = json['supplier_info'] != null
//         ? SupplierInfo.fromJson(json['supplier_info'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['thumb'] = thumb;
//     data['thumb_url'] = thumbUrl;
//     data['name'] = name;
//     data['category_id'] = categoryId;
//     data['category_name'] = categoryName;
//     data['shop_price'] = shopPrice;
//     data['market_price'] = marketPrice;
//     data['brief'] = brief;
//     data['score'] = score;
//     data['tags'] = tags;
//     data['brushing_condition'] = brushingCondition;
//     data['status'] = status;
//     data['status_name'] = statusName;
//     if (gallery != null) {
//       data['gallery'] = gallery?.map((v) => v.toJson()).toList();
//     }
//     if (supplierInfo != null) {
//       data['supplier_info'] = supplierInfo?.toJson();
//     }
//     return data;
//   }
// }
//
// class Gallery {
//   String? image;
//   String? url;
//
//   Gallery({this.image, this.url});
//
//   Gallery.fromJson(Map<String, dynamic> json) {
//     image = json['image'];
//     url = json['url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['image'] = image;
//     data['url'] = url;
//     return data;
//   }
// }
//
// class SupplierInfo {
//   String? id;
//   String? thumb;
//   String? name;
//
//   SupplierInfo({this.id, this.thumb, this.name});
//
//   SupplierInfo.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     thumb = json['thumb'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['thumb'] = thumb;
//     data['name'] = name;
//     return data;
//   }
// }

// class Search {
//   String? configKey;
//   String? configId;
//   String? keywords;
//
//   Search({this.configKey, this.configId, this.keywords});
//
//   Search.fromJson(Map<String, dynamic> json) {
//     configKey = json['config_key'];
//     configId = json['config_id'];
//     keywords = json['keywords'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['config_key'] = configKey;
//     data['config_id'] = configId;
//     data['keywords'] = keywords;
//     return data;
//   }
// }

class Page {
  String? page;
  int? pageTotal;

  Page({this.page, this.pageTotal});

  Page.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    pageTotal = json['page_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['page_total'] = pageTotal;
    return data;
  }
}
