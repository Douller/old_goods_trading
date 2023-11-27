import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ThemeNetImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final String? placeholderPath;
  final BoxFit? fit;

  const ThemeNetImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.placeholderPath,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageUrl == null
        ? Image.asset(
            placeholderPath??'${Constants.placeholderPath}goods_placeholder.png',
            width: width,
            height: height,
          )
        : CachedNetworkImage(
            imageUrl: imageUrl!,
            width: width,
            height: height,
            placeholder: (context, url) => placeholderPath == null
                ? const CupertinoActivityIndicator()
                : Image.asset(
                    placeholderPath!,
                    width: width,
                    height: height,
                  ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: fit,
          );
  }
}
