import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import 'package:flutter/cupertino.dart';
import '../../model/search_config_model.dart';

typedef SearchAreaCallback = void Function(String? areaId);

class SearchAreaBottomSheet extends StatefulWidget {
  final List<Data> areaList;
  final SearchAreaCallback callback;

  const SearchAreaBottomSheet({
    Key? key,
    required this.areaList,
    required this.callback,
  }) : super(key: key);

  @override
  State<SearchAreaBottomSheet> createState() => _SearchAreaBottomSheetState();
}

class _SearchAreaBottomSheetState extends State<SearchAreaBottomSheet> {
  final FixedExtentScrollController provinceScrollController =
      FixedExtentScrollController();
  final FixedExtentScrollController cityScrollController =
      FixedExtentScrollController();

  // final FixedExtentScrollController areaScrollController =
  //     FixedExtentScrollController();

  int provinceIndex = 0;
  int cityIndex = 0;

  // int areaIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: Constants.safeAreaH - 100),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _firstView(),
            _contentView(),
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
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
          Widget>[
        TextButton(
          child: const Text('取消'),
          onPressed: () {
            widget.callback(null);
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('确定'),
          onPressed: () {
            String? areaId = widget.areaList[provinceIndex].id;
            if ((widget.areaList[provinceIndex].children ?? []).isNotEmpty) {
              areaId =
                  widget.areaList[provinceIndex].children?[cityIndex].id ?? '';
            }
            widget.callback(areaId ?? '');

            Navigator.pop(context);
          },
        ),
      ]),
    );
  }

  Widget _contentView() {
    return SizedBox(
      height: 200,
      child: Row(
        children: <Widget>[
          Expanded(child: _provincePickerView()),
          Expanded(child: _cityPickerView()),
          // Expanded(child: _areaPickerView()),
        ],
      ),
    );
  }

  Widget _provincePickerView() {
    return CupertinoPicker(
      scrollController: provinceScrollController,
      onSelectedItemChanged: (index) {
        setState(() {
          provinceIndex = index;
          cityIndex = 0;
          if (cityScrollController.positions.isNotEmpty) {
            cityScrollController.jumpTo(0);
          }
          // areaIndex = 0;
          // if (areaScrollController.positions.isNotEmpty) {
          //   areaScrollController.jumpTo(0);
          // }
        });
      },
      itemExtent: 36,
      children: widget.areaList.map((item) {
        return Center(
          child: Text(
            item.name ?? '',
            style: const TextStyle(color: Colors.black87, fontSize: 16),
            maxLines: 1,
          ),
        );
      }).toList(),
    );
  }

  Widget _cityPickerView() {
    return CupertinoPicker(
      scrollController: cityScrollController,
      onSelectedItemChanged: (index) {
        setState(() {
          cityIndex = index;
          // areaIndex = 0;
          // if (areaScrollController.positions.isNotEmpty) {
          //   areaScrollController.jumpTo(0);
          // }
        });
      },
      itemExtent: 36,
      children: (widget.areaList[provinceIndex].children ?? []).map((item) {
        return Center(
          child: Text(
            item.name ?? '',
            style: const TextStyle(color: Colors.black87, fontSize: 16),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
      }).toList(),
    );
  }

// Widget _areaPickerView() {
//   return CupertinoPicker(
//     scrollController: areaScrollController,
//     onSelectedItemChanged: (index) {
//       areaIndex = index;
//     },
//     itemExtent: 36,
//     children:
//         (widget.areaList[provinceIndex].children?[cityIndex].children ?? [])
//             .map((item) {
//       return Center(
//         child: Text(
//           item.name ?? '',
//           style: const TextStyle(color: Colors.black87, fontSize: 14),
//           maxLines: 1,
//         ),
//       );
//     }).toList(),
//   );
// }
}
