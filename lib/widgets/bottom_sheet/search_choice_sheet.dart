import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../model/search_config_model.dart';

typedef SearchChoiceCallback = void Function(List chooseList);

class SearchChoiceBottomSheet extends StatefulWidget {
  final List<Data> choiceList;
  final List chooseList;
  final SearchChoiceCallback callback;

  const SearchChoiceBottomSheet(
      {Key? key,
      required this.choiceList,
      required this.callback,
      required this.chooseList})
      : super(key: key);

  @override
  State<SearchChoiceBottomSheet> createState() =>
      _SearchChoiceBottomSheetState();
}

class _SearchChoiceBottomSheetState extends State<SearchChoiceBottomSheet> {
  List _chooseList = [];
  final List _selectedKeyList = [];

  @override
  void initState() {
    setState(() {
      _chooseList = widget.chooseList;
      if (_chooseList.isNotEmpty) {
        for (var element in _chooseList) {
          _selectedKeyList.add(element['key']);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      constraints: BoxConstraints(maxHeight: Constants.safeAreaH - 100),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.choiceList.length,
                  itemBuilder: (context, index) {
                    return _choiceCell(index);
                  }),
            ),
            Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _selectedKeyList.clear();
                      _chooseList.clear();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: const Color(0xff999999))),
                    alignment: Alignment.center,
                    child: const Text(
                      '重置',
                      style: TextStyle(
                        color: Color(0xff2F3033),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.callback(_chooseList);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xffFE734C),
                      ),
                      child: const Text(
                        '确认',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceCell(int lastIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.choiceList[lastIndex].name ?? '',
          style: const TextStyle(
            color: Color(0xff2F3033),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 14),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 14,
            mainAxisSpacing: 12,
          ),
          itemCount: widget.choiceList[lastIndex].data?.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                String? key = widget.choiceList[lastIndex].key;
                String? id = widget.choiceList[lastIndex].data?[index].id;
                Map map = {'key': key, 'id': id};
                _chooseList.removeWhere((element) => element['key'] == key);
                if (!_selectedKeyList.contains(key)) {
                  _selectedKeyList.add(key);
                }
                setState(() {
                  _chooseList.add(map);
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: _itemBgColor(lastIndex, index),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.choiceList[lastIndex].data?[index].name ?? '',
                      style: TextStyle(
                        color: _itemTextColor(lastIndex, index),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    (widget.choiceList[lastIndex].data?[index].subName ?? '')
                            .isEmpty
                        ? Container()
                        : Text(
                            widget.choiceList[lastIndex].data?[index].subName ??
                                '',
                            style: const TextStyle(
                              color: Color(0xff999999),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Color? _itemBgColor(int lastIndex, int index) {
    Color? color;
    String? key = widget.choiceList[lastIndex].key;
    String? id = widget.choiceList[lastIndex].data?[index].id;

    if (_selectedKeyList.contains(key)) {
      for (var element in _chooseList) {
        if (element['key'] == key && element['id'] == id) {
          color = const Color(0xffFE734C).withOpacity(0.2);
        }
      }
    }
    return color ?? const Color(0xffF6F6F6);
  }

  Color? _itemTextColor(int lastIndex, int index) {
    Color? color;
    String? key = widget.choiceList[lastIndex].key;
    String? id = widget.choiceList[lastIndex].data?[index].id;

    if (_selectedKeyList.contains(key)) {
      for (var element in _chooseList) {
        if (element['key'] == key && element['id'] == id) {
          color = const Color(0xffFE734C);
        }
      }
    }
    return color ?? const Color(0xff2F3033);
  }
}
