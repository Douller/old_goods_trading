import 'package:flutter/material.dart';
import 'package:old_goods_trading/model/bank_model.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import '../model/user_info_model.dart';
import '../page/mine/add_band_card_page.dart';
import '../router/app_router.dart';
import '../widgets/bottom_sheet/choose_card_sheet.dart';

class WithdrawViewModel extends ChangeNotifier {
  List<Bank> _bankCardList = [];

  List<Bank> get bankCardList => _bankCardList;

  String _withdrawAmount = '0.0';

  String get withdrawAmount => _withdrawAmount;

  final TextEditingController _withdrawTF = TextEditingController();

  TextEditingController get withdrawTF => _withdrawTF;

  Future<void> initData() async {
    await _getUserBankCardList();
    await _getWithdrawAmount();
  }

  ///提现
  Future<void> withdrawBtnClick() async {
    num? amount = num.tryParse(_withdrawTF.text);
    if ((amount ?? 0) <= 0) {
      ToastUtils.showText(text: "请输入正确的金额");
      return;
    }
    if ((amount ?? 0) > num.parse(_withdrawAmount)) {
      ToastUtils.showText(text: "余额不足");
      return;
    }

    if (_bankCardList.isEmpty || (_bankCardList.first.id ?? '').isEmpty) {
      ToastUtils.showText(text: "请选择银行卡");
      return;
    }

    bool res = await ServiceRepository.withdraw(
        bandId: _bankCardList.first.id ?? '', amount: _withdrawTF.text);
    if (res) {
      _withdrawTF.clear();
      _getWithdrawAmount();
    }
  }

  ///全部提现按钮
  Future<void> allAmountBtnClick() async {
    _withdrawTF.text = _withdrawAmount;
    notifyListeners();
  }

  ///获取银行卡列表
  Future<void> _getUserBankCardList() async {
    ToastUtils.showLoading();
    _bankCardList = await ServiceRepository.getUserBankList();
    notifyListeners();
  }

  ///获取提现金额
  Future<void> _getWithdrawAmount() async {
    UserInfoModel? model = await ServiceRepository.getWithdrawAmount();
    if (model != null && (model.money ?? '').isNotEmpty) {
      _withdrawAmount = model.money!;
      notifyListeners();
    }
  }

  ///弹出银行卡选择框
  Future<void> chooseBandCardView(BuildContext context) async {
    if (_bankCardList.isNotEmpty) {
      showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return ChooseCardSheet(
              bankCardList: _bankCardList,
            );
          }).then((value) {
        _getUserBankCardList();
      });
    } else {
      AppRouter.push(context, const AddBandCardPage()).then((value) {
        _getUserBankCardList();
      });
    }
  }
}
