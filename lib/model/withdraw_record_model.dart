class WithdrawRecordModel {
  String? id;
  String? title;
  String? money;
  String? content;
  String? statusName;
  String? createTime;
  String? status;
  String? amount;
  String? changeAmount;
  String? changeType;
  String? image;
  List<ButtonList>? buttonList;

  WithdrawRecordModel(
      {this.id,
        this.title,
        this.money,
        this.content,
        this.statusName,
        this.createTime,
        this.status,
        this.amount,
        this.changeAmount,
        this.changeType,
        this.image,
        this.buttonList,});

  WithdrawRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    money = json['money'];
    content = json['content'];
    statusName = json['status_name'];
    createTime = json['create_time'];
    status = json['status'];
    amount = json['amount'];
    changeAmount = json['change_amount'];
    changeType = json['change_type'];
    image = json['image'];
    if (json['buttonList'] != null) {
      buttonList =  <ButtonList>[];
      json['buttonList'].forEach((v) {
        buttonList?.add( ButtonList.fromJson(v));
      });
    }
  }
}

class ButtonList {
  String? bType;
  String? bName;

  ButtonList({this.bType, this.bName});

  ButtonList.fromJson(Map<String, dynamic> json) {
    bType = json['bType'];
    bName = json['bName'];
  }
}