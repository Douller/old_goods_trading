import 'package:flutter/material.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/utils/toast.dart';
import 'package:old_goods_trading/widgets/no_data_view.dart';

import '../../widgets/home_widgets/search_text_field.dart';
import '../../widgets/theme_text.dart';

class ChooseDeliveryPage extends StatefulWidget {
  const ChooseDeliveryPage({Key? key}) : super(key: key);

  @override
  State<ChooseDeliveryPage> createState() => _ChooseDeliveryPageState();
}

class _ChooseDeliveryPageState extends State<ChooseDeliveryPage> {
  final TextEditingController _controller = TextEditingController();
  List _kuaiDiList = [];
  List _chooseList = [];

  @override
  void initState() {
    _getKuaiDiData();

    super.initState();
  }

  Future<void> _getKuaiDiData() async {
    ToastUtils.showLoading();
    List data = await ServiceRepository.getKuaidi();
    setState(() {
      _kuaiDiList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('选择快递公司'),
        ),
        body: Column(
          children: [
            _topView(),
            _kuaidiListView(),
          ],
        ),
      ),
    );
  }

  Widget _topView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: SearchTextField(
                  controller: _controller,
                  fillColor: const Color(0xffF6F6F6),
                  hintText: '搜索快递公司',
                  onSubmitted: (String text) async {
                    if (text.isNotEmpty) {
                      for (Map element in _kuaiDiList) {
                        if (text.toLowerCase() ==
                            (element['name'] ?? '').toLowerCase()) {
                          setState(() {
                            _chooseList.add(element);
                          });
                        }
                      }
                    }
                  },
                ),
              ),
              _chooseList.isEmpty
                  ? Container()
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          _chooseList.clear();
                        });
                      },
                      child: const ThemeText(
                        text: '取消',
                      ))
            ],
          ),
        ),
      ],
    );
  }

  Widget _kuaidiListView() {
    return _kuaiDiList.isEmpty
        ? const NoDataView()
        : Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: _chooseList.isNotEmpty
                  ? _chooseList.length
                  : _kuaiDiList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.pop(context,_kuaiDiList[index]);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF2F3F5),
                        ),
                      ),
                    ),
                    child: ThemeText(text: _kuaiDiList[index]['name']),
                  ),
                );
              },
            ),
          );
  }
}
