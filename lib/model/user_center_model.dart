class UserCenterModel {
  String? id;
  String? avatar;
  String? mobile;
  String? nickName;
  String? userName;
  String? sex;
  String? sexLabel;
  String? remarks;
  String? collectCount;
  String? historyCount;
  String? couponCount;
  String? bussinessCount;
  String? orderUnpay;
  String? orderUndeliver;
  String? orderUnreceipt;
  String? orderUncomment;
  String? orderAfterSales;
  String? sellerOrderCount;
  String? sellerGoodsCount;
  String? afterSalesCount;
  String? money;
  String? collectSupplierCount;

  UserCenterModel({
    this.id,
    this.avatar,
    this.mobile,
    this.nickName,
    this.userName,
    this.sex,
    this.sexLabel,
    this.remarks,
    this.collectCount,
    this.historyCount,
    this.couponCount,
    this.bussinessCount,
    this.orderUnpay,
    this.orderUndeliver,
    this.orderUnreceipt,
    this.orderUncomment,
    this.orderAfterSales,
    this.sellerOrderCount,
    this.sellerGoodsCount,
    this.afterSalesCount,
    this.money,
    this.collectSupplierCount,
  });

  UserCenterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    mobile = json['mobile'];
    nickName = json['nick_name'];
    userName = json['user_name'];
    sex = json['sex'];
    sexLabel = json['sex_label'];
    remarks = json['remarks'];
    collectCount = json['collect_count'];
    historyCount = json['history_count'];
    couponCount = json['coupon_count'];
    bussinessCount = json['bussiness_count'];
    orderUnpay = json['order_unpay'];
    orderUndeliver = json['order_undeliver'];
    orderUnreceipt = json['order_unreceipt'];
    orderUncomment = json['order_uncomment'];
    orderAfterSales = json['order_after_sales'];
    sellerOrderCount = json['seller_order_count'];
    sellerGoodsCount = json['seller_goods_count'];
    afterSalesCount = json['after_sales_count'].toString();
    money = json['money'].toString();
    collectSupplierCount = json['collect_supplier_count'];
  }
}
