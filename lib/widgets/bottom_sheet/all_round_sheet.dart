import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../model/search_config_model.dart';

typedef AllRoundBottomCallback = void Function(String selectedId, String name);

class AllRoundBottomSheetView extends StatefulWidget {
  final List<Data> allRoundList;
  final List selectedList;
  final AllRoundBottomCallback callback;

  const AllRoundBottomSheetView({
    Key? key,
    required this.allRoundList,
    required this.selectedList,
    required this.callback,
  }) : super(key: key);

  @override
  State<AllRoundBottomSheetView> createState() =>
      _AllRoundBottomSheetViewState();
}

class _AllRoundBottomSheetViewState extends State<AllRoundBottomSheetView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: Constants.safeAreaH - 100),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.allRoundList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              widget.callback(widget.allRoundList[index].id ?? '',
                  widget.allRoundList[index].name ?? '');
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.center,
              height: 40,
              child: Text(
                widget.allRoundList[index].name ?? '',
                style: TextStyle(
                  color: (widget.selectedList.isNotEmpty &&
                          widget.selectedList.first['id'] ==
                              widget.allRoundList[index].id)
                      ? const Color(0xffFE734C)
                      : const Color(0xff2F3033),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
