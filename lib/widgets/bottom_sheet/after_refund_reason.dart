import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../theme_button.dart';
import '../theme_text.dart';

typedef AfterReasonCallBack = void Function(String? id, String? name);

class AfterReasonSheetView extends StatefulWidget {
  final bool isType;
  final List types;
  final AfterReasonCallBack callBack;

  const AfterReasonSheetView({
    Key? key,
    required this.types,
    required this.callBack,
    required this.isType,
  }) : super(key: key);

  @override
  State<AfterReasonSheetView> createState() => _AfterReasonSheetViewState();
}

class _AfterReasonSheetViewState extends State<AfterReasonSheetView> {
  int _selectIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 14),
      constraints: BoxConstraints(maxHeight: Constants.safeAreaH - 100),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _topView(),
            ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 40),
                shrinkWrap: true,
                itemCount: widget.types.length,
                itemBuilder: (context, index) {
                  return _payItemView(index);
                }),
            ThemeButton(
              height: 40,
              text: '确定',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              onPressed: () {
                widget.callBack(
                  widget.isType
                      ? (widget.types[_selectIndex]['id'] ?? '').toString()
                      : null,
                  widget.isType
                      ? null
                      : (widget.types[_selectIndex]['name'] ?? '').toString(),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _topView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const ThemeText(
            text: '取消订单', fontWeight: FontWeight.w600, fontSize: 18),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset('${Constants.iconsPath}close.png',
              width: 16, height: 16),
        ),
      ],
    );
  }

  Widget _payItemView(int index) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 25),
      child: Row(
        children: [
          ThemeText(
            text: widget.types[index]['name'] ?? '',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectIndex = index;
              });
            },
            child: Icon(
              _selectIndex == index
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              size: 20,
              color: _selectIndex == index
                  ? const Color(0xffFE734C)
                  : const Color(0xff999999),
            ),
          ),
        ],
      ),
    );
  }
}
