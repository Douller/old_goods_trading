import 'package:flutter/material.dart';
import 'package:old_goods_trading/utils/toast.dart';
import '../../constants/constants.dart';
import '../../model/category_model.dart';
import '../../net/service_repository.dart';
import '../theme_text.dart';

typedef ClickCallBack = void Function(
  String? name,
  String? title,
  String? categoryId,
  String? sonsId,
);

class PublishCategorySheetView extends StatefulWidget {
  final String? categoryId;
  final String? sonsId;
  final String? describeText;
  final String? categoryText;
  final String? sonsText;
  final ClickCallBack callBack;

  const PublishCategorySheetView(
      {Key? key,
      required this.categoryId,
      required this.describeText,
      this.sonsId,
      this.categoryText,
      this.sonsText,
      required this.callBack})
      : super(key: key);

  @override
  State<PublishCategorySheetView> createState() =>
      _PublishCategorySheetViewState();
}

class _PublishCategorySheetViewState extends State<PublishCategorySheetView> {
  List<CategoryData> _categoryList = [];
  int _selected = 0;
  String _categoryText = '';
  String _sonsText = '';

  final List<CategoryData> _searchList = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> _getData() async {
    CategoryModel? resModel = await ServiceRepository.getMorePublishCategory(
        widget.categoryId, widget.describeText);

    if (resModel != null &&
        resModel.data != null &&
        resModel.data!.isNotEmpty) {
      setState(() {
        _categoryList = resModel.data!;
        for (CategoryData element in _categoryList) {
          if (element.id == widget.categoryId) {
            _selected = _categoryList.indexOf(element);
            _categoryText = element.name ?? '';
            break;
          }
          for (Sons item in (element.sons ?? [])) {
            if (item.id == widget.categoryId) {
              _selected = _categoryList.indexOf(element);
              _categoryText = element.name ?? '';
              _sonsText = item.name ?? '';
              break;
            }
          }
        }
      });
    } else {
      if (!mounted) return;
      ToastUtils.showText(text: '获取数据失败');
      Navigator.pop(context);
    }
  }

  void _searchRefresh(String text) {
    if (_controller.text.isEmpty) {
      _searchList.clear();
    } else {
      for (CategoryData element in _categoryList) {
        if (element.name!.contains(text)) {
          if (!_searchList.contains(element)) {
            _searchList.add(element);
          }
          continue;
        }

        for (Sons item in (element.sons ?? [])) {
          if (item.name!.contains(text)) {
            if (!_searchList.contains(element)) {
              _searchList.add(element);
            }
          }
        }
      }
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      _searchRefresh(_controller.text);
    });
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _categoryText = widget.categoryText ?? '';
    _sonsText = widget.sonsText ?? '';
    _controller.addListener(() {
      _searchRefresh(_controller.text);
    });
    _getData();
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
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: Colors.white),
        constraints: BoxConstraints(maxHeight: Constants.safeAreaH - 100),
        child: Column(
          children: [
            _topView(),
            _customSearchView(),
            const SizedBox(height: 12),
            _searchList.isNotEmpty ? Container() : _chooseCategoryView(),
            _searchList.isNotEmpty
                ? _searchListView()
                : Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _categoryLabelList(),
                        _categoryGoods(),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _topView() {
    return Container(
      height: 66,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const ThemeText(
                text: '选择分类',
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
                if (_searchList.isEmpty) {
                  ToastUtils.showText(text: '未找到相关品牌');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chooseCategoryView() {
    return Container(
      padding: const EdgeInsets.only(left: 24),
      height: 50,
      child: Row(
        children: [
          ThemeText(
            text: _categoryText,
            color: const Color(0xffFE734C),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          const Icon(
            Icons.arrow_right,
            color: Color(0xffFE734C),
            size: 16,
          ),
          ThemeText(
            text: _sonsText,
            color: const Color(0xffFE734C),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  ///左侧分类选择
  Widget _categoryLabelList() {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight:
                  Constants.safeAreaH - 166 - 36 - 24 - Constants.bottomBarH,
            ),
            height: _categoryList.length * 50,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: _categoryList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selected = index;
                    });
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selected == index
                          ? Colors.white
                          : const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.only(
                        topRight: index == 0 ||
                                (_selected < 10 && index == _selected + 1)
                            ? const Radius.circular(10)
                            : const Radius.circular(0),
                        bottomRight: _selected > 0 && index == _selected - 1
                            ? const Radius.circular(10)
                            : const Radius.circular(0),
                      ),
                    ),
                    child: ThemeText(
                      text: _categoryList[index].name ?? '',
                      fontSize: _selected == index ? 16 : 14,
                      fontWeight: _selected == index
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffF6F6F6),
                borderRadius: BorderRadius.only(
                  topRight: _selected == _categoryList.length - 1
                      ? const Radius.circular(10)
                      : const Radius.circular(0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///右侧商品分类
  Widget _categoryGoods() {
    return _categoryList.isEmpty ||
            (_categoryList[_selected].sons ?? []).isEmpty
        ? Container()
        : Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: (_categoryList[_selected].sons ?? []).length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.callBack(
                        _categoryList[_selected].sons?[index].name,
                        '分类',
                        _categoryList[_selected].id,
                        _categoryList[_selected].sons?[index].id,
                      );
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 50),
                      child: ThemeText(
                        text: _categoryList[_selected].sons?[index].name ?? "",
                        fontWeight: FontWeight.w600,
                        color: _categoryList[_selected].sons?[index].name ==
                                _sonsText
                            ? const Color(0xffFE734C)
                            : const Color(0xff2F3033),
                      ),
                    ),
                  );
                }),
          );
  }

  Widget _searchListView() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20),
        itemCount: _searchList.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(left: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ThemeText(
                  text: _searchList[index].name ?? '',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    children: List.generate(
                      (_searchList[index].sons ?? []).length,
                      (i) {
                        return GestureDetector(
                          onTap: () {
                            widget.callBack(
                                _searchList[index].sons![i].name,
                                '分类',
                                _searchList[index].id,
                                _searchList[index].sons![i].id);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: ThemeText(
                                text: _searchList[index].sons![i].name ?? ''),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  InputBorder get _inputBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    );
  }
}
