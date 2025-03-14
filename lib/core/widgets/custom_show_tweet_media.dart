import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/open_full_screen_gallery.dart';
import 'package:twitter_app/core/widgets/custom_network_image.dart';

class CustomShowTweetsMedia extends StatelessWidget {
  const CustomShowTweetsMedia({
    super.key,
    required this.mediaUrl,
    this.mediaHeight,
    this.mediaWidth,
  });

  final List<String> mediaUrl;
  final double? mediaHeight;
  final double? mediaWidth;

  @override
  Widget build(BuildContext context) {
    if (mediaUrl.length == 1) {
      return SingleMediaWidget(
        mediaUrl: mediaUrl.first,
        mediaHeight: mediaHeight,
        onTap: () => openFullScreenGallery(
          context,
          mediaUrl: mediaUrl,
        ),
      );
    } else {
      return MultipleMediaWidget(
        mediaUrl: mediaUrl,
        mediaHeight: mediaHeight,
        mediaWidth: mediaWidth,
        onTap: (index) => openFullScreenGallery(
          context,
          mediaUrl: mediaUrl,
          initialIndex: index,
        ),
      );
    }
  }
}

class SingleMediaWidget extends StatelessWidget {
  const SingleMediaWidget({
    super.key,
    required this.mediaUrl,
    this.mediaHeight,
    required this.onTap,
  });

  final String mediaUrl;
  final double? mediaHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: CustomNetworkImage(
          key: ValueKey(mediaUrl),
          imageUrl: mediaUrl,
          height: mediaHeight,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class MultipleMediaWidget extends StatelessWidget {
  const MultipleMediaWidget({
    super.key,
    required this.mediaUrl,
    this.mediaHeight,
    this.mediaWidth,
    required this.onTap,
  });

  final List<String> mediaUrl;
  final double? mediaHeight;
  final double? mediaWidth;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mediaHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: mediaUrl.asMap().entries.map((entry) {
            int index = entry.key;
            String url = entry.value;
            return GestureDetector(
              onTap: () => onTap(index),
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius),
                  child: CustomNetworkImage(
                    key: ValueKey(url),
                    imageUrl: url,
                    height: mediaHeight,
                    width: mediaWidth,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
