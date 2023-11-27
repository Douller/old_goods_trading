import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

class ToastUtils {
  static showText({
    required String text,
    Color backgroundColor = Colors.transparent,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(8)),
    AlignmentGeometry align = Alignment.center,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
    Duration duration = const Duration(seconds: 3),
    Duration? animationDuration,
    Duration? animationReverseDuration,
  }) {
    ToastUtils.hiddenAllToast();
    BotToast.showText(
      text: text,
      contentColor: const Color(0xff000000).withOpacity(0.6),
      align: align,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      textStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
      contentPadding: contentPadding,
      duration: duration,
      animationDuration: animationDuration,
      animationReverseDuration: animationReverseDuration,
      onlyOne: true,
      enableKeyboardSafeArea: true,
    ); //弹出一个文本框;
  }

  static showLoading({
    VoidCallback? onClose,
    bool clickClose = true,
  }) {
    ToastUtils.hiddenAllToast();
    BotToast.showLoading(
      enableKeyboardSafeArea: true,
      onClose: onClose,
      clickClose: clickClose,
      backgroundColor: Colors.transparent,
    );
  }

  static hiddenAllToast() {
    BotToast.cleanAll();
  }
}
