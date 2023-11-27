import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/states/my_after_state.dart';
import 'package:provider/provider.dart';
import '../../model/my_sell_goods_model.dart';
import '../../model/order_after_processing_model.dart';
import '../../page/mine/apply_after_sales.dart';
import '../../states/sales_after_view_model.dart';
import '../aging_degree_view.dart';
import '../goods_price_text.dart';
import '../theme_image.dart';
import '../theme_text.dart';

class MyAfterSalesCell extends StatelessWidget {
  final MySellGoodsData? model;
  final AfterProcessingModel? processingModel;
  final int? status;
  final bool isSupplier;

  const MyAfterSalesCell(
      {Key? key,
      this.model,
      this.processingModel,
      this.status,
      required this.isSupplier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          status != 2
              ? Container()
              : Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0xffF6F6F6), width: 1))),
                  padding: const EdgeInsets.only(bottom: 12),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ThemeText(
                          text: '服务单号: ${processingModel?.orderSn}',
                          color: const Color(0xff999999),
                          fontSize: 12,
                        ),
                      ),
                      //
                      Image.asset(
                        processingModel?.refundType == '1'
                            ? '${Constants.iconsPath}return_goods.png'
                            : '${Constants.iconsPath}exchange_goods.png',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 7),
                      ThemeText(
                        text: processingModel?.refundTypeName ?? '',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ThemeNetImage(
                  imageUrl: model?.goodsInfo?.thumb ??
                      processingModel?.goodsInfo?.thumbUrl,
                  height: 73,
                  width: 73,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ThemeText(
                            text: (model?.goodsInfo?.goodsName ??
                                    processingModel?.goodsInfo?.name) ??
                                '',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GoodsPriceText(
                              priceStr: (model?.goodsInfo?.totalAmount ??
                                      processingModel?.goodsInfo?.shopPrice) ??
                                  '',
                              symbolFontSize: 10,
                              textFontSize: 20,
                              symbolFontWeight: FontWeight.w500,
                              textFontWeight: FontWeight.w500,
                              color: const Color(0xff2F3033),
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
                    AgingDegreeView(
                      agingDegreeStr: (model?.goodsInfo?.brushingCondition ??
                              processingModel?.goodsInfo?.brushingCondition) ??
                          '',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (status != 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: processingModel == null
                  ? [
                      _cellBtn(
                        text: '申请售后',
                        bgColor: const Color(0xffFE734C),
                        textColor: Colors.white,
                        onTap: () {
                          if (model != null) {
                            AppRouter.push(
                                    context, ApplyAfterSales(model: model!))
                                .then((res) {
                              if (res is bool && res) {
                                Provider.of<MyAfterViewModel>(context,
                                        listen: false)
                                    .refresh();
                              }
                            });
                          }
                        },
                      )
                    ]
                  : List.generate(
                      (processingModel?.buttonList ?? []).length,
                      (index) {
                        return _cellBtn(
                          text: processingModel?.buttonList?[index].bName ?? '',
                          bgColor: (processingModel?.buttonList?[index].bType ??
                                      '') ==
                                  '1'
                              ? const Color(0xffFE734C)
                              : const Color(0xffF6F6F6),
                          textColor:
                              (processingModel?.buttonList?[index].bType ??
                                          '') ==
                                      '1'
                                  ? Colors.white
                                  : const Color(0xff666666),
                          onTap: () {
                            ///卖家
                            if (isSupplier) {
                              Provider.of<SalesAfterViewModel>(context,
                                      listen: false)
                                  .cellBtnClick(
                                context,
                                processingModel?.id,
                                processingModel?.buttonList?[index].actions,
                                processingModel?.buttonList?[index].optionTitle,
                              );
                            } else {
                              Provider.of<MyAfterViewModel>(context,
                                      listen: false)
                                  .cellBtnClick(
                                context,
                                processingModel?.id,
                                processingModel?.buttonList?[index].actions,
                                processingModel?.buttonList?[index].optionTitle,
                              );
                            }
                          },
                        );
                      },
                    ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xffF6F6F6),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  ThemeText(
                    text: processingModel?.orderStatusLabel ?? '',
                    fontSize: 12,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ThemeText(
                      text: processingModel?.statusContent ?? '',
                      color: const Color(0xff999999),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
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
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
