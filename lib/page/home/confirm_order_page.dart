import 'dart:io';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/page/mine/my_address_page.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/bottom_sheet/coupon_sheet_view.dart';
import 'package:old_goods_trading/widgets/bottom_sheet/pay_sheet.dart';
import 'package:old_goods_trading/page/home/pay_status_page.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import '../../model/home_goods_list_model.dart';
import '../../model/order_buy_confirm_model.dart';
import '../../model/order_create_model.dart';
import '../../widgets/aging_degree_view.dart';
import '../../widgets/goods_price_text.dart';
import '../../widgets/theme_button.dart';
import '../../widgets/theme_image.dart';

class ConfirmOrderPage extends StatefulWidget {
  final GoodsInfoModel goodsInfoModel;

  const ConfirmOrderPage({Key? key, required this.goodsInfoModel})
      : super(key: key);

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  AddressModelInfo? _addressModel;
  CouponInfo? _chooseCouponModel;
  final List<CouponInfo> _canUserCoupon = [];
  final TextEditingController _remarkController = TextEditingController();
  String? _userMemo;
  SubmitOrderModel? _submitOrderModel;

  ///获取订单提交前信息
  Future<void> getOrderBuyConfirm() async {
    ToastUtils.showLoading();

    SubmitOrderModel? modelRes = await ServiceRepository.getOrderBuyConfirm(
        goodsId: widget.goodsInfoModel.id!);

    ToastUtils.hiddenAllToast();

    setState(() {
      _submitOrderModel = modelRes;
      _addressModel = modelRes?.addressInfo;
      List<CouponInfo>? couponList = modelRes?.couponInfo;

      couponList?.forEach((element) {
        if (element.useStatus == '0') {
          _canUserCoupon.add(element);
        }
      });
    });
  }

