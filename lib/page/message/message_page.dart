import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/page/message/chat_page.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_uikit_conversation.dart';
import '../../router/app_router.dart';
import '../../widgets/theme_image.dart';
import 'message_list_page.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List _messageList = [];

  Future<void> _getMessageCategoryLit() async {
    ToastUtils.showLoading();
    List data = await ServiceRepository.getMessageCategory();
    setState(() {
      _messageList = data;
    });
  }

  @override
  void initState() {
    if (Constants.isLogin()) {
      _getMessageCategoryLit();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(backgroundColor: const Color(0xffFAFAFA)),
      body: Column(
        children: [
          if (_messageList.isEmpty) Container() else Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          AppRouter.push(
                              context,
                              MessageListPage(
                                  appBarTitle: _messageList[index]['name'],
                                  categoryId: _messageList[index]['id']))
                              .then((value) => _getMessageCategoryLit());
                        },

                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xffE4D719).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(48),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: ThemeNetImage(
                                imageUrl: _messageList[index]['icon'],
                              ),
                            ),
                            ThemeText(
                              text: _messageList[index]['name'] ?? '',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: const Color(0xff484C52),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                ),
          const SizedBox(height: 20),
          Expanded(
            child: TIMUIKitConversation(
              onTapItem: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      selectedConversation: value,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _messageChildView(
    String iconPath,
    String? title,
    String? subtitle,
    String? unRead,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Stack(
            fit: StackFit.passthrough,
            alignment: AlignmentDirectional.topEnd,
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                width: 41,
                height: 42,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: ThemeNetImage(
                    imageUrl: iconPath,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
              int.tryParse(unRead ?? '0') == 0
                  ? Container()
                  : Container(
                      width: 14,
                      height: 14,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xffFF3800),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ThemeText(
                        color: Colors.white,
                        text: int.tryParse(unRead ?? '0')! > 9
                            ? '9+'
                            : int.tryParse(unRead ?? '0').toString(),
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    )
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? '',
                style: const TextStyle(
                    color: Color(0xff2F3033),
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle ?? '',
                style: const TextStyle(
                    color: Color(0xff999999),
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }
}
