import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../states/my_order_details_state.dart';
import '../theme_text.dart';

class MyOrderDetailsAddressView extends StatelessWidget {
  const MyOrderDetailsAddressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MyOrderDetailsViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ThemeText(
                          text: value.model?.addressInfo?.consignee ?? '',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        const SizedBox(width: 20),
                        ThemeText(
                          text: value.model?.addressInfo?.telephone ?? '',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ThemeText(
                      text: value.model?.addressAll ?? '',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
