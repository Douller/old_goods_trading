import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/add/publish_sheetItem_child.dart';

import '../../constants/constants.dart';
import '../../model/category_model.dart';
import '../theme_button.dart';
import '../theme_text.dart';

class AddCateGorySheetView extends StatefulWidget {
  final String? sonsId;
  final String? dataId;
  final List<CategoryData> categoryList;

  const AddCateGorySheetView(
      {Key? key, required this.categoryList, this.sonsId, this.dataId})
      : super(key: key);

  @override
  State<AddCateGorySheetView> createState() => _AddCateGorySheetViewState();
}

class _AddCateGorySheetViewState extends State<AddCateGorySheetView> {
  String? sonsId;
  String? dataId;
  String? cateGoryString;

  void _sureBtnClick() {
    Navigator.pop(context, [sonsId, dataId, cateGoryString]);
  }

  @override
  void initState() {
    sonsId = widget.sonsId;
    dataId = widget.dataId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: Constants.safeAreaH - 100),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.categoryList.length,
                itemBuilder: (context, index) {
                  return _itemView(
                    widget.categoryList[index].name ?? '',
                    widget.categoryList[index].sons ?? [],
                    index,
                  );
                }),
            ThemeButton(
              onPressed: _sureBtnClick,
              margin: const EdgeInsets.symmetric(horizontal: 56),
              text: '确定',
              height: 47,
              radius: 16,
            )
          ],
        ),
      ),
    );
  }

  Widget _itemView(String title, List<Sons> dataList, int currIndex) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: ThemeText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: GridView.builder(
                padding: const EdgeInsets.only(top: 17, left: 12),
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
                    onTap: () {
                      setState(() {
                        sonsId = dataList[index].id;
                        dataId = widget.categoryList[currIndex].id;
                        cateGoryString =
                            '${widget.categoryList[currIndex].name}: ${dataList[index].name}';
                      });
                    },
                    child: PublishSheetItemChildView(
                      title: dataList[index].name ?? '',
                      isSelected: sonsId == dataList[index].id,
                    ),
                  );
                }),
          ),
          _checkView(dataId == widget.categoryList[currIndex].id)
        ],
      ),
    );
  }

  Widget _checkView(bool isChoose) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xffE4D719).withOpacity(0.8),
      ),
      child: isChoose
          ? const Icon(
              Icons.check,
              size: 10,
            )
          : Container(),
    );
  }
}
