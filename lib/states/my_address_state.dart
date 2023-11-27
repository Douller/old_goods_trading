import 'package:flutter/cupertino.dart';
import 'package:old_goods_trading/utils/sp_manager.dart';
import 'package:old_goods_trading/utils/toast.dart';

import '../constants/constants.dart';
import '../model/my_address_model.dart';
import '../model/order_buy_confirm_model.dart';
import '../net/service_repository.dart';

class MyAddressViewModel extends ChangeNotifier {
  //数据列表
  List<AddressModelInfo> addressList = [];

  Future<void> deleteAddress(String addressIds) async {
    ToastUtils.showLoading();
    bool result = await ServiceRepository.deleteAddress(addressId: addressIds);

    if (result) {
      getMyAddressList();
    }
  }

  Future<void> getMyAddressList() async {
    ToastUtils.showLoading();
    MyAddressModel? model = await ServiceRepository.getUserAddress();

    if (model != null) {
      addressList = model.data ?? [];

      if (addressList.isNotEmpty) {
        AddressModelInfo modelInfo = addressList.first;
        for (AddressModelInfo element in addressList) {
          if (element.isDefault == '1') {
            modelInfo = element;
          }
        }
      }
    }
    ToastUtils.hiddenAllToast();
    notifyListeners();
  }

  Future<void> setDefaultAddress(AddressModelInfo model) async {
    ToastUtils.showLoading();
    String addressId =
        await ServiceRepository.setDefaultAddAddress(id: model.id);
    if (addressId.isNotEmpty) {
      getMyAddressList();
    }
  }
}
