import 'package:old_goods_trading/net/service_repository.dart';
class HomeGoodsListModel {
  GoodsLists? goodsLists;
  List<Advs>? advs;

  HomeGoodsListModel({this.goodsLists});

  HomeGoodsListModel.fromJson(Map<String, dynamic> json) {
    goodsLists = json['goods_lists'] != null
        ? GoodsLists.fromJson(json['goods_lists'])
        : null;
    if (json['advs'] != null) {
      advs = <Advs>[];
      json['advs'].forEach((v) {
        advs?.add(Advs.fromJson(v));
      });
    }
  }
}

class GoodsLists {
  List<GoodsInfoModel>? data;
  Page? page;

  GoodsLists({this.data, this.page});

  GoodsLists.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GoodsInfoModel>[];
      json['data'].forEach((v) {
        data?.add(GoodsInfoModel.fromJson(v));
      });
    }
    page = json['page'] != null ? Page.fromJson(json['page']) : null;
  }
}

class GoodsInfoModel {
  String? id;
  String? thumb;
  String? thumbUrl;
  String? name;
  String? categoryId;
  String? categoryName;
  String? shopPrice;
  String? marketPrice;
  String? brief;
  String? score;
  String? tags;
  String? brushingCondition;
  String? deliveryType;
  String? deliveryTypes;
  String? deliveryAmount;
  String? deliveryCity;
  String? deliveryWay;
  String? longitude;
  String? latitude;
  String? brandId;
  String? brandName;
  String? status;
  String? statusName;
  String? notice;
  String? distance;
  String? publishTime;
  List<Gallery>? gallery;
  SupplierInfo? supplierInfo;
  List<Images>? images;
  String? purchaseTime;
  String? selfPickup;
  String? boxSize;
  String? displayBuyBoutton;
  String? state;

  GoodsInfoModel({
    this.id,
    this.thumb,
    this.thumbUrl,
    this.name,
    this.categoryId,
    this.categoryName,
    this.shopPrice,
    this.marketPrice,
    this.brief,
    this.score,
    this.tags,
    this.brushingCondition,
    this.purchaseTime,
    this.deliveryTypes,
    this.deliveryType,
    this.deliveryCity,
    this.deliveryWay,
    this.deliveryAmount,
    this.brandId,
    this.brandName,
    this.status,
    this.statusName,
    this.longitude,
    this.latitude,
    this.distance,
    this.publishTime,
    this.gallery,
    this.supplierInfo,
    this.images,
    this.selfPickup,
    this.boxSize,
    this.displayBuyBoutton,
    this.state,
  });

  GoodsInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumb = json['thumb'];
    thumbUrl = json['thumb_url'];
    name = json['name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    shopPrice = json['shop_price'];
    marketPrice = json['market_price'];
    brief = json['brief'];
    score = json['score'];
    tags = json['tags'];
    notice = json['notice'];
    brushingCondition = json['brushing_condition'];
    purchaseTime = json['purchase_time'];
    deliveryType = json['delivery_type'];
    deliveryTypes = json['delivery_types'];
    deliveryAmount = json['delivery_amount'];
    deliveryCity = json['delivery_city'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    status = json['status'];
    distance = json['distance'];
    statusName = json['status_name'];
    deliveryWay = json['delivery_way'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    publishTime = json['publish_time'];
    selfPickup = json['self_pickup'];
    boxSize = json['box_size'];
    displayBuyBoutton = json['display_buy_boutton'].toString();
    if (json['gallery'] != null) {
      gallery = <Gallery>[];
      json['gallery'].forEach((v) {
        gallery?.add(Gallery.fromJson(v));
      });
    }
    supplierInfo = json['supplier_info'] != null
        ? SupplierInfo.fromJson(json['supplier_info'])
        : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
  }
}

class Gallery {
  String? image;
  String? url;

  Gallery({this.image, this.url});

  Gallery.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['url'] = url;
    return data;
  }
}

class SupplierInfo {
  String? id;
  String? thumb;
  String? name;

  SupplierInfo({this.id, this.thumb, this.name});

  SupplierInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumb = json['thumb'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['thumb'] = thumb;
    data['name'] = name;
    return data;
  }
}

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

class Images {
  String? goodsId;
  String? image;
  String? sort;

  Images({this.goodsId, this.image, this.sort});

  Images.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    image = json['image'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['goods_id'] = goodsId;
    data['image'] = image;
    data['sort'] = sort;
    return data;
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
