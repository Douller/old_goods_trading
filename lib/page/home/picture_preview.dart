import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:old_goods_trading/widgets/theme_text.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../model/home_goods_list_model.dart';

class PicturePreview extends StatefulWidget {
  final List<Images> galleryItems;
  final int defaultIndex;

  const PicturePreview(
      {Key? key, required this.galleryItems, this.defaultIndex = 0})
      : super(key: key);

  @override
  State<PicturePreview> createState() => _PicturePreviewState();
}

class _PicturePreviewState extends State<PicturePreview> {
  int _chooseIndex = 0;

  @override
  void initState() {
    _chooseIndex = widget.defaultIndex + 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        // backgroundColor: Colors.white10,
        title: ThemeText(
          text: '$_chooseIndex/${widget.galleryItems.length}',
          color: Colors.white,
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.galleryItems[index].image!),
                initialScale: PhotoViewComputedScale.contained * 0.9,
              );
            },
            itemCount: widget.galleryItems.length,
            loadingBuilder: (context, event) => const Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(),
              ),
            ),
            pageController: PageController(initialPage: widget.defaultIndex),
            onPageChanged: (index) {
              setState(() {
                _chooseIndex = index + 1;
              });
            },
          ),
        ],
      ),
    );
  }
}