  //弹出支付
  void _pushPaySheetView() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_addressModel == null) {
      ToastUtils.showText(text: '请添加收货地址');
      return;
    }

    OrderCreateModel? orderCreateModel = await ServiceRepository.getOrderCreate(
      goodsId: widget.goodsInfoModel.id ?? '',
      addressId: _addressModel?.id ?? '',
      couponId: _chooseCouponModel?.id,
      userMemo: _userMemo,
    );

    if (orderCreateModel != null && orderCreateModel.id != null) {
      if (!mounted) return;
      showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return PayBottomSheet(
              totalAmount: (orderCreateModel.totalAmount ?? 0).toString(),
              orderSN: orderCreateModel.orderSn!,
              description: orderCreateModel.goodsInfo?.goodsName ?? '',
              orderId: orderCreateModel.id!,
            );
          }).then((value) async {
        if (value != null && value >= 0) {
          AppRouter.replace(context,
              newPage: PayStatusPage(
                amount: orderCreateModel.totalAmount ?? '0',
                orderId: orderCreateModel.id ?? '',
              ));
        }
      });
    }
  }

  Future<void> _pay()async{

  }

  void _pushCouponSheetView() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return CouponBottomSheetView(
            dataList: _canUserCoupon,
            chooseModel: _chooseCouponModel,
            callback: (CouponInfo model) {
              setState(() {
                _chooseCouponModel = model;
              });
            },
          );
        });
  }

  @override
  void initState() {
    getOrderBuyConfirm();

    _remarkController.addListener(() {
      if (_remarkController.text.trim().isNotEmpty) {
        _userMemo = _remarkController.text;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          title: const Text('确认订单'),
        ),
        body: _submitOrderModel == null
            ? Container()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 26),
                    _addressView(),
                    _goodsInfoView(),
                    _priceInfoView(),
                  ],
                ),
              ),
        bottomNavigationBar: Container(
          color: const Color(0xffF4F3F3),
          height: Platform.isIOS ? 80 : 60 + Constants.bottomPadding,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 33, top: 11, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GoodsPriceText(
                priceStr: (num.parse(widget.goodsInfoModel.shopPrice ?? '0') +
                        (_submitOrderModel?.deliveryAmount ?? 0.0) -
                        (_chooseCouponModel == null
                            ? 0
                            : num.parse(_chooseCouponModel?.value ?? '0')))
                    .toString(),
                textFontWeight: FontWeight.w600,
                textFontSize: 32,
                symbolFontWeight: FontWeight.w600,
                symbolFontSize: 32,
              ),
              ThemeButton(
                text: '立即购买',
                width: 86,
                height: 40,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                radius: 16,
                onPressed: _pushPaySheetView,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addressView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          AppRouter.push(context,
                  MyAddressPage(isSelect: true, selectModel: _addressModel))
              .then((value) {
            if (value != null && value is AddressModelInfo) {
              setState(() {
                _addressModel = value;
              });
            }
          });
        },
        child: Row(
          children: [
            if (_addressModel == null)
              Expanded(
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  child: const ThemeText(
                    text: '添加收货地址',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: '${_addressModel?.consignee ?? ''}    ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: _addressModel?.telephone ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13),
                    ThemeText(
                      text: _addressModel?.address ?? '',
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            Image.asset(
              '${Constants.iconsPath}right_arrow.png',
              width: 10,
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _goodsInfoView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: const Color(0xffE4D719).withOpacity(0.8)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ThemeNetImage(
                    imageUrl: widget.goodsInfoModel.thumbUrl,
                    height: 73,
                    width: 73,
                    fit: BoxFit.cover,
                  ),
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
                            text: widget.goodsInfoModel.name ?? '',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GoodsPriceText(
                          priceStr: widget.goodsInfoModel.shopPrice ?? '',
                          symbolFontSize: 20,
                          textFontSize: 20,
                          symbolFontWeight: FontWeight.w500,
                          textFontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AgingDegreeView(
                      agingDegreeStr: widget.goodsInfoModel.tags ?? "",
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemeText(
                text: '留言: ',
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: const Color(0xff484C52).withOpacity(0.4),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _remarkController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入留言',
                  hintStyle: TextStyle(
                    color: const Color(0xff484C52).withOpacity(0.4),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                maxLines: null,
                maxLength: 100,
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _priceInfoView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ThemeText(
                text: '商品金额:',
                color: Color(0xff223263),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              ThemeText(
                text: '\$${widget.goodsInfoModel.shopPrice ?? ''}',
                color: const Color(0xffEA4545).withOpacity(0.6),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ThemeText(
                text: '运费:',
                color: Color(0xff223263),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              ThemeText(
                text: '\$ ${_submitOrderModel?.deliveryAmount ?? 0.0}',
                color: const Color(0xff999999),
                fontSize: 16,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ThemeText(
                text: '优惠券:',
                color: Color(0xff223263),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              GestureDetector(
                onTap: () {
                  if (_canUserCoupon.isNotEmpty) {
                    _pushCouponSheetView();
                  }
                },
                child: Row(
                  children: [
                    ThemeText(
                      text: _canUserCoupon.isNotEmpty
                          ? _chooseCouponModel != null
                              ? '- ${_chooseCouponModel?.value ?? ""}'
                              : '请选择'
                          : '无可用优惠券',
                      color:
                          _canUserCoupon.isEmpty || _chooseCouponModel != null
                              ? const Color(0xff999999)
                              : const Color(0xffFE734C),
                      fontSize: 14,
                    ),
                    const SizedBox(width: 6),
                    _canUserCoupon.isNotEmpty
                        ? Image.asset(
                            '${Constants.iconsPath}right_arrow.png',
                            width: 8,
                            height: 8,
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const ThemeText(
                text: '实付: \$',
                color: Color(0xff223263),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(width: 4),
              ThemeText(
                text: (num.parse(widget.goodsInfoModel.shopPrice ?? '0') +
                        (_submitOrderModel?.deliveryAmount ?? 0.0) -
                        (_chooseCouponModel == null
                            ? 0
                            : num.parse(_chooseCouponModel?.value ?? '0')))
                    .toString(),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          )
        ],
      ),
    );
  }
}
