class PayConfigModel {
  String? type;
  String? merchantNo;
  String? storeNo;
  String? token;
  String? apiGateway;
  String? apiReturnBackUrl;
  String? apipaypelReturnBackUrl;
  String? universalLinks;

  PayConfigModel(
      {this.type,
        this.merchantNo,
        this.storeNo,
        this.token,
        this.apiGateway,
        this.apiReturnBackUrl,
        this.apipaypelReturnBackUrl,
        this.universalLinks});

  PayConfigModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    merchantNo = json['merchantNo'];
    storeNo = json['storeNo'];
    token = json['token'];
    apiGateway = json['apiGateway'];
    apiReturnBackUrl = json['apiReturnBackUrl'];
    apipaypelReturnBackUrl = json['apipaypelReturnBackUrl'];
    universalLinks = json['universalLinks'];
  }
}
