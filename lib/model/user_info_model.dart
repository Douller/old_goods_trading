class UserInfoModel {
  String? id;
  String? uid;
  String? avatar;
  String? mobile;
  String? nickName;
  String? userName;
  String? sorce;
  String? sex;
  String? sexLabel;
  String? remarks;
  String? birthday;
  String? email;
  String? follow;
  String? follower;
  String? commentCount;
  String? content;
  String? isCollectSupplier;
  String? money;
  String? allOrderAmount;
  String? allWithdrawAmount;
  String? afterSalesCount;
  String? collectSupplierCount;
  String? defaultAddress;
  String? defaultAddressNotice;
  UserInfoModel({
    this.id,
    this.uid,
    this.avatar,
    this.mobile,
    this.nickName,
    this.userName,
    this.email,
    this.sex,
    this.sexLabel,
    this.remarks,
    this.birthday,
    this.sorce,
    this.follow,
    this.follower,
    this.commentCount,
    this.content,
    this.isCollectSupplier,
    this.money,
    this.allOrderAmount,
    this.allWithdrawAmount,
    this.afterSalesCount,
    this.collectSupplierCount,
    this.defaultAddress,
    this.defaultAddressNotice,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    avatar = json['avatar'];
    mobile = json['mobile'];
    nickName = json['nick_name'];
    userName = json['user_name'];
    sex = json['sex'].toString();
    sexLabel = json['sex_label'];
    remarks = json['remarks'];
    birthday = json['birthday'];
    sorce = json['sorce'];
    follow = json['follow'].toString();
    follower = json['follower'].toString();
    commentCount = json['comment_count'];
    content = json['content'];
    isCollectSupplier = json['is_collect_supplier'].toString();
    money = json['money'].toString();
    allOrderAmount = json['all_order_amount'].toString();
    allWithdrawAmount = json['all_withdraw_amount'].toString();
    afterSalesCount = json['after_sales_count'].toString();
    collectSupplierCount = json['collect_supplier_count'].toString();
    email = json['email'];
    defaultAddress = json['default_address'].toString();
    defaultAddressNotice = json['default_address_notice'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['default_address_notice'] = defaultAddressNotice;
    data['avatar'] = avatar;
    data['mobile'] = mobile;
    data['nick_name'] = nickName;
    data['user_name'] = userName;
    data['sex'] = sex;
    data['sex_label'] = sexLabel;
    data['email'] = email;
    data['remarks'] = remarks;
    data['birthday'] = birthday;
    data['sorce'] = sorce;
    data['follow'] = follow;
    data['follower'] = follower;
    data['comment_count'] = commentCount;
    data['content'] = content;
    data['is_collect_supplier'] = isCollectSupplier;
    data['money'] = money;
    data['all_withdraw_amount'] = allWithdrawAmount;
    data['all_order_amount'] = allOrderAmount;
    data['after_sales_count'] = allOrderAmount;
    data['collect_supplier_count'] = collectSupplierCount;
    data['default_address'] = defaultAddress;
    return data;
  }
}
