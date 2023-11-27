import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardExpiryDateWidget extends StatefulWidget {
  const CardExpiryDateWidget({super.key});

  @override
  State<CardExpiryDateWidget> createState() => _CardExpiryDateWidgetState();
}

class _CardExpiryDateWidgetState extends State<CardExpiryDateWidget> {
  List<String> _monthList = [];
  List<String> _yearList = [];

  String _chooseMonth = DateTime.now().month.toString().padLeft(2, '0');
  String _chooseYear = DateTime.now().year.toString();

  void _getMonthList() {
    List<String> data = [];
    if (_chooseYear == DateTime.now().year.toString()) {
      data = List<String>.generate(13 - DateTime.now().month, (int index) {
        int month = DateTime.now().month + index;
        return month < 10 ? '0$month' : '$month';
      });
    } else {
      data = List<String>.generate(12, (int index) {
        int month = index + 1;
        return month < 10 ? '0$month' : '$month';
      });
    }
    setState(() {
      _monthList = data;
    });
  }

  @override
  void initState() {
    _yearList = List<String>.generate(
        2041 - 2023, (int index) => (2023 + index).toString());

    _getMonthList();
    _chooseMonth = _monthList.first.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _firstView(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _pickerView(0, _monthList, (int index) {
                      setState(() {
                        _chooseMonth = _monthList[index].toString();
                      });
                    }),
                  ),
                  Expanded(
                    child: _pickerView(0, _yearList, (int index) {
                      _chooseYear = _yearList[index].toString();
                      _getMonthList();
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _pickerView(int initialItem, List<String> data,
      ValueChanged<int>? onSelectedItemChanged) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: initialItem),
      magnification: 1.0,
      itemExtent: 40,
      looping: true,
      useMagnifier: true,
      backgroundColor: Colors.transparent,
      onSelectedItemChanged: onSelectedItemChanged,
      children: List<Widget>.generate(data.length, (int index) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            data[index].toString(),
            style: const TextStyle(
              color: Color(0xff222222),
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }

  Widget _firstView() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1)),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.pop(context, [_chooseMonth, _chooseYear]);
              },
            ),
          ]),
    );
  }
}
