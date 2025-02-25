import 'package:flutter/material.dart';
import 'package:twitter_app/features/tweet/presentation/screens/full_screen_gallery.dart';

void openFullScreenGallery(
  BuildContext context, {
  required List<String> mediaUrl,
  int initialIndex = 0,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FullScreenGallery(
        mediaUrls: mediaUrl,
        initialIndex: initialIndex,
      ),
    ),
  );
}
