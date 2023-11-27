import 'package:flutter/material.dart';

import '../theme_text.dart';

class PublishSheetItemChildView extends StatelessWidget {
  final String title;
  final bool isSelected;

  const PublishSheetItemChildView(
      {Key? key, required this.title, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xffE4D719).withOpacity(0.8)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xffE4D719).withOpacity(0.8)),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ThemeText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
