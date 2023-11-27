import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/add/publish_sheetItem_child.dart';

import '../../model/add_publish_info_model.dart';
import '../theme_text.dart';

typedef UserAndTimeItemChooseCallback = void Function(
    String timeChoose, String useChoose);

class TimeAndUserItemView extends StatefulWidget {
  final AddPublishInfoModel? model1;
  final String? brushingConditionSel; //使用程度
  final String? purchaseTimeSel; //购入时间
  final UserAndTimeItemChooseCallback callback;

  const TimeAndUserItemView({
    Key? key,
    this.model1,
    required this.callback,
    this.brushingConditionSel,
    this.purchaseTimeSel,
  }) : super(key: key);

  @override
  State<TimeAndUserItemView> createState() => _TimeAndUserItemViewState();
}

class _TimeAndUserItemViewState extends State<TimeAndUserItemView> {
  List<BrushingCondition> timeChooseList = [];
  List<BrushingCondition> useChooseList = [];

  void _itemTimeSel(brushingConditionModel) {
    setState(() {
      timeChooseList.clear();
      timeChooseList.add(brushingConditionModel);
    });
    widget.callback(timeChooseList.first.name ?? '',
        useChooseList.isEmpty ? '' : useChooseList.first.name ?? '');
  }

  void _itemUseSel(brushingConditionModel) {
    setState(() {
      useChooseList.clear();
      useChooseList.add(brushingConditionModel);
    });
    widget.callback(
        timeChooseList.isEmpty ? '' : timeChooseList.first.name ?? '',
        useChooseList.first.name ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _itemView('购入时间', widget.model1?.purchaseTime ?? []),
        const SizedBox(height: 9),
        _itemView('使用程度', widget.model1?.brushingCondition ?? []),
        const SizedBox(height: 13),
      ],
    );
  }

  Widget _itemView(String title, List<BrushingCondition> dataList) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThemeText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(width: 30),
          Expanded(
            child: GridView.builder(
                padding: const EdgeInsets.only(top: 17),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  childAspectRatio: 86 / 22,
                ),
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => title == '购入时间'
                        ? _itemTimeSel(dataList[index])
                        : _itemUseSel(dataList[index]),
                    child: PublishSheetItemChildView(
                      title: dataList[index].name ?? '',
                      isSelected: title == '购入时间'
                          ? timeChooseList.isEmpty
                              ? widget.purchaseTimeSel == dataList[index].name
                              : timeChooseList.contains(dataList[index])
                          : useChooseList.isEmpty
                              ? widget.brushingConditionSel ==
                                  dataList[index].name
                              : useChooseList.contains(dataList[index]),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
