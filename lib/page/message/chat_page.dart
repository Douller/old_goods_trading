import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import '../../model/home_goods_list_model.dart';
import '../../widgets/goods_price_text.dart';
import '../../widgets/theme_image.dart';
import '../home/confirm_order_page.dart';
import '../home/goods_details_page.dart';

class ChatPage extends StatefulWidget {
  final V2TimConversation? selectedConversation;
  final GoodsInfoModel? goodsInfoModel;

  const ChatPage({Key? key, this.goodsInfoModel, this.selectedConversation})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  GoodsInfoModel? _goodsInfoModel;
  String _messageId = '';

  ///私信时关联会话和商品
  Future<void> messageAddRalation() async {
    bool res = await ServiceRepository.messageAddRalation(
      messageId: _messageId,
      goodsId: widget.goodsInfoModel?.id ?? '',
      type: '1',
    );

    if (res) {
      messageGetRalation();
    }
  }

  ///获取关联的商品信息
  Future<void> messageGetRalation() async {
    GoodsInfoModel? res = await ServiceRepository.messageGetRalation(
      messageId: _messageId,
      type: '1',
    );
    setState(() {
      _goodsInfoModel = res;
    });
  }

  void _goodsBtnClick() {
    if (_goodsInfoModel?.status == '1') {
      AppRouter.replace(
        context,
        newPage: ConfirmOrderPage(goodsInfoModel: _goodsInfoModel!),
      );
    } else {
      AppRouter.replace(context,
          newPage: GoodsDetailsPage(goodsId: _goodsInfoModel?.id ?? ''));
    }
  }

  @override
  void initState() {
    _goodsInfoModel = widget.goodsInfoModel;
    if (widget.selectedConversation == null) {
      _messageId = "c2c_${widget.goodsInfoModel?.supplierInfo?.id}";
      messageAddRalation();
    } else {
      _messageId = "${widget.selectedConversation?.conversationID}";
      messageGetRalation();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TIMUIKitChat(
      topFixWidget: _goodsInfoModel == null ? Container() : _topFixWidget(),
      config: TIMUIKitChatConfig(
          isAllowClickAvatar: true,
          isAllowLongPressMessage: true,
          isShowReadingStatus: true,
          isShowGroupReadingStatus: true,
          notificationTitle: "",
          isUseMessageReaction: true,
          groupReadReceiptPermissionList: [
            GroupReceiptAllowType.work,
            GroupReceiptAllowType.meeting,
            GroupReceiptAllowType.public
          ],
          notificationBody:
              (V2TimMessage message, String convID, ConvType convType) {
            return message.textElem?.text ?? '';
          },
          notificationExt:
              (V2TimMessage message, String convID, ConvType convType) {
            // Map dataMap = {
            //   'selectedConversation':widget.selectedConversation,
            //   'messageId': "${widget.selectedConversation?.conversationID}"
            // };
            //
            // String jsonStr = json.encode(dataMap);
            // return jsonStr;
            // 您根据给出的参数自定义的EXT字段：此处建议传conversation id，JSON格式，即如下所示
            String createJSON(String convID){
              return "{\"conversationID\": \"$convID\"}";
            }
            String ext =  (convType == ConvType.c2c
                ? createJSON("c2c_${message.sender}")
                : createJSON("group_$convID"));
            return ext;
          }),
      conversation: widget.selectedConversation ??
          V2TimConversation(
            conversationID: "c2c_${widget.goodsInfoModel?.supplierInfo?.id}",
            userID: widget.goodsInfoModel?.supplierInfo?.id,
            showName: widget.goodsInfoModel?.supplierInfo?.name,
            type: 1,
          ),
      appBarConfig: AppBar(
        iconTheme: const IconThemeData(color: Colors.black, size: 17),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 17,
          color: Color(0xFF2F3033),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _topFixWidget() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: const Color(0xffE4D719).withOpacity(0.8))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ThemeNetImage(
                    imageUrl: _goodsInfoModel?.thumbUrl,
                    height: 72,
                    width: 72,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoodsPriceText(
                      priceStr: _goodsInfoModel?.shopPrice ?? '',
                      symbolFontSize: 20,
                      textFontSize: 20,
                      symbolFontWeight: FontWeight.w500,
                      textFontWeight: FontWeight.w500,
                      color: const Color(0xFFEA4545).withOpacity(0.8),
                    ),
                    const SizedBox(height: 4),
                    ThemeText(
                      text: _goodsInfoModel?.deliveryType ?? '',
                      color: const Color(0xFF484C52).withOpacity(0.4),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    ThemeText(
                      text: _goodsInfoModel?.deliveryCity ?? '',
                      color: const Color(0xFF484C52).withOpacity(0.4),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
              ),
              ThemeButton(
                onPressed: _goodsBtnClick,
                text: _goodsInfoModel?.status == '1' ? '立即购买' : '查看商品',
                fontSize: 12,
                width: 80,
                height: 30,
              ),
            ],
          ),
        ),
        // _goodsInfoModel?.notice == null
        //     ? Container()
        //     : Container(
        //         color: const Color(0xFFFF3800),
        //         padding: const EdgeInsets.symmetric(vertical: 6),
        //         alignment: Alignment.center,
        //         child: ThemeText(
        //           text: _goodsInfoModel?.notice ?? '',
        //           fontSize: 10,
        //           color: Colors.white,
        //         ),
        //       )
      ],
    );
  }
}
