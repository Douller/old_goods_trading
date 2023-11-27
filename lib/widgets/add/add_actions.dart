import 'package:flutter/material.dart';

import '../theme_button.dart';

class AddPublishBtn extends StatelessWidget {
  final VoidCallback onPressed;

  const AddPublishBtn({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 10, bottom: 10, right: 12),
      child: ThemeButton(
        width: 60,
        height: 30,
        text: '发布',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        onPressed: onPressed,
      ),
    );
  }
}

class AddDraftsBtn extends StatelessWidget {
  final VoidCallback onPressed;

  const AddDraftsBtn({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          width: 60,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xffCECECE)),
            color: Colors.white,
          ),
          child: const Text(
            '存稿箱',
            style: TextStyle(
              color: Color(0xff2F3033),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
