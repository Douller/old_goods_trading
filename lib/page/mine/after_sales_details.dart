import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../model/my_sell_goods_model.dart';
import '../../net/service_repository.dart';
import '../../router/app_router.dart';
import '../../utils/toast.dart';
import '../../widgets/aging_degree_view.dart';
import '../../widgets/back_button.dart';
import '../../widgets/bottom_sheet/choose_delivery_sheet.dart';
import '../../widgets/goods_price_text.dart';
import '../../widgets/theme_image.dart';
import '../../widgets/theme_text.dart';
import 'appraise_page.dart';

class AfterSalesDetails extends StatefulWidget {
  final String orderId;
  final bool isSupplier;

  const AfterSalesDetails(
      {Key? key, required this.orderId, required this.isSupplier})
      : super(key: key);

  @override
  State<AfterSalesDetails> createState() => _AfterSalesDetailsState();
}

class _AfterSalesDetailsState extends State<AfterSalesDetails> {
  MySellGoodsData? _afterSalesModel;

  Future<void> _cellBtnClick(String? orderId, String? actions) async {
    if ((orderId ?? '').isEmpty || (actions ?? '').isEmpty) return;

    if (actions == 'comment/supplierAdd') {
      ///卖家评论买家
      AppRouter.push(
          context,
          AppraisePage(
            orderId: orderId!,
            isSupplier: true,
          )).then((value) async {
        getData();
      });
    } else if (actions == 'supplier/delivery') {
      showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          builder: (context) {
            return ChooseDeliverySheetView(orderId: orderId!);
          }).then((value) {
        if (value != null && value == true) {
          getData();
        }
      });
    } else {
      ToastUtils.showLoading();
      await ServiceRepository.cellBtnClick(
          orderId: orderId!, actions: actions!);
      getData();
    }
  }

  Future<void> getData() async {
    ToastUtils.showLoading();

    MySellGoodsData? data = await ServiceRepository.getAfterSalesDetails(
        isSupplier: widget.isSupplier, orderId: widget.orderId);
    setState(() {
      _afterSalesModel = data;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xffFE734C),
        title: const ThemeText(text: '服务单详情', color: Colors.white),
        leading: const BackArrowButton(color: Colors.white),
      ),
      body: _afterSalesModel == null
          ? Container()
          : Stack(
              children: [
                Container(
                  color: const Color(0xffFE734C),
                  height: 120,
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _orderStatusView(),
                    _lastLogView(),
                    _drawbackView(),
                    _goodsInfoView(),
                    _deliveryInfoView(),
                  ],
                ),
              ],
            ),
      bottomNavigationBar: _bottomBtn(),
    );
  }

  Widget _orderStatusView() {
    return Container(
      color: const Color(0xffFE734C),
      padding: const EdgeInsets.only(left: 26, top: 20),
      child: Row(
        children: List.generate(
          (_afterSalesModel?.statusLiucheng ?? []).length,
          (index) {
            return Expanded(
              child: _orderStatusItem(
                  _afterSalesModel?.statusLiucheng?[index].isSelect == 1,
                  _afterSalesModel?.statusLiucheng?[index].name ?? '',
                  hidden: (_afterSalesModel?.statusLiucheng ?? []).length - 1 ==
                      index),
            );
          },
        ),
      ),
    );
  }

  Widget _orderStatusItem(bool isSelect, String title, {bool hidden = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              isSelect
                  ? "${Constants.iconsPath}order_status_success.png"
                  : "${Constants.iconsPath}order_status_wait.png",
              width: 30,
              height: 30,
            ),
            hidden
                ? Container()
                : Expanded(
                    child: Container(
                      color: Colors.white,
                      height: 2,
                    ),
                  ),
          ],
        ),
        ThemeText(
          text: title,
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _lastLogView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThemeText(
              text: _afterSalesModel?.lastLog?.name ?? '',
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            const SizedBox(height: 10),
            ThemeText(
              text: _afterSalesModel?.lastLog?.content ?? '',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawbackView() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFE734C)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ThemeText(
            text: '退款金额',
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          ThemeText(
            text: '\$${_afterSalesModel?.totalAmount ?? '0'}',
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  Widget _goodsInfoView() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ThemeNetImage(
                  imageUrl: _afterSalesModel?.goodsInfo?.thumbUrl,
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
                            text: _afterSalesModel?.goodsInfo?.name ?? '',
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
                              priceStr:
                                  _afterSalesModel?.goodsInfo!.shopPrice ?? '',
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
                      agingDegreeStr:
                          _afterSalesModel?.goodsInfo?.brushingCondition ?? "",
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xffF6F6F6)),
        ],
      ),
    );
  }

  Widget _deliveryInfoView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: 92,
                child: const ThemeText(
                  text: '订单编号:',
                  color: Color(0xff999999),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: ThemeText(
                  text: _afterSalesModel?.orderSn ?? '',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: 92,
                child: const ThemeText(
                  text: '申请时间:',
                  color: Color(0xff999999),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: ThemeText(
                  text: _afterSalesModel?.createTime ?? '',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          (_afterSalesModel?.deliveryNo ?? '').isEmpty
              ? Container()
              : const SizedBox(height: 16),
          (_afterSalesModel?.deliveryNo ?? '').isEmpty
              ? Container()
              : Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 92,
                      child: const ThemeText(
                        text: '快递订单号:',
                        color: Color(0xff999999),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: ThemeText(
                          text: _afterSalesModel?.deliveryNo ?? '',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: 92,
                child: const ThemeText(
                  text: '服务类型:',
                  color: Color(0xff999999),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: ThemeText(
                  text: _afterSalesModel?.refundTypeName ?? '',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: 92,
                child: const ThemeText(
                  text: '申请原因:',
                  color: Color(0xff999999),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: ThemeText(
                  text: _afterSalesModel?.refundReason ?? '',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomBtn() {
    return (_afterSalesModel?.buttonList ?? []).isEmpty
        ? Container(height: 0)
        : Container(
            padding: const EdgeInsets.only(right: 12, top: 10),
            color: Colors.white,
            height: 80,
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                  (_afterSalesModel?.buttonList ?? []).length, (index) {
                return _cellBtn(
                    text: _afterSalesModel?.buttonList?[index].bName ?? '',
                    bgColor:
                        (_afterSalesModel?.buttonList?[index].bType ?? '') ==
                                '1'
                            ? const Color(0xffFE734C)
                            : const Color(0xffF6F6F6),
                    textColor:
                        (_afterSalesModel?.buttonList?[index].bType ?? '') ==
                                '1'
                            ? Colors.white
                            : const Color(0xff666666),
                    onTap: () {
                      if ((_afterSalesModel?.buttonList?[index].bName ?? '') !=
                          '支付') {
                        _cellBtnClick(
                          _afterSalesModel?.id,
                          _afterSalesModel?.buttonList?[index].actions,
                        );
                      }
                    });
              }),
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
