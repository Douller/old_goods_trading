import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/home_goods_list_model.dart';
import '../../page/add/add_page.dart';
import '../../router/app_router.dart';
import '../../states/my_publish_state.dart';
import '../aging_degree_view.dart';
import '../goods_price_text.dart';
import '../theme_image.dart';
import '../theme_text.dart';

class MyPublishCell extends StatelessWidget {
  final GoodsInfoModel model;

  const MyPublishCell({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ThemeNetImage(
                  imageUrl: model.thumbUrl,
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
                      ThemeText(
                        text: model.name ?? '',
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
                            priceStr: model.shopPrice ?? '',
                            symbolFontSize: 12,
                            textFontSize: 19,
                            symbolFontWeight: FontWeight.w500,
                            textFontWeight: FontWeight.w500,
                          ),
                          AgingDegreeView(
                            agingDegreeStr: model.tags ?? '',
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
          Consumer<MyPublishViewModel>(
              builder: (BuildContext context, value, Widget? child) {
            return model.status == '1'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _cellBtn(
                        text: '下架',
                        onTap: () => value.pulledGoods(model.id ?? ''),
                      ),
                      _cellBtn(
                        text: '编辑',
                        onTap: () => AppRouter.push(
                            context, AddPage(publishModel: model)),
                      ),
                    ],
                  )
                : model.status == '0'
                    ? _cellBtn(
                        text: '重新上架',
                        onTap: () => value.publishOnSale(model.id ?? ''),
                      )
                    : _cellBtn(
                        text: '编辑',
                        onTap: () => AppRouter.push(
                            context, AddPage(publishModel: model)),
                      );
          }),
        ],
      ),
    );
  }

  Widget _cellBtn({required String text, GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 80,
        margin: const EdgeInsets.only(left: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xffCECECE))),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xff2F3033),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
