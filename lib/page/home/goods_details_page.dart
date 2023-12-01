import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:old_goods_trading/page/home/confirm_order_page.dart';
import 'package:old_goods_trading/page/home/picture_preview.dart';
import 'package:old_goods_trading/page/message/chat_page.dart';
import 'package:old_goods_trading/states/goods_details_state.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../router/app_router.dart';
import '../../states/user_info_state.dart';
import '../../widgets/home_widgets/goods_details_app_bar.dart';
import '../mine/seller_personal_center.dart';

class GoodsDetailsPage extends StatefulWidget {
  final String goodsId;
  final bool isSeller; //卖家是自己
  final bool isSupplier; //卖家中心进入
  const GoodsDetailsPage({
    Key? key,
    required this.goodsId,
    this.isSeller = false,
    this.isSupplier = false,
  }) : super(key: key);

  @override
  State<GoodsDetailsPage> createState() => _GoodsDetailsPageState();
}

class _GoodsDetailsPageState extends State<GoodsDetailsPage> {
  final GoodsDetailsState _goodsDetailsState = GoodsDetailsState();

  @override
  void initState() {
    _goodsDetailsState.getGoodsDetails(widget.goodsId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _goodsDetailsState,
      child: Scaffold(
        backgroundColor: const Color(0xffFAFAFA), // const Color(0xffF9F9F9),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Consumer<GoodsDetailsState>(
                builder: (BuildContext context, value, Widget? child) {
                  return GoodsDetailsAppBar(
                    isSeller: widget.isSeller,
                    userIcon:
                        value.detailsModel?.goodsInfo?.supplierInfo?.thumb,
                    userName: value.detailsModel?.goodsInfo?.supplierInfo?.name,
                    /*star: value.detailsModel?.goodsInfo?.score,
                    starIcon: Constants.getStarIcon(
                        num.parse(value.detailsModel?.goodsInfo?.score ?? '0')),*/
                    isFollow: value.follow ?? false,
                    onTap: () async {
                      bool isLogin = Constants.isLogin();
                      if (!isLogin) {
                        if (!mounted) return;
                        await Provider.of<UserInfoViewModel>(context,
                                listen: false)
                            .login();
                      } else {
                        if ((value.follow ?? false) == false) {
                          value.collectAndAdd(
                              supplierId: value
                                  .detailsModel?.goodsInfo?.supplierInfo?.id);
                        } else {
                          value.collectDelete(
                              supplierId: value
                                  .detailsModel?.goodsInfo?.supplierInfo?.id);
                        }
                      }
                    },
                    userInfoOnTap: () {
                      if (!widget.isSupplier) {
                        AppRouter.push(
                          context,
                          SellerPersonalCenter(
                            supplierId: value.detailsModel?.goodsInfo
                                    ?.supplierInfo?.id ??
                                '',
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              Expanded(
                child: ListView(
                  children: [
                    _goodsDetailsView(),
                    Container(height: 10),

                    ///新版本没有商品评论和推荐
                    // _messageBoard(),
                    // Container(height: 10),
                    // widget.isSeller
                    //     ? Container()
                    //     : Consumer<GoodsDetailsState>(builder:
                    //         (BuildContext context, value, Widget? child) {
                    //         return value.detailsModel?.goodsList == null ||
                    //                 value.detailsModel!.goodsList!.isEmpty
                    //             ? Container()
                    //             : Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Container(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         horizontal: 12, vertical: 20),
                    //                     child: const ThemeText(
                    //                       text: '推荐商品',
                    //                       fontSize: 16,
                    //                       fontWeight: FontWeight.w700,
                    //                     ),
                    //                   ),
                    //                   MasonryGridView.count(
                    //                     shrinkWrap: true,
                    //                     physics:
                    //                         const NeverScrollableScrollPhysics(),
                    //                     padding: const EdgeInsets.symmetric(
                    //                         horizontal: 12),
                    //                     itemCount: value
                    //                         .detailsModel?.goodsList!.length,
                    //                     crossAxisCount: 2,
                    //                     mainAxisSpacing: 4,
                    //                     crossAxisSpacing: 5,
                    //                     itemBuilder: (context, index) {
                    //                       return GestureDetector(
                    //                         onTap: () => AppRouter.push(
                    //                           context,
                    //                           GoodsDetailsPage(
                    //                             goodsId: value
                    //                                     .detailsModel
                    //                                     ?.goodsList?[index]
                    //                                     .id ??
                    //                                 '',
                    //                           ),
                    //                         ),
                    //                         child: HomeGoodsCell(
                    //                           index: index,
                    //                           goodsList: value.detailsModel
                    //                                   ?.goodsList ??
                    //                               [], tabBarIndex: 0,
                    //                         ),
                    //                       );
                    //                     },
                    //                   ),
                    //                 ],
                    //               );
                    //       })
                  ],
                ),
              ),
              widget.isSeller ? Container() : _bottomView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _goodsDetailsView() {
    return Column(
      children: [
        _swiperView(),
        Container(
          padding: const EdgeInsets.only(left: 19, right: 12, top: 20),
          child: Consumer<GoodsDetailsState>(
              builder: (BuildContext context, value, Widget? child) {
            return value.detailsModel == null
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ThemeText(
                                  text:
                                      value.detailsModel?.goodsInfo?.name ?? '',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  height: 1.5,
                                ),
                                /*const SizedBox(height: 4),
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      value.detailsModel?.goodsInfo?.score ??
                                          '0'),
                                  minRating: 0,
                                  maxRating: 5,
                                  glowColor: Colors.white,
                                  direction: Axis.horizontal,
                                  itemSize: 18,
                                  ignoreGestures: true,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  unratedColor: const Color(0xffEBF0FF),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: const Color(0xffE4D719)
                                        .withOpacity(0.8),
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),*/
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const SizedBox(width: 4),
                                    Image.asset(
                                      '${Constants.iconsPath}publish_time.png',
                                      width: 12,
                                      height: 12,
                                    ),
                                    const SizedBox(width: 3),
                                    ThemeText(
                                      text: value.detailsModel?.goodsInfo
                                              ?.publishTime ??
                                          '',
                                      fontSize: 8,
                                      fontWeight: FontWeight.w300,
                                      color: const Color(0xff81C0C3),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ThemeText(
                                  text:
                                      "原价  \$${value.detailsModel?.goodsInfo?.marketPrice ?? ''}",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: const Color(0xff484C52),
                                ),
                                ThemeText(
                                  text:
                                      "现价  \$${value.detailsModel?.goodsInfo?.shopPrice ?? ''}",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color:
                                      const Color(0xffEA4545).withOpacity(0.8),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 120,
                                  minWidth: 80,
                                ),
                                height: 27,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    color: const Color(0xffE4D719)
                                        .withOpacity(0.6)),
                                child: ThemeText(
                                  text: value.detailsModel?.goodsInfo?.tags ??
                                      '未填写',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 27,
                                constraints: const BoxConstraints(
                                  maxWidth: 120,
                                  minWidth: 80,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    color: const Color(0xffE4D719)
                                        .withOpacity(0.6)),
                                child: ThemeText(
                                  text: value.detailsModel?.goodsInfo
                                          ?.deliveryType ??
                                      '',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ThemeText(
                                text: index == 0
                                    ? '使用时间'
                                    : index == 1
                                        ? '使用程度'
                                        : index == 2
                                            ? '商品类别'
                                            : '发货方式',
                                color: const Color(0xff484C52).withOpacity(0.6),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              ThemeText(
                                text: index == 0
                                    ? value.detailsModel?.goodsInfo
                                            ?.purchaseTime ??
                                        '未填写'
                                    : index == 1
                                        ? value.detailsModel?.goodsInfo
                                                ?.brushingCondition ??
                                            '未填写'
                                        : index == 2
                                            ? value.detailsModel?.goodsInfo
                                                    ?.categoryName ??
                                                '未填写'
                                            : value.detailsModel?.goodsInfo
                                                    ?.deliveryWay ??
                                                '',
                                color: const Color(0xff484C52),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 30),
                      const ThemeText(
                        text: '产品描述',
                        color: Color(0xff484C52),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 6),
                      ThemeText(
                        text: value.detailsModel?.goodsInfo?.brief ?? "",
                        color: const Color(0xff484C52).withOpacity(0.4),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        height: 1.5,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  );
          }),
        )
      ],
    );
  }

  ///轮播图
  Widget _swiperView() {
    return Consumer<GoodsDetailsState>(
      builder: (BuildContext context, value, Widget? child) {
        return value.detailsModel?.goodsInfo?.images == null
            ? Container()
            : SizedBox(
                height: 261,
                child: Swiper(
                  itemCount: value.detailsModel!.goodsInfo!.images!.length,
                  autoplay: true,
                  duration: 500,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        AppRouter.push(
                          context,
                          PicturePreview(
                            galleryItems:
                                value.detailsModel!.goodsInfo!.images!,
                            defaultIndex: index,
                          ),
                        );
                      },
                      child: ThemeNetImage(
                        imageUrl:
                            value.detailsModel?.goodsInfo?.images?[index].image,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      size: 8,
                      activeSize: 8,
                      activeColor: const Color(0xffE4D719).withOpacity(0.8),
                      color: const Color(0xffEBF0FF),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _bottomView() {
    return Consumer<GoodsDetailsState>(
        builder: (BuildContext context, value, Widget? child) {
      return value.detailsModel?.goodsInfo?.status == "1"
          ? Container(
              color: const Color(0xffF4F3F3),
              height: Platform.isIOS ? 80 : 60 + Constants.bottomPadding,
              padding: const EdgeInsets.only(left: 33, top: 11, right: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bottomBtn('${Constants.iconsPath}message.png', '私信',
                      () async {
                    bool isLogin = Constants.isLogin();
                    if (!isLogin) {
                      if (!mounted) return;
                      await Provider.of<UserInfoViewModel>(context,
                              listen: false)
                          .login();
                    } else {
                      AppRouter.push(
                          context,
                          ChatPage(
                              goodsInfoModel: value.detailsModel?.goodsInfo));
                    }
                  }),
                  const SizedBox(width: 40),
                  _bottomBtn(
                      (value.collect ?? false) == false
                          ? '${Constants.iconsPath}collect.png'
                          : '${Constants.iconsPath}full_star.png',
                      '收藏', () async {
                    bool isLogin = Constants.isLogin();
                    if (!isLogin) {
                      if (!mounted) return;
                      await Provider.of<UserInfoViewModel>(context,
                              listen: false)
                          .login();
                    } else {
                      if ((value.collect ?? false) == false) {
                        value.collectAndAdd(
                            goodsId: value.detailsModel?.goodsInfo?.id);
                      } else {
                        value.collectDelete(
                            goodsId: value.detailsModel?.goodsInfo?.id);
                      }
                    }
                  }),
                  Expanded(child: Container()),
                  value.detailsModel?.goodsInfo?.displayBuyBoutton == '1'
                      ? ThemeButton(
                          text: '立即购买',
                          width: 80,
                          height: 41,
                          radius: 16,
                          onPressed: () async {
                            bool isLogin = Constants.isLogin();
                            if (!isLogin) {
                              if (!mounted) return;
                              await Provider.of<UserInfoViewModel>(context,
                                      listen: false)
                                  .login();
                            } else {
                              AppRouter.push(
                                context,
                                ConfirmOrderPage(
                                    goodsInfoModel:
                                        value.detailsModel!.goodsInfo!),
                              );
                            }
                          },
                        )
                      : Container(),
                ],
              ),
            )
          : _shouChuView(value.detailsModel?.goodsInfo?.statusName ?? '');
    });
  }

  Widget _bottomBtn(String iconPath, String text, GestureTapCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xff484C52),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  Widget _shouChuView(String statusName) {
    return Container(
      color: Colors.white,
      height: 80 + Constants.bottomPadding,
      child: Column(
        children: [
          Container(
            height: 30,
            alignment: Alignment.center,
            color: const Color(0xFF666666),
            child: ThemeText(
              text: '该商品$statusName',
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 12, right: 18),
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color(0xffCECECE),
              ),
              height: 34,
              width: 85,
              alignment: Alignment.center,
              child: ThemeText(
                text: statusName,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

// Widget _messageBoard() {
//   return Consumer<GoodsDetailsState>(
//       builder: (BuildContext context, value, Widget? child) {
//         return value.detailsModel?.commentList == null ||
//             value.detailsModel!.commentList!.isEmpty
//             ? Container()
//             : Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
//           color: Colors.white,
//           child: ListView(
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             children: List.generate(value.detailsModel!.commentList!.length,
//                     (index) {
//                   return MessageCell(
//                     index: index,
//                     commentList: value.detailsModel!.commentList!,
//                   );
//                 }),
//           ),
//         );
//       });
// }
}
