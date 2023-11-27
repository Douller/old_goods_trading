import 'package:flutter/material.dart';
import 'package:old_goods_trading/constants/constants.dart';

class NoDataView extends StatelessWidget {
  final String? pictureName;
  final String? tips;
  const NoDataView({Key? key, this.pictureName, this.tips}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Image(
            image: AssetImage(
                pictureName ?? '${Constants.placeholderPath}no_data.png'),
            width: 240,
            height: 240,
          ),
          const SizedBox(height: 25),
          Text(
            tips ?? '暂无数据',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF999999),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
