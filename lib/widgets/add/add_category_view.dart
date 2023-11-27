// import 'package:flutter/material.dart';
// import 'package:old_goods_trading/states/add_page_state.dart';
// import 'package:provider/provider.dart';
//
// import '../../constants/constants.dart';
// import '../theme_text.dart';
//
// class AddCateGoryView extends StatelessWidget {
//   const AddCateGoryView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AddPageViewModel>(
//       builder: (BuildContext context, value, Widget? child) {
//         return value.publishCategoryList.isEmpty
//             ? Container()
//             : Column(
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(
//                         '${Constants.iconsPath}add_menu.png',
//                         width: 22,
//                         height: 22,
//                       ),
//                       const SizedBox(width: 10),
//                       const ThemeText(
//                         text: '分类/品牌/成色/等',
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                       ),
//                     ],
//                   ),
//                   _categoryItem('分类', value.publishCategoryList),
//                   _categoryItem('品牌', value.model?.brands ?? []),
//                   _categoryItem('成色', value.model?.brushingCondition ?? []),
//                 ],
//               );
//       },
//     );
//   }
//
//   Widget _categoryItem(String title, List data) {
//     return data.isEmpty
//         ? Container()
//         : Consumer<AddPageViewModel>(
//             builder: (BuildContext context, value, Widget? child) {
//               return Container(
//                 margin: const EdgeInsets.only(top: 20, left: 32),
//                 height: 30,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ThemeText(
//                       text: title,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         shrinkWrap: true,
//                         itemCount:
//                             title == '成色' ? data.length : data.length + 1,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             behavior: HitTestBehavior.opaque,
//                             onTap: () {
//                               // if (index < data.length &&
//                               //     (data[index].name ?? '').isNotEmpty) {
//                               //   value.addCategoryItem(
//                               //       name: data[index].name,
//                               //       title: title,
//                               //       id: (data[index].id).toString());
//                               // } else {
//                               //   // value.pushBottomSheetView(context, title);
//                               // }
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(left: 12),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 11, vertical: 4),
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(60),
//                                 color: index == data.length
//                                     ? Colors.white
//                                     : _itemBgColor(
//                                         value.categoryList,
//                                         data[index].name,
//                                         data[index].id.toString(),
//                                         title,
//                                       ),
//                                 border: Border.all(
//                                   color: index == data.length
//                                       ? const Color(0xff2F3033)
//                                       : Colors.transparent,
//                                 ),
//                               ),
//                               child: ThemeText(
//                                 text: index == data.length
//                                     ? '+更多选项'
//                                     : data[index].name ?? '',
//                                 color: index == data.length
//                                     ? const Color(0xff2F3033)
//                                     : _itemTextColor(
//                                         value.categoryList,
//                                         data[index].name,
//                                         data[index].id.toString(),
//                                         title,
//                                       ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//   }
//
//   Color? _itemBgColor(List categoryList, String name, String id, String title) {
//     Color? color;
//     for (var element in categoryList) {
//       if (title == '分类') {
//         if (element['name'] == name && id == element['id']) {
//           color = const Color(0xffFE734C).withOpacity(0.1);
//         }
//       } else if (title == '品牌') {
//         // if (id == element['id']) {
//         //   color = const Color(0xffFE734C).withOpacity(0.1);
//         // }
//         if (element['name'] == name && id == element['id']) {
//           color = const Color(0xffFE734C).withOpacity(0.1);
//         }
//       } else {
//         if (name == element['name']) {
//           color = const Color(0xffFE734C).withOpacity(0.1);
//         }
//       }
//     }
//     return color ?? const Color(0xff999999).withOpacity(0.1);
//   }
//
//   Color? _itemTextColor(
//       List categoryList, String name, String id, String title) {
//     Color? color;
//     for (var element in categoryList) {
//       if (title == '分类') {
//         if (element['name'] == name && id == element['id']) {
//           color = const Color(0xffFE734C);
//         }
//       } else if (title == '品牌') {
//         // if (id == element['id']) {
//         //   color = const Color(0xffFE734C);
//         // }
//         if (element['name'] == name && id == element['id']) {
//           color = const Color(0xffFE734C);
//         }
//       } else {
//         if (name == element['name']) {
//           color = const Color(0xffFE734C);
//         }
//       }
//     }
//     return color ?? const Color(0xff999999);
//   }
// }
