import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../model/goods_details_model.dart';
import '../theme_image.dart';

class MessageCell extends StatelessWidget {
  final int index;
  final List<CommentList>? commentList;

  const MessageCell({Key? key, required this.index, required this.commentList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _messageCellView(
          avatar: commentList?[index].userInfo?.avatar,
          userName: commentList?[index].userInfo?.userName,
          createTime: commentList?[index].createTime,
          content: commentList?[index].content ?? '',
          zan: commentList?[index].zan ?? '0',
        ),
        (commentList?[index].replyInfo != null &&
                (commentList?[index].replyInfo?.content ?? '').isNotEmpty)
            ? Container(
                padding: const EdgeInsets.only(left: 36),
                child: _messageCellView(
                  avatar: commentList?[index].replyInfo!.userInfo?.avatar,
                  userName: commentList?[index].replyInfo!.userInfo?.userName,
                  createTime: commentList?[index].replyInfo?.createTime,
                  content: commentList?[index].replyInfo?.content ?? '',
                  zan: commentList?[index].zan ?? '0',
                  isReplyInfo: true,
                ),
              )
            : Container(),
        //  Column(
        //     children: [
        //       ListView.builder(
        //         shrinkWrap: true,
        //         physics: const NeverScrollableScrollPhysics(),
        //         padding: const EdgeInsets.only(left: 36),
        //         itemCount: 1,
        //         itemBuilder: (context, index) {
        //           return _messageCellView(
        //             avatar: commentList?[index].replyInfo!.userInfo?.avatar,
        //             userName:
        //                 commentList?[index].replyInfo!.userInfo?.userName,
        //             createTime: commentList?[index].replyInfo?.createTime,
        //             content: commentList?[index].replyInfo?.content ?? '',
        //             zan: commentList?[index].zan ?? '0',
        //           );
        //         },
        //       ),
        // GestureDetector(
        //   onTap: () {},
        //   child: Row(
        //     children: [
        //       const SizedBox(width: 70),
        //       const Text(
        //         '查看更多回复',
        //         style: TextStyle(
        //           color: Color(0xff999999),
        //           fontSize: 12,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //       const SizedBox(width: 6),
        //       Image.asset(
        //         '${Constants.iconsPath}bottom_arrow.png',
        //         width: 7,
        //         height: 7,
        //       ),
        //     ],
        //   ),
        // ),
        //     ],
        //   )
      ],
    );
  }

  Widget _messageCellView(
      {String? avatar,
      String? userName,
      String? createTime,
      bool isReplyInfo = false,
      required String content,
      required String zan}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: ThemeNetImage(
              imageUrl: avatar,
              placeholderPath:
                  "${Constants.placeholderPath}user_placeholder.png",
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: userName,
                    style: const TextStyle(
                      color: Color(0xff999999),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      const TextSpan(text: '   '),
                      TextSpan(
                        text: createTime,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    color: Color(0xff2F3033),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          // const SizedBox(width: 26),
          // isReplyInfo
          //     ? Container()
          //     : Column(
          //         children: [
          //           Image.asset(
          //             '${Constants.iconsPath}up_nor.png',
          //             width: 14,
          //             height: 14,
          //           ),
          //           const SizedBox(height: 5),
          //           Text(
          //             zan,
          //             style: const TextStyle(
          //               color: Color(0xff999999),
          //               fontSize: 8,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //         ],
          //       )
        ],
      ),
    );
  }
}
