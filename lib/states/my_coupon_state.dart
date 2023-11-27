import 'package:flutter/foundation.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';

import '../model/my_coupon_model.dart';

class MyCouponViewModel with ChangeNotifier {
  String _status = '0';

  List<MyCouponModel> _modelList = [];

  List<MyCouponModel> get modelList => _modelList;

  void changeTabStatus(int index) {
    if (index == 0) {
      _status = '0';
    } else if (index == 1) {
      _status = '1';
    } else {
      _status = '9';
    }
    getMyCouponListData();
  }

  Future<void> getMyCouponListData() async {
    ToastUtils.showLoading();
    _modelList = await ServiceRepository.getCouponList(status: _status);
    notifyListeners();
  }
}
