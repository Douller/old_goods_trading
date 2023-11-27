import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:old_goods_trading/net/service_repository.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';

class AppraisePage extends StatefulWidget {
  final String orderId;
  final bool isSupplier;//是否为卖家 true为true
  const AppraisePage({Key? key, required this.orderId, required this.isSupplier}) : super(key: key);

  @override
  State<AppraisePage> createState() => _AppraisePageState();
}

class _AppraisePageState extends State<AppraisePage> {
  final TextEditingController _remarkController = TextEditingController();
  bool _isAppraise = false;
  String _rating = '10';


  Future<void> _subAppraise() async {
    if(widget.isSupplier){
      await ServiceRepository.commentSupplierAdd(
          orderId: widget.orderId, content: _remarkController.text, score: _rating);
      Future.delayed(const Duration(seconds: 1),(){
        Navigator.pop(context);
      });
    }else{
      await ServiceRepository.commentAdd(
          orderId: widget.orderId, content: _remarkController.text, score: _rating);
      Future.delayed(const Duration(seconds: 1),(){
        Navigator.pop(context);
      });
    }

  }


  @override
  void initState() {
    _remarkController.addListener(() {
      setState(() {
        if (_remarkController.text
            .trim()
            .isNotEmpty) {
          _isAppraise = true;
        } else {
          _isAppraise = false;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('评价'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            _ratingBarView(),
            const SizedBox(height: 12),
            const Divider(color: Color(0xffF6F6F6)),
            const SizedBox(height: 12),
            TextField(
              controller: _remarkController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '聊聊本次交易感受，你的评价能帮助到其他人~',
                hintStyle: TextStyle(
                  color: Color(0xff999999),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              maxLines: null,
              maxLength: 300,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBtn(),
    );
  }

  Widget _ratingBarView() {
    return Row(
      children: [
        const ThemeText(text: '商品评价：'),
        const SizedBox(width: 16),
        Container(
          alignment: Alignment.center,
          child: RatingBar.builder(
            initialRating: 5,
            minRating: 0,
            glowColor: Colors.white,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) =>
            const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _rating = (rating * 2).toString();
            },
          ),
        )
      ],
    );
  }

  Widget _bottomBtn() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: _subAppraise,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
            _isAppraise ? const Color(0xffFE734C) : const Color(0xffCECECE),
            borderRadius: BorderRadius.circular(44),
          ),
          child: const Text(
            '发布评价',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
