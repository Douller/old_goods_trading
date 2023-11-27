import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/page/home/goods_details_page.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/utils/regex.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../model/message_list_model.dart';
import '../../net/service_repository.dart';
import '../../utils/toast.dart';
import '../../widgets/theme_image.dart';
import '../mine/my_order_details_page.dart';
import '../mine/seller_goods_details.dart';
import '../mine/seller_personal_center.dart';
import 'message_details_page.dart';

class MessageListPage extends StatefulWidget {
  final String appBarTitle;
  final String categoryId;

  const MessageListPage(
      {Key? key, required this.appBarTitle, required this.categoryId})
      : super(key: key);

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  List<MessageListModel> _messageList = [];

  Future<void> _getMessageCategoryLit() async {
    ToastUtils.showLoading();
    List<MessageListModel> data =
        await ServiceRepository.getMessageList(categoryId: widget.categoryId);
    setState(() {
      _messageList = data;
    });
  }

  Future<void> _jumpPage(MessageListModel model) async {
    ServiceRepository.messageRead(messageId: model.id);

    if (model.jump == null || model.jump?.type == 'no_jump') return;

    if (model.jump?.type == 'goods_view') {
      //'商品详情'
      AppRouter.push(
          context, GoodsDetailsPage(goodsId: model.jump?.data ?? ''));
    } else if (model.jump?.type == 'order_view') {
      //订单详情
      AppRouter.push(
          context, MyOrderDetailsPage(orderId: model.jump?.data ?? ''));
    } else if (model.jump?.type == 'message_view') {
      //消息详情'
      AppRouter.push(context, MessageDetailsPage(model: model));
    } else if (model.jump?.type == 'article_view') {
      //'文章详情'
      debugPrint('文章详情');
    } else if (model.jump?.type == 'supplier_order_view') {
      //卖家订单详情
      AppRouter.push(
          context, SellerGoodsDetails(orderId: model.jump?.data ?? ''));
    } else if (model.jump?.type == 'supplier_view') {
      //卖家主页'
      AppRouter.push(
          context, SellerPersonalCenter(supplierId: model.jump?.data ?? ''));
    } else if (model.jump?.type == 'goods_view') {
      //购买了商品'
      debugPrint('购买了商品');
    } else if (model.jump?.type == 'orderAfter_view') {
      //售后详情
      debugPrint('售后详情');
    } else if (model.jump?.type == 'url') {
      //外链',
      if (model.jump?.data != null &&
          RegexUtils.isURL(model.jump!.data!) &&
          await canLaunchUrlString(model.jump!.data!)) {

        final Uri url = Uri.parse(model.jump!.data!);

        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      }
    }
  }

  @override
  void initState() {
    _getMessageCategoryLit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _messageList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ThemeText(
                  text: _messageList[index].createTime ?? '',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff999999),
                ),
              ),
              GestureDetector(
                onTap: () => _jumpPage(_messageList[index]),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.only(
                      left: 8, right: 10, top: 8, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ThemeText(
                        text: _messageList[index].title ?? '',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ThemeNetImage(
                              imageUrl: _messageList[index].thumb,
                              height: 60,
                              width: 60,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ThemeText(
                              text: _messageList[index].content ?? '',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff999999),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                      _messageList[index].jump?.type == 'no_jump'
                          ? Container()
                          : Column(
                              children: [
                                const SizedBox(height: 16),
                                const Divider(color: Color(0xffEEEEEE)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const ThemeText(
                                      text: '查看详情',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Image.asset(
                                      '${Constants.iconsPath}right_arrow.png',
                                      width: 6,
                                      height: 12,
                                      color: const Color(0xff2F3033),
                                    )
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
