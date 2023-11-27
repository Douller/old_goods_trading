import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

import '../../model/phone_prefix_model.dart';

class PhonePrefixPage extends StatefulWidget {
  final List<PhonePrefixData> phonePrefixList;

  const PhonePrefixPage({Key? key, required this.phonePrefixList})
      : super(key: key);

  @override
  State<PhonePrefixPage> createState() => _PhonePrefixPageState();
}

class _PhonePrefixPageState extends State<PhonePrefixPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('选择国家或者地区'),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: widget.phonePrefixList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, widget.phonePrefixList[index]);
              },
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    ThemeText(text: widget.phonePrefixList[index].name ?? ''),
                    Expanded(child: Container()),
                    ThemeText(
                      text: widget.phonePrefixList[index].val ?? '',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff223263),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
