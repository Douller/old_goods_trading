// import 'package:flutter/material.dart';
// import 'package:old_goods_trading/router/app_router.dart';
// import 'package:provider/provider.dart';
// import '../../constants/constants.dart';
//
// import '../../model/order_buy_confirm_model.dart';
// import '../../page/mine/add_address_page.dart';
// import '../../states/my_address_state.dart';
// import '../theme_text.dart';
//
// typedef ChooseModelCallBack = void Function(AddressModelInfo? chooseModel);
//
// class AddressListCell extends StatelessWidget {
//   final bool isSelect;
//   final AddressModelInfo addressModel;
//   final AddressModelInfo? selectModel;
//   final VoidCallback? onPressed;
//   final ChooseModelCallBack chooseCallBack;
//
//   const AddressListCell({
//     Key? key,
//     required this.addressModel,
//     this.onPressed,
//     required this.isSelect,
//     this.selectModel,
//     required this.chooseCallBack,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MyAddressViewModel>(
//       builder: (BuildContext context, value, Widget? child) {
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           physics: const NeverScrollableScrollPhysics(),
//           child: Row(
//             children: [
//               value.isEdit
//                   ? IconButton(
//                       onPressed: () => value.itemClick(addressModel),
//                       icon: Icon(
//                         value.deleteChooseList.contains(addressModel)
//                             ? Icons.check_circle
//                             : Icons.radio_button_unchecked,
//                         color: value.deleteChooseList.contains(addressModel)
//                             ? const Color(0xffFE734C)
//                             : const Color(0xff999999),
//                         size: 20,
//                       ),
//                     )
//                   : Container(),
//               Container(
//                 width: Constants.screenWidth - 24,
//                 padding: const EdgeInsets.only(bottom: 28),
//                 child: Row(
//                   children: [
//                     if (selectModel != null &&
//                         isSelect == true &&
//                         selectModel?.id == addressModel.id)
//                       Container(
//                         margin: const EdgeInsets.only(right: 18),
//                         child: const Icon(
//                           Icons.check_circle,
//                           color: Color(0xffFE734C),
//                           size: 20,
//                         ),
//                       )
//                     else
//                       Container(),
//                     Expanded(
//                       child: GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onTap: () => chooseCallBack(addressModel),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   constraints: const BoxConstraints(
//                                     maxWidth: 100,
//                                   ),
//                                   child: ThemeText(
//                                     text: addressModel.consignee ?? '',
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 ThemeText(
//                                   text: addressModel.telephone ?? '',
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                                 const SizedBox(width: 12),
//                                 addressModel.isDefault != '1'
//                                     ? Container()
//                                     : Container(
//                                         decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: const Color(0xffFE734C),
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(4)),
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 4, vertical: 2),
//                                         alignment: Alignment.center,
//                                         child: const ThemeText(
//                                           text: '默认',
//                                           fontSize: 8,
//                                           fontWeight: FontWeight.w400,
//                                           color: Color(0xffFE734C),
//                                         ),
//                                       ),
//                               ],
//                             ),
//                             const SizedBox(height: 6),
//                             ThemeText(
//                               text:
//                                   '${addressModel.delivery} ${addressModel.address}',
//                               color: const Color(0xff999999),
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     IconButton(
//                       onPressed: () {
//                         AppRouter.push(
//                                 context,
//                                 AddAddressPage(
//                                     isEdit: true, addressModel: addressModel))
//                             .then((value) {
//                           if (value == true && onPressed != null) {
//                             onPressed!();
//                           }
//                         });
//                       },
//                       icon: Image.asset(
//                         '${Constants.iconsPath}edit_address.png',
//                         width: 15,
//                         height: 15,
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
