import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:old_goods_trading/page/add/add_page.dart';
import 'package:old_goods_trading/router/app_router.dart';
import '../../model/home_goods_list_model.dart';
import '../../net/service_repository.dart';
import '../../utils/toast.dart';
import '../../widgets/aging_degree_view.dart';
import '../../widgets/goods_price_text.dart';
import '../../widgets/theme_image.dart';
import '../../widgets/theme_text.dart';

class PublishGoodsDetails extends StatefulWidget {
  final GoodsInfoModel publishModel;

  const PublishGoodsDetails({Key? key, required this.publishModel})
      : super(key: key);

  @override
  State<PublishGoodsDetails> createState() => _PublishGoodsDetailsState();
}

class _PublishGoodsDetailsState extends State<PublishGoodsDetails> {
  List<String> _bottomBtnTitleList = [];

  ///下架
  Future<void> _pulledGoods() async {
    ToastUtils.showLoading();
    bool res = await ServiceRepository.publishOffSale(
        goodsId: widget.publishModel.id ?? '');

    if (res) {
      ToastUtils.showText(text: '下架成功');
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context, true);
      });
    }
  }

  ///重新上架
  Future<void> _publishOnSale() async {
    ToastUtils.showLoading();
    bool res = await ServiceRepository.publishOnSale(
        goodsId: widget.publishModel.id ?? '');
    if (res) {
      ToastUtils.showText(text: '重新上架成功');
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context, true);
      });
    }
  }

  @override
  void initState() {
    if (widget.publishModel.status == '0') {
      _bottomBtnTitleList = ['重新上架'];
    } else if (widget.publishModel.status == '2') {
      _bottomBtnTitleList = ['编辑'];
    } else {
      _bottomBtnTitleList = ['下架', '编辑'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('商品详情'),
      ),
      body: SingleChildScrollView(
        child: _goodsDetailsView(),
      ),
      bottomNavigationBar: _bottomBtn(), // const Color(0xffF9F9F9),
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
                  text: widget.publishModel.name ?? '',
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
                    priceStr: widget.publishModel.shopPrice ?? '0',
                    textFontWeight: FontWeight.w700,
                    textFontSize: 32,
                    symbolFontWeight: FontWeight.w500,
                    symbolFontSize: 16,
                  ),
                  const SizedBox(width: 20),
                  AgingDegreeView(
                    agingDegreeStr: widget.publishModel.tags ?? '',
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
                text: widget.publishModel.brief ?? '',
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
    return (widget.publishModel.gallery ?? []).isEmpty
        ? Container()
        : SizedBox(
            height: 300,
            child: Swiper(
              itemCount: (widget.publishModel.gallery ?? []).length,
              autoplay: true,
              duration: 500,
              itemBuilder: (context, index) {
                return ThemeNetImage(
                  imageUrl: widget.publishModel.gallery?[index].url,
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

  Widget _bottomBtn() {
    return Container(
      padding: const EdgeInsets.only(right: 12, top: 10),
      color: Colors.white,
      height: 90,
      alignment: Alignment.topRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List.generate(_bottomBtnTitleList.length, (index) {
          return _cellBtn(
              text: _bottomBtnTitleList[index],
              bgColor: Colors.black,
              onTap: () {
                if (_bottomBtnTitleList[index] == '下架') {
                  _pulledGoods();
                } else if (_bottomBtnTitleList[index] == '重新上架') {
                  _publishOnSale();
                } else {
                  AppRouter.replace(context,
                      newPage: AddPage(publishModel: widget.publishModel));
                }
              });
        }),
      ),
    );
  }

  Widget _cellBtn({
    required String text,
    required Color bgColor,
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 100,
        margin: const EdgeInsets.only(left: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: const Color(0xffCECECE))),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
