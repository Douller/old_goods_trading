import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import '../../model/my_sell_goods_model.dart';
import '../../states/my_order_state.dart';
import '../aging_degree_view.dart';
import '../goods_price_text.dart';
import '../theme_image.dart';

class MyOrderListViewCell extends StatelessWidget {
  final MySellGoodsData model;

  const MyOrderListViewCell({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MyOrderViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        return Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  ThemeText(
                    text: '订单号：${model.orderSn}',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  Expanded(child: Container()),
                  ThemeText(
                    text: model.orderStatusLabel ?? '',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xffFE734C),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ThemeNetImage(
                      imageUrl: model.goodsInfo?.thumb,
                      height: 73,
                      width: 73,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 73,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ThemeText(
                                  text: model.goodsInfo?.goodsName ?? '',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(child: Container()),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GoodsPriceText(
                                    priceStr:
                                        model.goodsInfo?.totalAmount ?? '',
                                    symbolFontSize: 10,
                                    textFontSize: 20,
                                    symbolFontWeight: FontWeight.w500,
                                    textFontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(height: 4),
                                  const ThemeText(
                                    text: 'x1',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xff999999),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              AgingDegreeView(
                                agingDegreeStr:
                                    model.goodsInfo?.brushingCondition ?? '',
                              ),
                              Expanded(child: Container()),
                              ThemeText(
                                text: '共1件商品，实付：\$${model.totalAmount ?? ''}',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:
                    List.generate((model.buttonList ?? []).length, (index) {
                  return _cellBtn(
                      text: model.buttonList?[index].bName ?? '',
                      bgColor: (model.buttonList?[index].bType ?? '') == '1'
                          ? const Color(0xffFE734C)
                          : const Color(0xffF6F6F6),
                      textColor: (model.buttonList?[index].bType ?? '') == '1'
                          ? Colors.white
                          : const Color(0xff666666),
                      onTap: () {
                        value.cellBtnClick(
                          context,
                          model.buttonList?[index].bName ?? '',
                          model.id,
                          model.buttonList?[index].actions,
                          model,
                          model.buttonList?[index].optionTitle,
                        );
                      });
                }),
              )
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
