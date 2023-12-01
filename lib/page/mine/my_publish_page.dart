import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:old_goods_trading/router/app_router.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../constants/constants.dart';
import '../../model/home_goods_list_model.dart';
import '../../states/my_publish_state.dart';
import '../../utils/refresh_publish_event_bus.dart';
import '../../widgets/goods_price_text.dart';
import '../../widgets/goods_star_view.dart';
import '../../widgets/mine/my_publish_cell.dart';
import '../../widgets/no_data_view.dart';
import '../../widgets/theme_image.dart';
import 'publish_goods_details.dart';

class MyPublishPage extends StatefulWidget {
  final bool? isAddPage; //true:发布 false:草稿箱

  const MyPublishPage({Key? key, this.isAddPage}) : super(key: key);

  @override
  State<MyPublishPage> createState() => _MyPublishPageState();
}

class _MyPublishPageState extends State<MyPublishPage> {
  final List<String> _topBtnTitle = ['我的发布', '草稿', '已下架'];

  final MyPublishViewModel _myPublishViewModel = MyPublishViewModel();

  int _selectedIndex = 0;

  StreamSubscription? subscription;

  @override
  void initState() {
    widget.isAddPage == false ? _selectedIndex = 1 : _selectedIndex = 0;

    _myPublishViewModel.changeTopBtn(_selectedIndex);

    subscription = eventBus.on<RefreshPublishPage>().listen((event) {
      if (event.isRefreshPublish == true) {
        _myPublishViewModel.changeTopBtn(_selectedIndex);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _myPublishViewModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('我的发布'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _topBtn(),
            ),
            Expanded(
              child: Consumer<MyPublishViewModel>(
                builder: (BuildContext context, value, Widget? child) {
                  return SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    controller: _myPublishViewModel.refreshController,
                    onLoading: _myPublishViewModel.onLoading,
                    child: value.myPublishList.isEmpty
                        ? const NoDataView()
                        : MasonryGridView.count(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: value.myPublishList.length,
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  AppRouter.push(
                                      context,
                                      PublishGoodsDetails(
                                        publishModel:
                                            value.myPublishList[index],
                                      )).then((res) {
                                    if (res is bool && res == true) {
                                      value.changeTopBtn(_selectedIndex);
                                    }
                                  });
                                },
                                child: _cellView(value.myPublishList[index]),
                              );
                            },
                          ),

                    // ListView.builder(
                    //         padding: const EdgeInsets.only(left: 12, right: 12),
                    //         itemCount: value.myPublishList.length,
                    //         itemBuilder: (context, index) {
                    //           return GestureDetector(
                    //             onTap: () {
                    //               AppRouter.push(
                    //                   context,
                    //                   PublishGoodsDetails(
                    //                     publishModel:
                    //                         value.myPublishList[index],
                    //                   )).then((res) {
                    //                 if (res is bool && res == true) {
                    //                   value.changeTopBtn(_selectedIndex);
                    //                 }
                    //               });
                    //             },
                    //             child: MyPublishCell(
                    //                 model: value.myPublishList[index]),
                    //           );
                    //         },
                    //       ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBtn() {
    return Consumer<MyPublishViewModel>(
        builder: (BuildContext context, value, Widget? child) {
      return GridView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 9,
          childAspectRatio: 2.6,
        ),
        itemCount: _topBtnTitle.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _selectedIndex = index;
              value.changeTopBtn(_selectedIndex);
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: (value.publishStatus == 1 && index == 0)
                    ? const Color(0xffE4D719).withOpacity(0.8)
                    : (value.publishStatus == 2 && index == 1)
                        ? const Color(0xffE4D719).withOpacity(0.8)
                        : (value.publishStatus == 0 && index == 2)
                            ? const Color(0xffE4D719).withOpacity(0.8)
                            : Colors.transparent,
              ),
              child: ThemeText(
                text: _topBtnTitle[index],
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: (value.publishStatus == 1 && index == 0)
                    ? const Color(0xff484C52)
                    : (value.publishStatus == 2 && index == 1)
                        ? const Color(0xff484C52)
                        : (value.publishStatus == 0 && index == 2)
                            ? const Color(0xff484C52)
                            : const Color(0xff484C52).withOpacity(0.4),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _cellView(GoodsInfoModel model) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xffE4D719).withOpacity(0.8),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // 阴影的颜色
              offset: const Offset(0, 4), // 阴影与容器的距离
              blurRadius: 4.0, // 高斯的标准偏差与盒子的形状卷积。
              spreadRadius: 0.0, // 在应用模糊之前，框应该膨胀的量。
            ),
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ThemeNetImage(
                imageUrl: model.thumbUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(11, 8, 6, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GoodsPriceText(
                        priceStr: model.shopPrice ?? '',
                        symbolFontSize: 16,
                        textFontSize: 16,
                        symbolFontWeight: FontWeight.w500,
                        textFontWeight: FontWeight.w500,
                      ),
                    ),
                    /*GoodsStarView(
                      starIcon:
                          Constants.getStarIcon(num.parse(model.score ?? '0')),
                      starStr: model.score ?? '0',
                      width: 12,
                      height: 12,
                      fontSize: 14,
                    ),*/
                  ],
                ),
                const SizedBox(height: 3),
                ThemeText(
                  text: model.name ?? '',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(height: 6),
                (model.publishTime ?? '').isEmpty
                    ? Container()
                    : Row(
                        children: [
                          Image.asset(
                            '${Constants.iconsPath}publish_time.png',
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(width: 3),
                          ThemeText(
                            text: model.publishTime ?? '',
                            fontSize: 8,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xff81C0C3),
                          ),
                        ],
                      ),
                const SizedBox(height: 6),
              ],
            ),
          )
        ],
      ),
    );
  }
}
