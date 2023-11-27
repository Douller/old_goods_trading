import 'package:flutter/material.dart';

import '../../constants/constants.dart';

typedef ValueChanged<String> = void Function(String value);

class SearchTextField extends StatelessWidget {
  final Color fillColor;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String> onSubmitted;

  const SearchTextField({
    Key? key,
    required this.fillColor,
    required this.hintText,
    required this.onSubmitted, this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          prefixIcon: Image.asset(
            '${Constants.iconsPath}search_tf.png',
            width: 16,
            height: 17,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
          ),
          focusedBorder: _inputBorder,
          disabledBorder: _inputBorder,
          enabledBorder: _inputBorder,
          border: _inputBorder,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          fillColor: const Color(0xffF6F6F6),
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xffCECECE),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onSubmitted: (String text) {
          onSubmitted(text);
        },
      ),
    );
  }

  InputBorder get _inputBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    );
  }
}
