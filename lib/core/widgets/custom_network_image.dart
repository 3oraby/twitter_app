import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ImageErrorWidgetBuilder? errorBuilder;
  final Widget? placeholder;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      alignment: Alignment(0, 0),
      fit: fit,
      useOldImageOnUrlChange: true,
      cacheManager: CachedNetworkImageProvider.defaultCacheManager,
      placeholder: (context, url) {
        return SizedBox(
          width: width,
          height: height,
          child: Container(
            color: Colors.grey[300],
          ).redacted(
            context: context,
            redact: true,
          ),
        );
      },
      errorWidget: (context, url, error) => SizedBox(
        width: width,
        height: height,
        child: Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }
}
