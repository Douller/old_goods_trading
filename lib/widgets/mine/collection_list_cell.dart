import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../model/home_goods_list_model.dart';
import '../../page/home/goods_details_page.dart';
import '../../router/app_router.dart';
import '../../states/my_collection_state.dart';
import '../aging_degree_view.dart';
import '../goods_price_text.dart';
//import '../goods_star_view.dart';
import '../theme_image.dart';
import '../theme_text.dart';

class CollectionListCell extends StatelessWidget {
  final GoodsInfoModel model;

  const CollectionListCell({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MyCollectionViewModel>(
        builder: (BuildContext context, value, Widget? child) {
      return GestureDetector(
        onTap: () =>  value.isEdit?value.itemClick(model): AppRouter.push(context, GoodsDetailsPage(
            goodsId: model.id ?? '')),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              value.isEdit
                  ? IconButton(
                      onPressed: () => value.itemClick(model),
                      icon: Icon(
                        value.chooseList.contains(model)
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: value.chooseList.contains(model)
                            ? const Color(0xffFE734C)
                            : const Color(0xff999999),
                        size: 20,
                      ),
                    )
                  : Container(),
              Container(
                width: Constants.screenWidth - 24,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 12, right: 12, left: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ThemeNetImage(
                        imageUrl: model.thumbUrl,
                        height: 114,
                        width: 114,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 36,
                            child: ThemeText(
                              text: model.name ?? '',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          const SizedBox(height: 3),
                          AgingDegreeView(
                            width: model.tags == null ? 0 : 50,
                            agingDegreeStr: model.tags ?? '',
                          ),
                          const SizedBox(height: 6),
                          GoodsPriceText(
                            priceStr: model.shopPrice ?? '',
                            symbolFontSize: 12,
                            textFontSize: 19,
                            symbolFontWeight: FontWeight.w500,
                            textFontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ThemeNetImage(
                                  imageUrl: model.supplierInfo?.thumb,
                                  placeholderPath:
                                      "${Constants.placeholderPath}user_placeholder.png",
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ThemeText(
                                text: model.supplierInfo?.name ?? '',
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                              /*Expanded(child: Container()),
                              GoodsStarView(
                                starIcon: Constants.getStarIcon(
                                    num.parse(model.score ?? '0')),
                                starStr: model.score ?? '0',
                                width: 12,
                                height: 12,
                                fontSize: 14,
                              ),*/
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
