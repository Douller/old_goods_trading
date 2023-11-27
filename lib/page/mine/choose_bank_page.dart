import 'package:flutter/material.dart';
import 'package:old_goods_trading/model/bank_model.dart';
import 'package:old_goods_trading/net/service_repository.dart';

import '../../widgets/theme_image.dart';
import '../../widgets/theme_text.dart';

class ChooseBankPage extends StatefulWidget {
  const ChooseBankPage({Key? key}) : super(key: key);

  @override
  State<ChooseBankPage> createState() => _ChooseBankPageState();
}

class _ChooseBankPageState extends State<ChooseBankPage> {
  List<Bank>? _bankList;

  Future<void> _getBankList() async {
    BankModel? model = await ServiceRepository.getBankList();
    if (model != null) {
      setState(() {
        _bankList = model.bank ?? [];
      });
    }
  }

  void _popPage(Bank bankModel){

    Navigator.pop(context,bankModel);
  }

  @override
  void initState() {
    _getBankList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择银行'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            if ((_bankList ?? []).isEmpty) Container() else Expanded(
                    child: ListView.builder(
                      itemCount: _bankList?.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap:() =>_popPage(_bankList![index]),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 45,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    ThemeNetImage(
                                      imageUrl: _bankList?[index].bankImg,
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    ThemeText(
                                      text: _bankList?[index].name ?? '',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ),
                              const Divider(color: Color(0xFFF2F3F5)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
