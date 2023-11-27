class BankModel {
  List<Bank>? bank;

  BankModel({this.bank});

  BankModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      bank = <Bank>[];
      json['list'].forEach((v) {
        bank?.add(Bank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bank != null) {
      data['bank'] = bank?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bank {
  String? id;
  String? name;
  String? bankImg;
  String? bankUser;
  String? bankAcc;
  String? bankName;

  Bank({
    this.id,
    this.name,
    this.bankImg,
    this.bankAcc,
    this.bankName,
    this.bankUser,
  });

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    bankImg = json['bank_img'];
    bankAcc = json['bank_acc'];
    bankUser = json['bank_user'];
    bankName = json['bank_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['bank_img'] = bankImg;
    data['bank_acc'] = bankAcc;
    data['bank_user'] = bankUser;
    data['bank_name'] = bankName;
    return data;
  }
}
