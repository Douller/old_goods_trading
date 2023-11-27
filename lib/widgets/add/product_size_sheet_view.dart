import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

import '../../constants/constants.dart';
import '../../model/add_publish_info_model.dart';

typedef BoxSizeCallback = void Function(String sizeName);

class ProductSizeSheetView extends StatefulWidget {
  final AddPublishInfoModel? addPublishInfoModel;
  final String sizeName;
  final BoxSizeCallback callback;

  const ProductSizeSheetView(
      {Key? key,
      this.addPublishInfoModel,
      required this.sizeName,
      required this.callback})
      : super(key: key);

  @override
  State<ProductSizeSheetView> createState() => _ProductSizeSheetViewState();
}

class _ProductSizeSheetViewState extends State<ProductSizeSheetView> {
  String _sizeName = '';

  @override
  void initState() {
    _sizeName = widget.sizeName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 60),
      height: (widget.addPublishInfoModel?.boxSize ?? []).length * 60 + 30 * 3,
      constraints: BoxConstraints(maxHeight: Constants.safeAreaH - 220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const ThemeText(
            text: '你的产品尺寸?',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 38),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: (widget.addPublishInfoModel?.boxSize ?? []).length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 22),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _sizeName =
                              (widget.addPublishInfoModel?.boxSize ?? [])[index]
                                      .name ??
                                  '';
                        });
                        widget.callback(_sizeName);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ThemeText(
                                  text: (widget.addPublishInfoModel?.boxSize ??
                                              [])[index]
                                          .name ??
                                      '',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(height: 4),
                                ThemeText(
                                  text: (widget.addPublishInfoModel?.boxSize ??
                                              [])[index]
                                          .subName ??
                                      '',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      const Color(0xff484C52).withOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: _sizeName ==
                                      ((widget.addPublishInfoModel?.boxSize ??
                                                  [])[index]
                                              .name ??
                                          '')
                                  ? const Color(0xffE4D719).withOpacity(0.8)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color:
                                      const Color(0xffE4D719).withOpacity(0.8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
