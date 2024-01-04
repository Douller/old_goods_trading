import 'package:flutter/material.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/states/goods_details_state.dart';
import 'package:old_goods_trading/widgets/goods_price_text.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../page/mine/seller_personal_center.dart';
import '../aging_degree_view.dart';
import '../goods_star_view.dart';
import '../theme_text.dart';

class HomeGoodsCell extends StatelessWidget {
  final int index;
  final List goodsList;
  final bool isSupplier; //是否从卖家中心点击 默认false 不是
  final int tabBarIndex; //推荐0  附近1；


  const HomeGoodsCell({
    Key? key,
    required this.index,
    required this.goodsList,
    this.isSupplier = false,
    required this.tabBarIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xffE4D719).withOpacity(0.8),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ThemeNetImage(
                    imageUrl: goodsList[index].thumbUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              goodsList[index].status == '2'
                  ? Container(
                      margin: const EdgeInsets.only(right: 8, top: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ThemeText(
                        text: goodsList[index].statusName ?? '',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff2F3033).withOpacity(0.7),
                      ),
                    )
                  : Container(),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(11, 8, 6, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GoodsPriceText(
                        priceStr: goodsList[index].shopPrice ?? '',
                        symbolFontSize: 16,
                        textFontSize: 16,
                        symbolFontWeight: FontWeight.w500,
                        textFontWeight: FontWeight.w500,
                      ),
                    ),
                    /*tabBarIndex == 1
                        ? ThemeText(
                            text: goodsList[index].distance ?? '',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          )
                        : GoodsStarView(
                            starIcon: Constants.getStarIcon(
                                num.parse(goodsList[index].score ?? '0')),
                            starStr: goodsList[index].score ?? '0',
                            width: 12,
                            height: 12,
                            fontSize: 14,
                          ),*/
                  ],
                ),
                const SizedBox(height: 3),
                ThemeText(
                  text: goodsList[index].name ?? '',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Image.asset(
                      '${Constants.iconsPath}publish_time.png',
                      width: 12,
                      height: 12,
                    ),
                    const SizedBox(width: 3),
                    ThemeText(
                      text: goodsList[index].publishTime ?? '',
                      fontSize: 8,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xff81C0C3),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (!isSupplier) {
                      AppRouter.push(
                        context,
                        SellerPersonalCenter(
                          supplierId: goodsList[index].supplierInfo?.id,
                        ),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: ThemeNetImage(
                              imageUrl: goodsList[index].supplierInfo?.thumb,
                              placeholderPath:
                              "${Constants.placeholderPath}user_placeholder.png",
                              width: 16,
                              height: 16,
                            ),
                          ),
                          const SizedBox(width: 3),
                          ThemeText(
                            text: goodsList[index].supplierInfo?.name ?? '',
                            fontSize: 8,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff696D84),
                          ),
                          const SizedBox(width: 3),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ThemeText(
                            text: goodsList[index].state ?? '',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff000000),
                          ),
                        ],
                      )
                    ],
                  )
                ),
                // SizedBox(
                //   height: 42,
                //   child: ThemeText(
                //     text: goodsList[index].name ?? '',
                //     fontSize: 14,
                //     fontWeight: FontWeight.w700,
                //     maxLines: 2,
                //     overflow: TextOverflow.clip,
                //   ),
                // ),
                // const SizedBox(height: 7),
                // Row(
                //   children: [
                //     Expanded(
                //       child: GoodsPriceText(
                //         priceStr: goodsList[index].shopPrice ?? '',
                //         symbolFontSize: 12,
                //         textFontSize: 19,
                //         symbolFontWeight: FontWeight.w500,
                //         textFontWeight: FontWeight.w700,
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     AgingDegreeView(
                //       agingDegreeStr: goodsList[index].brushingCondition ?? '',
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 7),
                // GestureDetector(
                //   behavior: HitTestBehavior.opaque,
                //   onTap: () {
                //     if (!isSupplier) {
                //       AppRouter.push(
                //         context,
                //         SellerPersonalCenter(
                //           supplierId: goodsList[index].supplierInfo?.id,
                //         ),
                //       );
                //     }
                //   },
                //   child: Row(
                //     children: [
                //       ClipRRect(
                //         borderRadius: BorderRadius.circular(20),
                //         child: ThemeNetImage(
                //           imageUrl: goodsList[index].supplierInfo?.thumb,
                //           placeholderPath:
                //               "${Constants.placeholderPath}user_placeholder.png",
                //           width: 20,
                //           height: 20,
                //         ),
                //       ),
                //       const SizedBox(width: 8),
                //       ThemeText(
                //         text: goodsList[index].supplierInfo?.name ?? '',
                //         fontSize: 10,
                //         fontWeight: FontWeight.w500,
                //       ),
                //       Expanded(child: Container()),
                //       tabBarIndex == 1
                //           ? ThemeText(
                //               text: goodsList[index].distance ?? '',
                //               fontSize: 12,
                //               fontWeight: FontWeight.w500,
                //             )
                //           : GoodsStarView(
                //               starIcon: Constants.getStarIcon(
                //                   num.parse(goodsList[index].score ?? '0')),
                //               starStr: goodsList[index].score ?? '0',
                //               width: 12,
                //               height: 12,
                //               fontSize: 14,
                //             ),
                //     ],
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}

//渲染的太慢