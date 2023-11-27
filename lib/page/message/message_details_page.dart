import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

import '../../model/message_list_model.dart';

class MessageDetailsPage extends StatefulWidget {
  final MessageListModel model;

  const MessageDetailsPage({Key? key, required this.model}) : super(key: key);

  @override
  State<MessageDetailsPage> createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        title: const Text('消息详情'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ThemeText(
                text: widget.model.title ?? '',
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 12,
                  color: Color(0xff999999),
                ),
                const SizedBox(width: 6),
                ThemeText(
                  text: widget.model.createTime ?? '',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: const Color(0xff999999),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: ThemeText(
                text: widget.model.content ?? '',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: const Color(0xff666666),
              ),
            )
          ],
        ),
      ),
    );
  }
}
