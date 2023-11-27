import 'package:flutter/material.dart';
import 'package:old_goods_trading/states/add_page_state.dart';
import 'package:provider/provider.dart';

class AddGoodsDescribeTextField extends StatelessWidget {
  const AddGoodsDescribeTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPageViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        return SizedBox(
          height: 100,
          child: TextField(
            controller: value.describeTEC,
            // focusNode: value.describeFocusNode,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 10),
              border: InputBorder.none,
              hintText: '描述一下宝贝的型号, 货品来源。',
              hintStyle: TextStyle(
                color: const Color(0xff484C52).withOpacity(0.4),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            maxLines: null,
          ),
        );
      },
    );
  }
}
