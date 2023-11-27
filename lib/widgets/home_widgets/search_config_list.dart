import 'package:flutter/material.dart';
import 'package:old_goods_trading/states/search_details_state.dart';
import 'package:provider/provider.dart';
import 'search_detail_tab_pick_btn.dart';

class SearchConfigListView extends StatelessWidget {
  const SearchConfigListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchDetailsState>(
      builder: (BuildContext context, value, Widget? child) {
        return value.configSearchList.isEmpty
            ? Container()
            : SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: value.configSearchList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: TabPickBtn(
                        text: index == 0
                            ? value.allRoundList.isNotEmpty
                                ? value.allRoundList.first['name']
                                : value.configSearchList[index].name ?? ''
                            : value.configSearchList[index].name ?? '',
                        textColor: (index == 0 &&
                                    value.allRoundList.isNotEmpty) ||
                                (index == 1 &&
                                    (value.priceList.isNotEmpty ||
                                        (value.maxPrice ?? '').isNotEmpty)) ||
                                (index == 2 &&
                                    value.citySearchList.isNotEmpty) ||
                                (index == 3 && value.searchChoice.isNotEmpty)
                            ? const Color(0xffFE734C)
                            : const Color(0xff999999),

                        onTap: () {
                          value.showBottomSheet(context, index,value.configSearchList[index].name??'');
                        },
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
