import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/mine/order_stepper_view.dart';
import '../../constants/constants.dart';
import '../../model/my_sell_goods_model.dart';
import '../../net/service_repository.dart';
import '../../router/app_router.dart';
import '../../utils/toast.dart';
import '../../widgets/aging_degree_view.dart';
import '../../widgets/back_button.dart';
import '../../widgets/bottom_sheet/choose_delivery_sheet.dart';
import '../../widgets/goods_price_text.dart';
import '../../widgets/home_widgets/message_cell.dart';
import '../../widgets/theme_image.dart';
import '../../widgets/theme_text.dart';
import '../home/goods_details_page.dart';
import 'appraise_page.dart';

class SellerGoodsDetails extends StatefulWidget {
  final String orderId;

  const SellerGoodsDetails({Key? key, required this.orderId}) : super(key: key);

  @override
  State<SellerGoodsDetails> createState() => _SellerGoodsDetailsState();
}

class _SellerGoodsDetailsState extends State<SellerGoodsDetails> {
  MySellGoodsData? _sellModel;

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
            return  ChooseDeliverySheetView(orderId: widget.orderId,);
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

    MySellGoodsData? data =
        await ServiceRepository.supplierOrderInfo(widget.orderId);
    setState(() {
      _sellModel = data;
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
        title: const ThemeText(text: '订单详情', color: Colors.white),
        leading: const BackArrowButton(color: Colors.white),
      ),
      body: _sellModel == null
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
                    _sellModel?.deliveryInfo == null ||
                            (_sellModel?.deliveryInfo?.statusName ?? '').isEmpty
                        ? _addressView()
                        : OrderStepperView(model: _sellModel, isSell: true),
                    _goodsInfoView(),
                    _priceInfoView(),
                    _deliveryInfoView(),
                    _messageBoard(),
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
          (_sellModel?.statusLiucheng ?? []).length,
          (index) {
            return Expanded(
              child: _orderStatusItem(
                  _sellModel?.statusLiucheng?[index].isSelect == 1,
                  _sellModel?.statusLiucheng?[index].name ?? '',
                  hidden:
                      (_sellModel?.statusLiucheng ?? []).length - 1 == index),
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

  Widget _addressView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ThemeText(
                      text: _sellModel?.addressInfo?.consignee ?? '',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                    const SizedBox(width: 20),
                    ThemeText(
                      text: _sellModel?.addressInfo?.telephone ?? '',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ThemeText(
                  text: _sellModel?.addressAll ?? '',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _goodsInfoView() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => AppRouter.push(
                context,
                GoodsDetailsPage(
                  goodsId: _sellModel?.goodsInfo?.goodsId ?? '',
                  isSeller: true,
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ThemeNetImage(
                    imageUrl: _sellModel?.goodsInfo?.thumb,
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
                              text: _sellModel?.goodsInfo?.goodsName ?? '',
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
                                    _sellModel?.goodsInfo!.totalAmount ?? '',
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
                            _sellModel?.goodsInfo?.brushingCondition ?? "",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xffF6F6F6)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ThemeText(
                text: '留言: ',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xff999999),
              ),
              Expanded(child: Container()),
              Expanded(
                child: ThemeText(
                  text: _sellModel?.userMemo ?? '无',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  textAlign: TextAlign.right,
                ),
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
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ThemeText(
                text: '商品金额:',
                color: Color(0xff999999),
                fontSize: 16,
              ),
              ThemeText(
                text: '\$${_sellModel?.goodsInfo?.totalAmount ?? ''}',
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
                text: '运费:',
                color: Color(0xff999999),
                fontSize: 16,
              ),
              ThemeText(
                text: '\$ ${_sellModel?.fare ?? 0.0}',
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
                text: '优惠金额:',
                color: Color(0xff999999),
                fontSize: 16,
              ),
              Row(
                children: [
                  ThemeText(
                    text: '\$${_sellModel?.discountAmount ?? '0'}',
                    color: const Color(0xff999999),
                    fontSize: 16,
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const ThemeText(
                text: '实付: \$',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(width: 4),
              ThemeText(
                text: _sellModel?.totalAmount ?? '0',
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _deliveryInfoView() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  text: _sellModel?.orderSn ?? '',
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
                  text: '下单时间:',
                  color: Color(0xff999999),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: ThemeText(
                  text: _sellModel?.createTime ?? '',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          (_sellModel?.deliveryNo ?? '').isEmpty
              ? Container()
              : const SizedBox(height: 16),
          (_sellModel?.deliveryNo ?? '').isEmpty
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
                          text: _sellModel?.deliveryNo ?? '',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
          (_sellModel?.deliveryCompany ?? '').isEmpty
              ? Container()
              : const SizedBox(height: 16),
          (_sellModel?.deliveryCompany ?? '').isEmpty
              ? Container()
              : Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 92,
                      child: const ThemeText(
                        text: '物流公司:',
                        color: Color(0xff999999),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: ThemeText(
                        text: _sellModel?.deliveryCompany ?? '',
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

  Widget _messageBoard() {
    return _sellModel?.commentList == null || _sellModel!.commentList!.isEmpty
        ? Container()
        : Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            color: Colors.white,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(_sellModel!.commentList!.length, (index) {
                return MessageCell(
                  index: index,
                  commentList: _sellModel!.commentList!,
                );
              }),
            ),
          );
  }

  Widget _bottomBtn() {
    return (_sellModel?.buttonList ?? []).isEmpty
        ? Container(height: 0)
        : Container(
            padding: const EdgeInsets.only(right: 12, top: 10),
            color: Colors.white,
            height: 80,
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:
                  List.generate((_sellModel?.buttonList ?? []).length, (index) {
                return _cellBtn(
                    text: _sellModel?.buttonList?[index].bName ?? '',
                    bgColor: (_sellModel?.buttonList?[index].bType ?? '') == '1'
                        ? const Color(0xffFE734C)
                        : const Color(0xffF6F6F6),
                    textColor:
                        (_sellModel?.buttonList?[index].bType ?? '') == '1'
                            ? Colors.white
                            : const Color(0xff666666),
                    onTap: () {
                      if ((_sellModel?.buttonList?[index].bName ?? '') !=
                          '支付') {
                        _cellBtnClick(
                          _sellModel?.id,
                          _sellModel?.buttonList?[index].actions,
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
