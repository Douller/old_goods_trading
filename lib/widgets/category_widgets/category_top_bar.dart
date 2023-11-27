import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../page/home/search.dart';
import '../../router/app_router.dart';

class CategoryTopBar extends StatelessWidget {
  const CategoryTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRouter.push(context, const SearchPage()),
      child: Container(
        height: 32,
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        padding: const EdgeInsets.only(left: 14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            border: const Border.fromBorderSide(
                BorderSide(color: Color(0xffD9D26A), width: 2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '搜索商品',
              style: TextStyle(
                color: Colors.black.withOpacity(0.2),
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
            Container(
              height: 32,
              width: 53,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xffE4D719),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Image.asset(
                '${Constants.iconsPath}search_tf.png',
                width: 24,
                height: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
