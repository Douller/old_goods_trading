import 'home_goods_list_model.dart';

class GoodsDetailsModel {
  GoodsInfoModel? goodsInfo;
  List<CommentList>? commentList;
  List<GoodsInfoModel>? goodsList;
  int? isCollect;
  int? isCollectSupplier;

  GoodsDetailsModel({
    this.goodsInfo,
    this.commentList,
    this.goodsList,
    this.isCollect,
    this.isCollectSupplier,
  });

  GoodsDetailsModel.fromJson(Map<String, dynamic> json) {
    goodsInfo = json['goods_info'] != null
        ? GoodsInfoModel.fromJson(json['goods_info'])
        : null;
    if (json['comment_list'] != null) {
      commentList = <CommentList>[];
      json['comment_list'].forEach((v) {
        commentList?.add(CommentList.fromJson(v));
      });
    }
    if (json['goods_list'] != null) {
      goodsList = <GoodsInfoModel>[];
      json['goods_list'].forEach((v) {
        goodsList?.add(GoodsInfoModel.fromJson(v));
      });
    }
    isCollect = json['is_collect'];
    isCollectSupplier = json['is_collect_supplier'];
  }
}

class CommentList {
  String? id;
  String? userId;
  String? content;
  String? avatar;
  String? createTime;
  String? score;
  String? zan;
  UserInfo? userInfo;
  ReplyInfo? replyInfo;

  CommentList({
    this.id,
    this.userId,
    this.content,
    this.avatar,
    this.createTime,
    this.score,
    this.zan,
    this.userInfo,
    this.replyInfo,
  });

  CommentList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    content = json['content'];
    avatar = json['avatar'];
    createTime = json['create_time'];
    score = json['score'];
    zan = json['zan'];
    userInfo =
        json['user_info'] != null ? UserInfo.fromJson(json['user_info']) : null;
    replyInfo = json['reply_info'] != null
        ? ReplyInfo.fromJson(json['reply_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['content'] = content;
    data['avatar'] = avatar;
    data['create_time'] = createTime;
    data['score'] = score;
    data['zan'] = zan;
    if (userInfo != null) {
      data['user_info'] = userInfo?.toJson();
    }
    if (replyInfo != null) {
      data['reply_info'] = replyInfo?.toJson();
    }
    return data;
  }
}

class UserInfo {
  String? id;
  String? avatar;
  String? mobile;
  String? nickName;
  String? userName;
  String? sex;

  UserInfo(
      {this.id,
      this.avatar,
      this.mobile,
      this.nickName,
      this.userName,
      this.sex});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    mobile = json['mobile'];
    nickName = json['nick_name'];
    userName = json['user_name'];
    sex = json['sex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatar'] = avatar;
    data['mobile'] = mobile;
    data['nick_name'] = nickName;
    data['user_name'] = userName;
    data['sex'] = sex;
    return data;
  }
}

class ReplyInfo {
  String? content;
  String? createTime;
  UserInfo? userInfo;

  ReplyInfo({
    this.content,
    this.createTime,
    this.userInfo,
  });

  ReplyInfo.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    createTime = json['createTime'];
    userInfo =
        json['user_info'] != null ? UserInfo.fromJson(json['user_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['createTime'] = createTime;
    if (userInfo != null) {
      data['user_info'] = userInfo?.toJson();
    }
    return data;
  }
}
