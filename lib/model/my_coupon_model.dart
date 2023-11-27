class MyCouponModel {
  String? id;
  String? name;
  String? descpotion;
  String? userId;
  String? value;
  String? bindValue;
  String? useStatus;
  String? useBeginTime;
  String? useEndTime;
  String? isSupplier;

  MyCouponModel(
      {this.name,
        this.id,
        this.descpotion,
        this.userId,
        this.value,
        this.bindValue,
        this.useStatus,
        this.useBeginTime,
        this.useEndTime,
        this.isSupplier,
      });

  MyCouponModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    userId = json['user_id'];
    descpotion = json['descpotion'];
    bindValue = json['bind_value'];
    value = json['value'];
    useStatus = json['useStatus'];
    useBeginTime = json['useBeginTime'];
    useEndTime = json['useEndTime'];
    isSupplier = json['isSupplier'];
  }

}
