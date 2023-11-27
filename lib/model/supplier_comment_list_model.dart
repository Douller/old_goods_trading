import 'goods_details_model.dart';

class SupplierCommentListModel {
  List<Types>? types;
  List<CommentList>? data;
  String? systemId;
  int? returnCode;
  String? returnInfo;

  SupplierCommentListModel(
      {this.types, this.data, this.systemId, this.returnCode, this.returnInfo});

  SupplierCommentListModel.fromJson(Map<String, dynamic> json) {
    if (json['types'] != null) {
      types = <Types>[];
      json['types'].forEach((v) {
        types?.add(Types.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <CommentList>[];
      json['data'].forEach((v) {
        data?.add(CommentList.fromJson(v));
      });
    }
    systemId = json['system_id'];
    returnCode = json['return_code'];
    returnInfo = json['return_info'];
  }
}

class Types {
  int? id;
  String? name;
  String? num;

  Types({this.id, this.name, this.num});

  Types.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    num = json['num'];
  }
}

class Data {
  String? id;
  String? userId;
  String? content;
  String? avatar;
  String? createTime;
  String? score;
  String? zan;
  UserInfo? userInfo;
  ReplyInfo? replyInfo;

  Data(
      {this.id,
        this.userId,
        this.content,
        this.avatar,
        this.createTime,
        this.score,
        this.zan,
        this.userInfo,
        this.replyInfo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    content = json['content'];
    avatar = json['avatar'];
    createTime = json['create_time'];
    score = json['score'];
    zan = json['zan'];
    userInfo = json['user_info'] != null
        ? UserInfo.fromJson(json['user_info'])
        : null;
    replyInfo = json['reply_info'] != null
        ? ReplyInfo.fromJson(json['reply_info'])
        : null;
  }
}

class UserInfo {
  String? id;
  String? uid;
  String? avatar;
  String? mobile;
  String? nickName;
  String? userName;
  String? sex;
  String? sexLabel;
  String? remarks;
  String? birthday;

  UserInfo(
      {this.id,
        this.uid,
        this.avatar,
        this.mobile,
        this.nickName,
        this.userName,
        this.sex,
        this.sexLabel,
        this.remarks,
        this.birthday});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    avatar = json['avatar'];
    mobile = json['mobile'];
    nickName = json['nick_name'];
    userName = json['user_name'];
    sex = json['sex'];
    sexLabel = json['sex_label'];
    remarks = json['remarks'];
    birthday = json['birthday'];
  }
}

class ReplyInfo {
  String? content;
  String? createTime;
  UserInfo? userInfo;

  ReplyInfo({this.content, this.createTime, this.userInfo});

  ReplyInfo.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    createTime = json['create_time'];
    userInfo = json['user_info'] != null
        ? UserInfo.fromJson(json['user_info'])
        : null;
  }
}
