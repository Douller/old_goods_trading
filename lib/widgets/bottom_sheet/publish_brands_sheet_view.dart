import 'package:flutter/material.dart';
import 'package:old_goods_trading/utils/toast.dart';

import '../../constants/constants.dart';
import '../../model/add_publish_info_model.dart';
import '../../net/service_repository.dart';
import '../theme_text.dart';

typedef ClickCallBack = void Function(
  String? name,
  String? title,
  String? brandId,
);

class PublishBrandsSheetView extends StatefulWidget {
  final String? categoryId;
  final String? describeText;
  final String? brandId;
  final ClickCallBack callBack;

  const PublishBrandsSheetView(
      {Key? key,
      this.categoryId,
      this.describeText,
      this.brandId,
      required this.callBack})
      : super(key: key);

  @override
  State<PublishBrandsSheetView> createState() => _PublishBrandsSheetViewState();
}

class _PublishBrandsSheetViewState extends State<PublishBrandsSheetView> {
  List<Brands> _brandsList = [];

  final List<Brands> _searchTextList = [];

  final TextEditingController _controller = TextEditingController();

  Future<void> _getData() async {
    List<Brands> resList = await ServiceRepository.getMorePublishBrands(
        widget.categoryId, widget.describeText);
    if (resList.isNotEmpty) {
      setState(() {
        _brandsList = resList;
      });
    }
  }

  @override
  void initState() {
    _getData();
    _controller.addListener(() {
      setState(() {
        if (_controller.text.isEmpty) {
          _searchTextList.clear();
        } else {
          for (Brands element in _brandsList) {
            if (element.name!.contains(_controller.text)) {
              if (!_searchTextList.contains(element)) {
                _searchTextList.add(element);
              }
            }
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: Constants.safeAreaH - 100),
        child: Column(
          children: [
            _topView(),
            _customSearchView(),
            Expanded(
              child: _searchTextList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _searchTextList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  widget.callBack(_searchTextList[index].name,
                                      '品牌', _searchTextList[index].id);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 16),
                                  child: ThemeText(
                                    text: _searchTextList[index].name ?? '',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: const Color(0xff2F3033),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: _brandsList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ThemeText(
                                text: _brandsList[index].slug ?? '',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.callBack(_brandsList[index].name, '品牌',
                                      _brandsList[index].id);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 16),
                                  child: ThemeText(
                                    text: _brandsList[index].name ?? '',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color:
                                        _brandsList[index].id == widget.brandId
                                            ? const Color(0xffFE734C)
                                            : const Color(0xff2F3033),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _topView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      height: 66,
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const ThemeText(
                text: '选择品牌',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              '${Constants.iconsPath}close.png',
              width: 14,
              height: 14,
            ),
          ),
        ],
      ),
    );
  }

  ///顶部搜索框
  Widget _customSearchView() {
    return Container(
      height: 36,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: Image.asset(
                  '${Constants.iconsPath}search_tf.png',
                  width: 16,
                  height: 17,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                ),
                focusedBorder: _inputBorder,
                disabledBorder: _inputBorder,
                enabledBorder: _inputBorder,
                border: _inputBorder,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                fillColor: const Color(0xffF6F6F6),
                filled: true,
                hintText: '搜索想卖的宝贝',
                hintStyle: const TextStyle(
                  color: Color(0xffCECECE),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onSubmitted: (text) {
                if (_searchTextList.isEmpty) {
                  ToastUtils.showText(text: '未找到相关品牌');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  InputBorder get _inputBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    );
  }
}
