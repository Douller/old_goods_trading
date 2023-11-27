import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import '../../constants/constants.dart';
import '../../model/order_buy_confirm_model.dart';
import '../goods_price_text.dart';

typedef CouponBottomCallback = void Function(CouponInfo model);

class CouponBottomSheetView extends StatefulWidget {
  final List<CouponInfo> dataList;
  final CouponInfo? chooseModel;
  final CouponBottomCallback callback;

  const CouponBottomSheetView({
    Key? key,
    required this.dataList,
    required this.callback,
    required this.chooseModel,
  }) : super(key: key);

  @override
  State<CouponBottomSheetView> createState() => _CouponBottomSheetViewState();
}

class _CouponBottomSheetViewState extends State<CouponBottomSheetView> {
  CouponInfo? _chooseCouponModel;

  @override
  void initState() {
    _chooseCouponModel = widget.chooseModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      constraints: const BoxConstraints(maxHeight: 500),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _topTitleView,
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.dataList.length,
                itemBuilder: (context, index) {
                  return _couponCell(widget.dataList[index]);
                },
              ),
            ),
            _bottomBtn(),
          ],
        ),
      ),
    );
  }

  Widget _couponCell(CouponInfo model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            '${Constants.placeholderPath}coupon_available.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 75,
            child: Row(
              children: [
                SizedBox(
                  width: 97,
                  child: GoodsPriceText(
                    priceStr: model.value ?? '',
                    textFontWeight: FontWeight.w600,
                    textFontSize: 30,
                    symbolFontWeight: FontWeight.w600,
                    symbolFontSize: 20,
                    color: const Color(0xffFF3800),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ThemeText(
                              text: model.name ?? '',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: model.useStatus == '9'
                                  ? const Color(0xff2F3033)
                                  : const Color(0xffFF3800),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _chooseCouponModel = model;
                                });
                              },
                              child: Container(
                                width: 70,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: _chooseCouponModel == model
                                      ? const Color(0xffFE734C)
                                      : Colors.white,
                                  border: Border.all(
                                    color: const Color(0xffFE734C),
                                  ),
                                ),
                                child: ThemeText(
                                  text: _chooseCouponModel == model
                                      ? '已选择'
                                      : '选择',
                                  color: _chooseCouponModel == model
                                      ? Colors.white
                                      : const Color(0xffFE734C),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ThemeText(
                          text: '${model.useBeginTime} ~ ${model.useEndTime}',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff999999),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 25,
            alignment: Alignment.centerLeft,
            child: const ThemeText(
              text: '所有商品通用',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBtn() {
    return GestureDetector(
      onTap: () {
        if (_chooseCouponModel != null) {
          widget.callback(_chooseCouponModel!);
          Navigator.pop(context);
        }
      },
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _chooseCouponModel != null
              ? const Color(0xffFE734C)
              : const Color(0xffCECECE),
          borderRadius: BorderRadius.circular(44),
        ),
        child: const Text(
          '确定',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
    );
  }

  Widget get _topTitleView {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ThemeText(
            text: '请选择优惠券',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(4),
              width: 23,
              height: 23,
              child: Image.asset(
                '${Constants.iconsPath}close.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
