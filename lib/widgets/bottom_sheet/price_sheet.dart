import 'package:flutter/material.dart';
import '../../model/search_config_model.dart';

typedef PriceBottomCallback = void Function(
    String? minPrice, String? maxPrice, String? selectedId);

class PriceBottomSheetView extends StatefulWidget {
  final List<Data> priceList;
  final List selectedList;
  final String? minPrice;
  final String? maxPrice;
  final PriceBottomCallback callback;

  const PriceBottomSheetView({
    Key? key,
    required this.priceList,
    required this.selectedList,
    required this.callback,
    this.minPrice,
    this.maxPrice,
  }) : super(key: key);

  @override
  State<PriceBottomSheetView> createState() => _PriceBottomSheetViewState();
}

class _PriceBottomSheetViewState extends State<PriceBottomSheetView> {
  final TextEditingController minPriceEC = TextEditingController();

  final TextEditingController maxPriceEC = TextEditingController();

  String _priceStr = '';
  String? _priceId;

  void _priceBtnClick(String price) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _priceStr = price;
      minPriceEC.text = '0';
      maxPriceEC.text = price.substring(0, price.length - 3);
    });
  }

  void _reset() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _priceStr = '';
      minPriceEC.text = '';
      maxPriceEC.text = '';
      widget.selectedList.clear();
    });
    widget.callback('', '', _priceId);
  }

  void _save() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_priceStr.isNotEmpty) {
      widget.callback('', '', _priceId);
    } else {
      widget.callback(minPriceEC.text.trim(), maxPriceEC.text.trim(), _priceId);
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    minPriceEC.text = widget.minPrice ?? '';
    maxPriceEC.text = widget.maxPrice ?? '';

    minPriceEC.addListener(() {
      String minPrice = minPriceEC.text.trim();
      if (_priceStr.length > 3 && (num.tryParse(minPrice) ?? 0) > 0) {
        setState(() {
          _priceStr = '';
        });
      }
    });
    maxPriceEC.addListener(() {
      String maxPrice = maxPriceEC.text.trim();
      if (_priceStr.length > 3 &&
          maxPrice != _priceStr.substring(0, _priceStr.length - 3)) {
        setState(() {
          _priceStr = '';
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    minPriceEC.dispose();
    maxPriceEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: Duration.zero,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '价格区间',
                  style: TextStyle(
                    color: Color(0xff2F3033),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _textFieldView(hintText: '最低价', controller: minPriceEC),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      color: const Color(0xffCECECE),
                      height: 1,
                      width: 17,
                    ),
                    _textFieldView(hintText: '最高价', controller: maxPriceEC),
                  ],
                ),
                GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: widget.priceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _priceBtnClick(widget.priceList[index].name ?? '');
                          _priceId = widget.priceList[index].id;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: _priceStr.isEmpty
                                ? (widget.selectedList.isNotEmpty &&
                                        widget.selectedList.first['id'] ==
                                            widget.priceList[index].id)
                                    ? const Color(0xffFE734C).withOpacity(0.2)
                                    : const Color(0xffF6F6F6)
                                : _priceStr == widget.priceList[index].name
                                    ? const Color(0xffFE734C).withOpacity(0.2)
                                    : const Color(0xffF6F6F6),
                          ),
                          child: Text(
                            widget.priceList[index].name ?? '',
                            style: TextStyle(
                              color: _priceStr.isEmpty
                                  ? (widget.selectedList.isNotEmpty &&
                                          widget.selectedList.first['id'] ==
                                              widget.priceList[index].id)
                                      ? const Color(0xffFE734C)
                                      : const Color(0xff2F3033)
                                  : _priceStr == widget.priceList[index].name
                                      ? const Color(0xffFE734C)
                                      : const Color(0xff2F3033),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _reset,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: const Color(0xff999999)),
                        ),
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
                        onTap: _save,
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
        ),
      ),
    );
  }

  Widget _textFieldView({String? hintText, TextEditingController? controller}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xffF6F6F6),
          ),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff2F3033),
          ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration.collapsed(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xffCECECE),
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
    );
  }
}
