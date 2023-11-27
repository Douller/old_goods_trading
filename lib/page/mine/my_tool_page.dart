import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:old_goods_trading/net/service_repository.dart';

class MyToolPage extends StatefulWidget {
  final String title;

  const MyToolPage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyToolPage> createState() => _MyToolPageState();
}

class _MyToolPageState extends State<MyToolPage> {
  String? htmlString;

  Future<void> _getData() async {
    String type = '';
    if (widget.title == '客服') {
      type = 'service';
    } else {
      type = 'about';
    }
    String? data = await ServiceRepository.articleAbout(type: type);
    setState(() {
      htmlString = data;
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: htmlString == null ? Container() : Container(child: htmlView),
    );
  }

  Widget get htmlView {
    return Html(data: htmlString);
  }
}
