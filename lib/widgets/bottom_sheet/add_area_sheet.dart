import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import 'package:flutter/cupertino.dart';
import '../../model/all_area_model.dart';

typedef AddAreaBottomSheetCallback = void Function(
  String areaString,
  // String? quanId,
  String? cityId,
  String? provinceId,
);

class AddAreaBottomSheet extends StatefulWidget {
  final List<Area> areaList;
  final AddAreaBottomSheetCallback callback;

  const AddAreaBottomSheet({
    Key? key,
    required this.areaList,
    required this.callback,
  }) : super(key: key);

  @override
  State<AddAreaBottomSheet> createState() => _AddAreaBottomSheetState();
}

class _AddAreaBottomSheetState extends State<AddAreaBottomSheet> {
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
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('确定'),
          onPressed: () {
            String provinceName = widget.areaList[provinceIndex].name ?? '';
            String cityName = '';
            String cityId = '';
            if ((widget.areaList[provinceIndex].children ?? []).isNotEmpty) {
              cityName =
                  widget.areaList[provinceIndex].children?[cityIndex].name ??
                      '';
              cityId =
                  widget.areaList[provinceIndex].children?[cityIndex].id ?? '';
            }

            String areaString = '$provinceName $cityName';

            // String areaString = '${widget.areaList[provinceIndex].name ?? '省，'}，${widget.areaList[provinceIndex].children?[cityIndex].name ??
            //         '市，'}，${widget.areaList[provinceIndex].children?[cityIndex]
            //             .children?[areaIndex].name ??
            //         '区'}';

            // String quanId = widget.areaList[provinceIndex].children?[cityIndex]
            //         .children?[areaIndex].id ??
            //     '';

            String provinceId = widget.areaList[provinceIndex].id ?? '';

            widget.callback(areaString, cityId, provinceId);

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
