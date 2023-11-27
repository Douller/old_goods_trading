import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../model/bank_model.dart';
import '../../net/service_repository.dart';
import '../../utils/toast.dart';
import '../theme_text.dart';

class PaymentListView extends StatefulWidget {
  const PaymentListView({super.key});

  @override
  State<PaymentListView> createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<PaymentListView> {
  List _paymentList = [];

  ///获取收款银行
  Future<void> _getUserPaymentList() async {
    ToastUtils.showLoading();
    List<Bank> list = await ServiceRepository.getUserPaymentList();
    setState(() {
      _paymentList = list;
    });
  }

  @override
  void initState() {
    _getUserPaymentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _paymentList.length,
            itemBuilder: (context, index) {
              return _cardCellView(
                bankName: _paymentList[index].bankUser,
                cardNum: _paymentList[index].bankAcc,
              );
            }),
      ),
    );
  }

  Widget _cardCellView({String? bankName, String? cardNum}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 24),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xffE4D719).withOpacity(0.8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ThemeText(
                text: bankName ?? '',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              )
            ],
          ),
          const SizedBox(height: 16),
          ThemeText(
            text: cardNum ?? '',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
