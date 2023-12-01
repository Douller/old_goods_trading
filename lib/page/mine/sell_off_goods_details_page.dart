import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

import '../../constants/constants.dart';
import '../../model/home_goods_list_model.dart';
import '../../router/app_router.dart';
import '../../widgets/aging_degree_view.dart';
import '../../widgets/back_button.dart';
import '../../widgets/goods_price_text.dart';
import '../../widgets/goods_star_view.dart';
import '../../widgets/home_widgets/goods_details_app_bar.dart';
import '../../widgets/theme_image.dart';
import '../../widgets/theme_text.dart';
import '../home/picture_preview.dart';

class SellOffGoodsDetailsPage extends StatefulWidget {
  final GoodsInfoModel model;

  const SellOffGoodsDetailsPage({Key? key, required this.model})
      : super(key: key);

  @override
  State<SellOffGoodsDetailsPage> createState() =>
      _SellOffGoodsDetailsPageState();
}

class _SellOffGoodsDetailsPageState extends State<SellOffGoodsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6), // const Color(0xffF9F9F9),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const BackArrowButton(),
                  const SizedBox(width: 11),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: ThemeNetImage(
                          imageUrl: widget.model.supplierInfo?.thumb,
                          placeholderPath:
                              "${Constants.placeholderPath}user_placeholder.png",
                          width: 34,
                          height: 34,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ThemeText(
                        text: widget.model.supplierInfo?.name ?? '',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ],
                  ),
                  /*const SizedBox(width: 13),
                  GoodsStarView(
                    starStr: widget.model.score ?? '0',
                    width: 14,
                    height: 14,
                    space: 6,
                    fontSize: 16,
                    starIcon: Constants.getStarIcon(
                        num.parse(widget.model.score ?? '0')),
                  ),*/
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _goodsDetailsView(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 80 + Constants.bottomPadding,
        child: Column(
          children: [
            Container(
              height: 30,
              alignment: Alignment.center,
              color: const Color(0xFF666666),
              child: const ThemeText(
                text: '该商品已售出',
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 12, right: 18),
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: const Color(0xffCECECE),
                ),
                height: 34,
                width: 85,
                alignment: Alignment.center,
                child: const ThemeText(
                  text: '已售出',
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _goodsDetailsView() {
    return Column(
      children: [
        _swiperView(),
        Container(
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 25),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: ThemeText(
                  text: widget.model.name ?? '',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  GoodsPriceText(
                    priceStr: widget.model.shopPrice ?? '',
                    textFontWeight: FontWeight.w700,
                    textFontSize: 32,
                    symbolFontWeight: FontWeight.w500,
                    symbolFontSize: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$${widget.model.marketPrice ?? ''}',
                    style: const TextStyle(
                        color: Color(0xffCECECE),
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  ThemeText(
                    text: widget.model.deliveryType ?? '',
                    color: const Color(0xffCECECE),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  Expanded(child: Container()),
                  AgingDegreeView(
                    agingDegreeStr: widget.model.brushingCondition ?? "",
                    width: 55,
                    height: 26,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFEEEEEE)),
              const SizedBox(height: 12),
              ThemeText(
                text: widget.model.brief ?? "",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )
            ],
          ),
        )
      ],
    );
  }

  ///轮播图
  Widget _swiperView() {
    return (widget.model.gallery ?? []).isEmpty
        ? Container()
        : SizedBox(
            height: 300,
            child: Swiper(
              itemCount: (widget.model.gallery ?? []).length,
              autoplay: true,
              duration: 500,
              itemBuilder: (context, index) {
                return ThemeNetImage(
                  imageUrl: widget.model.gallery?[index].url,
                  fit: BoxFit.cover,
                );
              },
              pagination: const SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                  size: 3,
                  activeSize: 10,
                  activeColor: Colors.white,
                ),
              ),
            ),
          );
  }
}
