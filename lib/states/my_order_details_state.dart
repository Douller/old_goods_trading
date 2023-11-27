import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import '../model/cancel_order_reason.dart';
import '../model/my_sell_goods_model.dart';
import '../model/order_create_model.dart';
import '../page/mine/appraise_page.dart';
import '../router/app_router.dart';
import '../utils/timer_util.dart';
import '../widgets/bottom_sheet/cancel_reason_sheet_view.dart';
import '../widgets/bottom_sheet/pay_sheet.dart';

class MyOrderDetailsViewModel with ChangeNotifier {
  MySellGoodsData? _model;

  MySellGoodsData? get model => _model;

  TimerUtil? _timer;
  int _countDown = 0;

  String? _countDownString;

  String? get countDownString => _countDownString;

  set countDownString(String? countdown) {
    _countDownString = countdown;
    notifyListeners();
  }

  Future<void> getMyOrderDetails(BuildContext context, String orderId) async {
    ToastUtils.showLoading();
    _model = await ServiceRepository.getMyOrderDetails(orderId: orderId);
    _countDown = _model?.lastPayTime ?? 0;
    if (_countDown > 0) {
      initTimer(context);
    }
    notifyListeners();
  }

  Future<void> cellBtnClick(
      BuildContext context, String bName, String actions) async {
    if (actions == 'pay/pay') {
      _paySheetView(context);
    } else if (actions.contains('cancelReason')) {
      CancelOrderReasonModel? reasonModel =
          await ServiceRepository.cancelMyOrderReason();
      if (reasonModel != null) {
        _cancelOrderSheetView(context, reasonModel);
      }
    } else if (actions == 'comment/add') {
      AppRouter.push(
          context,
          AppraisePage(
            orderId: model?.id ?? '',
            isSupplier: false,
          )).then((value) async {
        getMyOrderDetails(context, model?.id ?? '');
      });
    } else {
      if ((model?.id ?? '').isEmpty || (actions).isEmpty) return;
      ToastUtils.showLoading();
      await ServiceRepository.cellBtnClick(
          orderId: model?.id ?? '', actions: actions);
    }
  }

  ///支付
  Future<void> _paySheetView(BuildContext context) async {
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
          return PayBottomSheet(
            totalAmount: model!.totalAmount.toString(),
            orderSN: model!.orderSn.toString(),
            description: model!.goodsInfo?.goodsName ?? '', orderId: model!.id.toString(),
          );
        }).then((value) async {
      // if (value != null && value >= 0) {
      //   OrderCreateModel? result = await ServiceRepository.getPayInfo(
      //     orderId: model?.id ?? '',
      //     type: value.toString(),
      //   );
      //   if (result != null) {
      //     Future.delayed(const Duration(seconds: 1), () {
      //       Navigator.pop(context);
      //     });
      //   }
      // }
    });
  }

  void _cancelOrderSheetView(
      BuildContext context, CancelOrderReasonModel reasonModel) {
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
          return CancelReasonSheetView(
            reasonModel: reasonModel,
            orderId: model?.id ?? '',
          );
        }).then((value) async {
      if (value is bool && value == true) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pop(context);
        });
      }
    });
  }

  void initTimer(BuildContext context) {
    if (_timer == null) {
      _timer = TimerUtil(mInterval: 1000);
      _timer?.setOnTimerTickCallback((millisUntilFinished) async {
        _countDown--;
        countDownString = getCountdownStr();
        if (_countDown <= 0) {
          _timer?.cancel();
          Navigator.pop(context);
        }
      });
    }
    if (_timer?.isActive() == false) {
      _timer?.startTimer();
    }
  }

  String getCountdownStr() {
    int second = (_countDown % 60).toInt(); //秒
    int minutes = (_countDown / 60 % 60).toInt(); //分钟的。
    int hour = (_countDown / 60 / 60 % 24).toInt(); //小时

    String secondString = second.toString();
    String minutesString = minutes.toString();
    String hourString = hour.toString();

    if (second < 10) {
      secondString = '0$second';
    }
    if (minutes < 10) {
      minutesString = '0$minutesString';
    }
    if (hour < 10) {
      hourString = '0$hourString';
    }

    String timeStr = '$minutesString分$secondString秒';
    return timeStr;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
