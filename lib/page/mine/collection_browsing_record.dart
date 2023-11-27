import 'package:flutter/material.dart';
import 'package:old_goods_trading/states/my_collection_state.dart';
import 'package:old_goods_trading/widgets/theme_button.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../widgets/mine/collection_list_cell.dart';
import '../../widgets/no_data_view.dart';

class CollectionBrowsingRecord extends StatefulWidget {
  final String appBarTitle;

  const CollectionBrowsingRecord({
    Key? key,
    required this.appBarTitle,
  }) : super(key: key);

  @override
  State<CollectionBrowsingRecord> createState() =>
      _CollectionBrowsingRecordState();
}

class _CollectionBrowsingRecordState extends State<CollectionBrowsingRecord> {
  final MyCollectionViewModel _collectionViewModel = MyCollectionViewModel();

  @override
  void initState() {
    _collectionViewModel.getMyCollectList(widget.appBarTitle);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _collectionViewModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.appBarTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [_editBtn()],
        ),
        body: Consumer<MyCollectionViewModel>(
            builder: (BuildContext context, value, Widget? child) {
          return SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            controller: _collectionViewModel.refreshController,
            onLoading: _collectionViewModel.onLoading,
            child: value.collectionList.isEmpty
                ? const NoDataView()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    itemCount: value.collectionList.length,
                    itemBuilder: (context, index) {
                      return CollectionListCell(
                        model: value.collectionList[index],
                      );
                    },
                  ),
          );
        }),
        bottomNavigationBar: _bottomView(),
      ),
    );
  }

  Widget _bottomView() {
    return Consumer<MyCollectionViewModel>(
        builder: (BuildContext context, value, Widget? child) {
      if (value.isEdit) {
        return Container(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
          height: 80,
          color: Colors.white,
          child: Row(
            children: [
              GestureDetector(
                onTap: value.selectAllClick,
                child: Icon(
                  value.isSelectAll
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: value.isSelectAll
                      ? const Color(0xffFE734C)
                      : const Color(0xff999999),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              ThemeText(text: value.isSelectAll ? '取消全选' : '全选'),
              Expanded(child: Container()),
              ThemeButton(
                text:
                    '删除 ${value.chooseList.isEmpty ? '' : value.chooseList.length > 99 ? '99+' : value.chooseList.length}',
                width: 100,
                height: 36,
                onPressed: value.deleteCollection,
              ),
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Widget _editBtn() {
    return Consumer<MyCollectionViewModel>(
        builder: (BuildContext context, value, Widget? child) {
      return TextButton(
        onPressed: value.editBtnClick,
        child: Text(
          value.isEdit ? '完成' : '编辑',
          style: const TextStyle(
            color: Color(0xff2F3033),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      );
    });
  }
}
