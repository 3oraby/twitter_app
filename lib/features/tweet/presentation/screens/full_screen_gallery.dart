import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenGallery extends StatefulWidget {
  const FullScreenGallery({
    super.key,
    required this.mediaUrls,
    this.initialIndex = 0,
  });

  final List<String> mediaUrls;
  final int initialIndex;

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        itemCount: widget.mediaUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
              widget.mediaUrls[index],
            ),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            heroAttributes:
                PhotoViewHeroAttributes(tag: widget.mediaUrls[index]),
          );
        },
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        pageController: pageController,
      ),
    );
  }
}
