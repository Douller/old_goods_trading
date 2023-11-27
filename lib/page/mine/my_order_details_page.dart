import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import '../../states/my_order_details_state.dart';
import '../../widgets/aging_degree_view.dart';
import '../../widgets/back_button.dart';
import '../../widgets/goods_price_text.dart';
import '../../widgets/home_widgets/message_cell.dart';
import '../../widgets/mine/my_order_details_address_view.dart';
import '../../widgets/mine/order_stepper_view.dart';
import '../../widgets/theme_image.dart';
import '../home/goods_details_page.dart';

class MyOrderDetailsPage extends StatefulWidget {
  final String orderId;

  const MyOrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<MyOrderDetailsPage> createState() => _MyOrderDetailsPageState();
}

class _MyOrderDetailsPageState extends State<MyOrderDetailsPage> {
  final MyOrderDetailsViewModel _myOrderDetailsViewModel =
      MyOrderDetailsViewModel();

  @override
  void initState() {
    _myOrderDetailsViewModel.getMyOrderDetails(context, widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _myOrderDetailsViewModel,
      child: Scaffold(
        backgroundColor: const Color(0xffF9F9F9),
        appBar: AppBar(
          backgroundColor: const Color(0xffFE734C),
          title: const ThemeText(text: '我的订单', color: Colors.white),
          leading: const BackArrowButton(color: Colors.white),
          // systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Stack(
          children: [
            Container(
              color: const Color(0xffFE734C),
              height: 150,
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                _orderStatusView(),
                _countdownText(),
                Consumer<MyOrderDetailsViewModel>(
                  builder: (BuildContext context, value, Widget? child) {
                    return value.model?.deliveryInfo == null ||
                            (value.model?.deliveryInfo?.statusName ?? '')
                                .isEmpty
                        ? const MyOrderDetailsAddressView()
                        : OrderStepperView(model: value.model,isSell: false);
                  },
                ),
                _goodsInfoView(),
                _priceInfoView(),
                _deliveryInfoView(),
                _messageBoard(),
              ],
            ),
          ],
        ),
        bottomNavigationBar: _bottomBtn(),
      ),
    );
  }

  Widget _orderStatusView() {
    return Consumer<MyOrderDetailsViewModel>(
        builder: (BuildContext context, value, Widget? child) {
      return Container(
        color: const Color(0xffFE734C),
        padding: const EdgeInsets.only(left: 26, top: 20),
        child: Row(
          children: List.generate((value.model?.statusLiucheng ?? []).length,
              (index) {
            return Expanded(
                child: _orderStatusItem(
                    value.model?.statusLiucheng?[index].isSelect == 1,
                    value.model?.statusLiucheng?[index].name ?? '',
                    hidden: (value.model?.statusLiucheng ?? []).length - 1 ==
                        index));
          }),
        ),
      );
    });
  }

  Widget _countdownText() {
    return Consumer<MyOrderDetailsViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        if (value.countDownString == null) {
          return const SizedBox(
            height: 26,
          );
        } else {
          return Container(
            margin: const EdgeInsets.only(top: 16, left: 12),
            child: Row(
              children: [
                Expanded(
                  child: ThemeText(
                    text: '倒计时:${value.countDownString}',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          );
        }
      },
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

  Widget _goodsInfoView() {
    return Consumer<MyOrderDetailsViewModel>(
      builder: (BuildContext context, value, Widget? child) {
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
                      goodsId: value.model?.goodsInfo?.goodsId ?? '',
                    )),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ThemeNetImage(
                        imageUrl: value.model?.goodsInfo?.thumb,
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
                                  text: value.model?.goodsInfo?.goodsName ?? '',
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
                                        value.model?.goodsInfo!.totalAmount ??
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
                            agingDegreeStr:
                                value.model?.goodsInfo?.brushingCondition ?? "",
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
                      text: value.model?.userMemo ?? '无',
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
      },
    );
  }

  Widget _priceInfoView() {
    return Consumer<MyOrderDetailsViewModel>(
      builder: (BuildContext context, value, Widget? child) {
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
                    text: '\$${value.model?.goodsInfo?.totalAmount ?? ''}',
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
                    text: '\$ ${value.model?.fare ?? 0.0}',
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
                        text: '\$${value.model?.discountAmount ?? '0'}',
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
                    text: value.model?.totalAmount ?? '0',
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _deliveryInfoView() {
    return Consumer<MyOrderDetailsViewModel>(
        builder: (BuildContext context, value, Widget? child) {
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
                    text: value.model?.orderSn ?? '',
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
                    text: value.model?.createTime ?? '',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            (value.model?.deliveryNo ?? '').isEmpty
                ? Container()
                : const SizedBox(height: 16),
            (value.model?.deliveryNo ?? '').isEmpty
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
                            text: value.model?.deliveryNo ?? '',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
            (value.model?.deliveryCompany ?? '').isEmpty
                ? Container()
                : const SizedBox(height: 16),
            (value.model?.deliveryCompany ?? '').isEmpty
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
                          text: value.model?.deliveryCompany ?? '',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      );
    });
  }

  Widget _messageBoard() {
    return Consumer<MyOrderDetailsViewModel>(
        builder: (BuildContext context, value, Widget? child) {
      return value.model?.commentList == null ||
              value.model!.commentList!.isEmpty
          ? Container()
          : Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              color: Colors.white,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children:
                    List.generate(value.model!.commentList!.length, (index) {
                  return MessageCell(
                    index: index,
                    commentList: value.model!.commentList!,
                  );
                }),
              ),
            );
    });
  }

  Widget _bottomBtn() {
    return Consumer<MyOrderDetailsViewModel>(
        builder: (BuildContext context, value, Widget? child) {
      return (value.model?.buttonList ?? []).isEmpty
          ? Container(height: 0)
          : Container(
              padding: const EdgeInsets.only(right: 12, top: 10),
              color: Colors.white,
              height: 100,
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate((value.model?.buttonList ?? []).length,
                    (index) {
                  return _cellBtn(
                      text: value.model?.buttonList?[index].bName ?? '',
                      bgColor:
                          (value.model?.buttonList?[index].bType ?? '') == '1'
                              ? const Color(0xffFE734C)
                              : const Color(0xffF6F6F6),
                      textColor:
                          (value.model?.buttonList?[index].bType ?? '') == '1'
                              ? Colors.white
                              : const Color(0xff666666),
                      onTap: () {
                        value.cellBtnClick(
                          context,
                          value.model?.buttonList?[index].bName ?? '',
                          value.model?.buttonList?[index].actions ?? '',
                        );
                      });
                }),
              ),
            );
    });
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
        height: 40,
        width: 100,
        margin: const EdgeInsets.only(left: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          // text == '支付'
          //     ? '立即支付'
          //     : text == '取消'
          //         ? '取消订单'
          //         :
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: text == '支付' ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
