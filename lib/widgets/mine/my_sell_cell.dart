import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../model/my_sell_goods_model.dart';
import '../../states/my_sell_state.dart';
import '../goods_price_text.dart';
import '../theme_image.dart';
import '../theme_text.dart';

class MySellCell extends StatelessWidget {
  final MySellGoodsData sellModel;

  const MySellCell({Key? key, required this.sellModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MySellViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        return Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ThemeNetImage(
                      imageUrl: sellModel.supplierInfo?.thumb,
                      placeholderPath:
                          "${Constants.placeholderPath}user_placeholder.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ThemeText(
                    text: sellModel.supplierInfo?.name ?? '',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  Expanded(child: Container()),
                  ThemeText(
                    text: sellModel.orderStatusLabel ?? '',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffFE734C),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ThemeNetImage(
                      imageUrl: sellModel.goodsInfo?.thumb,
                      height: 73,
                      width: 73,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 73,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ThemeText(
                            text: sellModel.goodsInfo?.goodsName ?? '',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(child: Container()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GoodsPriceText(
                                priceStr:
                                    sellModel.goodsInfo?.totalAmount ?? '',
                                symbolFontSize: 12,
                                textFontSize: 19,
                                symbolFontWeight: FontWeight.w500,
                                textFontWeight: FontWeight.w500,
                              ),
                              // AgingDegreeView(
                              //   agingDegreeStr: '9成新',
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(
                  (sellModel.buttonList ?? []).length,
                  (index) {
                    return _cellBtn(
                      text: sellModel.buttonList?[index].bName ?? '',
                      bgColor: (sellModel.buttonList?[index].bType ?? '') == '1'
                          ? const Color(0xffFE734C)
                          : const Color(0xffF6F6F6),
                      textColor:
                          (sellModel.buttonList?[index].bType ?? '') == '1'
                              ? Colors.white
                              : const Color(0xff666666),
                      onTap: () {
                        if ((sellModel.buttonList?[index].bName ?? '') !=
                            '支付') {
                          value.cellBtnClick(
                            context,
                            sellModel.id,
                            sellModel.buttonList?[index].actions,
                            sellModel.buttonList?[index].optionTitle,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _cellBtn({
    required String text,
    required Color bgColor,
    required Color textColor,
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 80,
        margin: const EdgeInsets.only(left: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text == '支付'
              ? '立即支付'
              : text == '取消'
                  ? '取消订单'
                  : text,
          style: TextStyle(
            color: textColor,
            fontWeight: text == '支付' ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
