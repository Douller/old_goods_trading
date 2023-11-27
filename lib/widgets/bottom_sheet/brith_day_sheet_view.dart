import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

typedef AddAreaBottomSheetCallback = void Function(String dateString);

class BrithDaySheetView extends StatefulWidget {
  final String? brithStr;
  final bool isSex;
  final AddAreaBottomSheetCallback callback;

  const BrithDaySheetView(
      {Key? key, this.brithStr, required this.callback, this.isSex = false})
      : super(key: key);

  @override
  State<BrithDaySheetView> createState() => _BrithDaySheetViewState();
}

class _BrithDaySheetViewState extends State<BrithDaySheetView> {
  DateTime? _chooseDateTime;
  String sex = '';

  @override
  void initState() {
    if ((widget.brithStr ?? '').isNotEmpty) {
      List<String> dateList = widget.brithStr!.split('-');
      if (dateList.length < 3) return;

      String monthStr = dateList[1];
      String dayStr = dateList[2];
      if (int.parse(dateList[1]) < 10 && monthStr.length == 1) {
        monthStr = '0$monthStr';
      }
      if (int.parse(dateList[2]) < 10 && dayStr.length == 1) {
        dayStr = '0$dayStr';
      }
      String dateString = '${dateList[0]}-$monthStr-$dayStr';

      _chooseDateTime = DateTime.parse(dateString);
    } else {
      _chooseDateTime = DateTime.now();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _firstView(),
            widget.isSex ? _sexContentView() : _contentView(),
          ],
        ),
      ),
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
                if(widget.isSex){
                  widget.callback(sex);
                }else{
                  String month = _chooseDateTime!.month < 10
                      ? '0${_chooseDateTime!.month}'
                      : _chooseDateTime!.month.toString();
                  String day = _chooseDateTime!.day < 10
                      ? '0${_chooseDateTime!.day}'
                      : _chooseDateTime!.day.toString();
                  String date = '${_chooseDateTime!.year}-$month-$day';
                  widget.callback(date);
                }

                Navigator.pop(context);
              },
            ),
          ]),
    );
  }

  Widget _contentView() {
    return Expanded(
      child: CupertinoTheme(
        data: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(fontSize: 16),
        )),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _chooseDateTime,
          minimumDate: DateTime(1900),
          maximumDate: DateTime.now(),
          minimumYear: 1900,
          maximumYear: DateTime.now().year,
          use24hFormat: true,
          dateOrder: DatePickerDateOrder.ymd,
          backgroundColor: Colors.white,
          onDateTimeChanged: (dateTime) {
            _chooseDateTime = dateTime;
          },
        ),
      ),
    );
  }

  Widget _sexContentView() {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 28,
        onSelectedItemChanged: (position) {
          sex = position == 0 ? '男' : '女';
        },
        children: const [
          ThemeText(text: '男'),
          ThemeText(text: '女'),
        ],
      ),
    );
  }
}
