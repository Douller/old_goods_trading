import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../back_button.dart';

class SearchDetailsAppBar extends StatelessWidget {
  final String keywords;
  const SearchDetailsAppBar({Key? key, required this.keywords})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BackArrowButton(),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 36,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      '${Constants.iconsPath}search_tf.png',
                      width: 16,
                      height: 17,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          height: 26,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            color: const Color(0xffEEEEEE),
                          ),
                          child: Row(
                            children: [
                              Text(
                                keywords,
                                style: const TextStyle(
                                  color: Color(0xff2F3033),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 7),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Image.asset(
                                  '${Constants.iconsPath}delete_x.png',
                                  width: 12,
                                  height: 12,
                                  fit: BoxFit.contain,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
