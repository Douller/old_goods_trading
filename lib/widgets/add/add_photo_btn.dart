import 'package:flutter/material.dart';
import 'package:old_goods_trading/widgets/theme_image.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../constants/constants.dart';
import '../../model/home_goods_list_model.dart';
import '../../page/home/picture_preview.dart';
import '../../router/app_router.dart';
import '../theme_text.dart';

///添加图片的按钮
class AddPhotoBtn extends StatelessWidget {
  final GestureTapCallback? onTap;

  const AddPhotoBtn({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (Constants.screenWidth - 46) / 3,
        height: (Constants.screenWidth - 46) / 3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xffF7F7F7),
            border:
                Border.all(color: const Color(0xffE4D719).withOpacity(0.4))),
        alignment: Alignment.center,
        child: const Icon(
          Icons.add,
          size: 40,
          color: Color(0xffCCCCCC),
        ),
      ),
    );
  }
}

typedef AddImageViewCallBack = void Function(AssetEntity entity);

/// 相册或者相机选择的本地图片
class AddImageView extends StatelessWidget {
  final AssetEntity entity;
  final int index;
  final List<AssetEntity> previewAssets;
  final AddImageViewCallBack? callBack;
  final bool isAfter;

  const AddImageView({
    Key? key,
    required this.entity,
    this.callBack,
    required this.index,
    required this.previewAssets,
    this.isAfter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        width: (Constants.screenWidth - 46) / 3,
        height: (Constants.screenWidth - 46) / 3,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            GestureDetector(
              onTap: () {
                AssetPickerViewer.pushToViewer(
                  context,
                  currentIndex: index,
                  previewAssets: previewAssets,
                  themeData: AssetPicker.themeData(const Color(0xff00bc56)),
                );
              },
              child: AssetEntityImage(
                entity,
                isOriginal: false,
                width: (Constants.screenWidth - 40) / 3,
                height: (Constants.screenWidth - 40) / 3,
                fit: BoxFit.cover,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (callBack == null) return;
                callBack!(entity);
              },
              child: Container(
                width: 18,
                height: 18,
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                    color: Color(0xff2F3033)),
                child: Image.asset(
                  '${Constants.iconsPath}close.png',
                  color: Colors.white,
                ),
              ),
            ),
            index == 0 && !isAfter
                ? Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: 32,
                      height: 18,
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(5)),
                        color: Color(0xffFE734C),
                      ),
                      alignment: Alignment.center,
                      child: const ThemeText(
                        text: '封面',
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

/// 编辑页面 传过来的 网络图片
typedef PublishNetWorkImageCallBack = void Function(Gallery item);

class PublishNetWorkImage extends StatelessWidget {
  final Gallery model;
  final int index;
  final PublishNetWorkImageCallBack? callBack;

  const PublishNetWorkImage(
      {Key? key, required this.model, this.callBack, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        width: (Constants.screenWidth - 46) / 3,
        height: (Constants.screenWidth - 46) / 3,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            GestureDetector(
              onTap: () {
                AppRouter.push(
                  context,
                  PicturePreview(
                    galleryItems: [Images(image: model.url)],
                    defaultIndex: 0,
                  ),
                );
              },
              child: ThemeNetImage(
                imageUrl: model.url,
                width: (Constants.screenWidth - 40) / 3,
                height: (Constants.screenWidth - 40) / 3,
                fit: BoxFit.cover,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (callBack == null) return;
                callBack!(model);
              },
              child: Container(
                width: 18,
                height: 18,
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                    color: Color(0xff2F3033)),
                child: Image.asset(
                  '${Constants.iconsPath}close.png',
                  color: Colors.white,
                ),
              ),
            ),
            index == 0
                ? Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: 32,
                      height: 18,
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(5)),
                        color: Color(0xffFE734C),
                      ),
                      alignment: Alignment.center,
                      child: const ThemeText(
                        text: '封面',
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
