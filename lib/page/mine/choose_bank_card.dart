import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

import '../../constants/constants.dart';
import '../../model/bank_model.dart';
import '../../net/service_repository.dart';
import '../../router/app_router.dart';
import '../../utils/toast.dart';
import 'add_band_card_page.dart';

class ChooseBankCard extends StatefulWidget {
  const ChooseBankCard({Key? key}) : super(key: key);

  @override
  State<ChooseBankCard> createState() => _ChooseBankCardState();
}

class _ChooseBankCardState extends State<ChooseBankCard> {
  List<Bank> _bankCardList = [];

  ///获取银行卡列表
  Future<void> _getUserBankCardList() async {
    ToastUtils.showLoading();
    List<Bank> list = await ServiceRepository.getUserBankList();
    setState(() {
      _bankCardList = list;
    });
  }

  @override
  void initState() {
    _getUserBankCardList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        title: const ThemeText(text: '选择银行卡'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_bankCardList.isEmpty)
                Container()
              else
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _bankCardList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: _cardCellView(
                          // icon: _bankCardList[index].bankImg,
                          bankName: _bankCardList[index].bankUser,
                          cardNum: _bankCardList[index].bankAcc,
                        ),
                      );
                    }),
              const SizedBox(height: 16),
              _addCardView(),
            ],
          ),
        ),
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
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(30),
              //   child: ThemeNetImage(
              //     imageUrl: icon,
              //     width: 24,
              //     height: 24,
              //     placeholderPath: '${Constants.iconsPath}add_card.png',
              //   ),
              // ),
              // const SizedBox(width: 10),
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

  Widget _addCardView() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        AppRouter.push(context, const AddBandCardPage()).then((value) {
          _getUserBankCardList();
        });
      },
      child: Row(
        children: [
          Image.asset(
            '${Constants.iconsPath}icon _add_circle.png',
            width: 30,
            height: 30,
          ),
          const ThemeText(text: '添加银行卡'),
        ],
      ),
    );
  }
}
