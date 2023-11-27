import 'package:flutter/material.dart';
import '../../constants/constants.dart';


class SearchLabel extends StatelessWidget {
  final String title;
  final List<String> labelList;
  final bool? isHideBtn;
  final GestureTapCallback? removeSearchRecord;
  final ValueChanged<String>? pushSearchDetails;

  const SearchLabel({
    Key? key,
    required this.title,
    required this.labelList,
    this.isHideBtn = true,
    this.removeSearchRecord,
    this.pushSearchDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xff2F3033),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Expanded(child: Container()),
              isHideBtn == true
                  ? Container()
                  : GestureDetector(
                      onTap: removeSearchRecord,
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xffCECECE),
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                            '${Constants.iconsPath}search_delete.png'),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 16),
          labelList.isEmpty
              ? Container()
              : Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: List.generate(labelList.length, (index) {
                    return _searchLabel(labelList[index]);
                  }),
                )
        ],
      ),
    );
  }

  Widget _searchLabel(String text) {
    return GestureDetector(
      onTap: () => pushSearchDetails!(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xff999999).withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xff666666),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          strutStyle: const StrutStyle(
            forceStrutHeight: true,
            leading: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
