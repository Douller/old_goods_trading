import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../states/category_page_state.dart';
import '../../widgets/category_widgets/category_top_bar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryState _categoryState = CategoryState();
  int _selected = 0;

  @override
  void initState() {
    _categoryState.getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _categoryState,
      child: Scaffold(
        backgroundColor: const Color(0xffFAFAFA),
        body: SafeArea(
          child: Column(
            children: [
              const CategoryTopBar(),
              Expanded(
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
      ),
    );
  }

  ///左侧分类选择
  Widget _categoryLabelList() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: 96,
      child: Consumer<CategoryState>(
          builder: (BuildContext context, value, Widget? child) {
        return ListView.builder(
          itemCount: value.categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _selected = index;
                });
              },
              child: Container(
                height: 38,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: _selected == index
                        ? const Color(0xffE4D719)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16)),
                child: ThemeText(
                  text: value.categoryList[index].name ?? '',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  ///右侧商品分类
  Widget _categoryGoods() {
    return Consumer<CategoryState>(
        builder: (BuildContext context, value, Widget? child) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          margin: const EdgeInsets.only(bottom: 15, right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: (value.categoryList.isEmpty ||
                  value.categoryList[_selected].sons == null ||
                  value.categoryList[_selected].sons!.isEmpty)
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const ThemeText(
                      text: '精选推荐',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    Container(
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.fromBorderSide(
                          BorderSide(
                              color: const Color(0xffE4D719).withOpacity(0.8)),
                        ),
                      ),
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 12, left: 8, right: 8),
                      child: GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          physics: const BouncingScrollPhysics(),
                          itemCount: value.categoryList[_selected].sons?.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 30,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                String? text = value
                                    .categoryList[_selected].sons?[index].name;
                                if (text != null) {
                                  value.pushSearchResult(
                                    context,
                                    text,
                                    null,
                                    value.categoryList[_selected].id,
                                    value.categoryList[_selected].sons?[index]
                                        .id,
                                  );
                                }
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: ThemeNetImage(
                                        imageUrl: value.categoryList[_selected]
                                            .sons?[index].icon,
                                        placeholderPath:
                                            '${Constants.placeholderPath}goods_placeholder.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    value.categoryList[_selected].sons?[index]
                                            .name ??
                                        '',
                                    style: const TextStyle(
                                      color: Color(0xff484C52),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
        ),
      );
    });
  }
// return Expanded(
//   child: ListView(
//     children: [
//       // (value.categoryList.isEmpty ||
//       //         value.categoryList[_selected].advs == null ||
//       //         value.categoryList[_selected].advs!.isEmpty)
//       //     ? Container()
//       //     : ClipRRect(
//       //         borderRadius: BorderRadius.circular(10),
//       //         child: Container(
//       //           color: Colors.white,
//       //           height: 80,
//       //           child: Swiper(
//       //             itemCount: value.categoryList[_selected].advs!.length,
//       //             autoplay: true,
//       //             duration: 500,
//       //             itemBuilder: (context, index) {
//       //               return ThemeNetImage(
//       //                 imageUrl: value
//       //                     .categoryList[_selected].advs![index].image,
//       //                 fit: BoxFit.cover,
//       //               );
//       //             },
//       //           ),
//       //         )),
//       // const SizedBox(height: 10),
//       // (value.categoryList.isEmpty ||
//       //         value.categoryList[_selected].brands == null ||
//       //         value.categoryList[_selected].brands!.isEmpty)
//       //     ? Container()
//       //     : const ThemeText(
//       //         text: '热卖品牌',
//       //         fontWeight: FontWeight.w700,
//       //         fontSize: 16,
//       //       ),
//       // (value.categoryList.isEmpty ||
//       //         value.categoryList[_selected].brands == null ||
//       //         value.categoryList[_selected].brands!.isEmpty)
//       //     ? Container()
//       //     : Container(
//       //         decoration: BoxDecoration(
//       //           borderRadius: BorderRadius.circular(10),
//       //           color: Colors.white,
//       //         ),
//       //         margin: const EdgeInsets.only(top: 12),
//       //         padding: const EdgeInsets.only(
//       //             top: 12, bottom: 12, left: 8, right: 8),
//       //         child: GridView.builder(
//       //             shrinkWrap: true,
//       //             physics: const NeverScrollableScrollPhysics(),
//       //             itemCount: value.categoryList[_selected].brands?.length,
//       //             gridDelegate:
//       //                 const SliverGridDelegateWithFixedCrossAxisCount(
//       //               crossAxisCount: 3,
//       //               crossAxisSpacing: 5,
//       //               mainAxisSpacing: 16,
//       //             ),
//       //             itemBuilder: (context, index) {
//       //               return GestureDetector(
//       //                 behavior: HitTestBehavior.opaque,
//       //                 onTap: () {
//       //                   String? text = value
//       //                       .categoryList[_selected].brands?[index].name;
//       //                   if (text != null) {
//       //                     value.pushSearchResult(
//       //                       context,
//       //                       text,
//       //                       value.categoryList[_selected].brands?[index]
//       //                           .id,
//       //                       value.categoryList[_selected].id,
//       //                       null,
//       //                     );
//       //                   }
//       //                 },
//       //                 child: Column(
//       //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //                   children: [
//       //                     Expanded(
//       //                       child: Container(
//       //                         alignment: Alignment.center,
//       //                         margin: const EdgeInsets.only(bottom: 5),
//       //                         child: ThemeNetImage(
//       //                           imageUrl: value.categoryList[_selected]
//       //                               .brands?[index].icon,
//       //                           placeholderPath:
//       //                               '${Constants.placeholderPath}goods_placeholder.png',
//       //                           fit: BoxFit.cover,
//       //                         ),
//       //                       ),
//       //                     ),
//       //                     Text(
//       //                       value.categoryList[_selected].brands?[index]
//       //                               .name ??
//       //                           '',
//       //                       style: const TextStyle(
//       //                         color: Color(0xff666666),
//       //                         fontSize: 12,
//       //                         fontWeight: FontWeight.w500,
//       //                       ),
//       //                     )
//       //                   ],
//       //                 ),
//       //               );
//       //             }),
//       //       ),
//       // const SizedBox(height: 20),
//       (value.categoryList.isEmpty ||
//               value.categoryList[_selected].sons == null ||
//               value.categoryList[_selected].sons!.isEmpty)
//           ? Container()
//           : const ThemeText(
//               text: '精选推荐',
//               fontWeight: FontWeight.w700,
//               fontSize: 16,
//             ),
//       (value.categoryList.isEmpty ||
//               value.categoryList[_selected].sons == null ||
//               value.categoryList[_selected].sons!.isEmpty)
//           ? Container()
//           : Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white,
//               ),
//               margin: const EdgeInsets.only(top: 12),
//               padding: const EdgeInsets.only(
//                   top: 12, bottom: 12, left: 8, right: 8),
//               child: GridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: value.categoryList[_selected].sons?.length,
//                   gridDelegate:
//                       const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 5,
//                     mainAxisSpacing: 16,
//                   ),
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () {
//                         String? text = value
//                             .categoryList[_selected].sons?[index].name;
//                         if (text != null) {
//                           value.pushSearchResult(
//                             context,
//                             text,
//                             null,
//                             value.categoryList[_selected].id,
//                             value.categoryList[_selected].sons?[index].id,
//                           );
//                         }
//                       },
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               alignment: Alignment.center,
//                               margin: const EdgeInsets.only(bottom: 5),
//                               child: ThemeNetImage(
//                                 imageUrl: value.categoryList[_selected]
//                                     .sons?[index].icon,
//                                 placeholderPath:
//                                     '${Constants.placeholderPath}goods_placeholder.png',
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             value.categoryList[_selected].sons?[index]
//                                     .name ??
//                                 '',
//                             style: const TextStyle(
//                               color: Color(0xff666666),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           )
//                         ],
//                       ),
//                     );
//                   }),
//             ),
//     ],
//   ),
// );
//   });
// }
}
