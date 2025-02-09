import 'dart:io';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/widgets/custom_network_image.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';

class PreviewChosenMedia extends StatelessWidget {
  const PreviewChosenMedia({
    super.key,
    required this.mediaFiles,
    required this.onRemoveImageButtonPressed,
    required this.isLoading,
    this.networkMediaUrls,
    this.onRemoveNetworkImageUrlPressed,
    this.previewChosenMediaLength = 300,
  });

  final List<File> mediaFiles;
  final List<String>? networkMediaUrls;
  final void Function(int index) onRemoveImageButtonPressed;
  final void Function(int index)? onRemoveNetworkImageUrlPressed;
  final double previewChosenMediaLength;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: previewChosenMediaLength,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mediaFiles.length + (networkMediaUrls?.length ?? 0),
        separatorBuilder: (context, index) => const HorizontalGap(12),
        itemBuilder: (context, index) {
          final bool isNetworkUrlImage = index < mediaFiles.length;
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                child: isNetworkUrlImage
                    ? Image.file(
                        mediaFiles[index],
                        height: previewChosenMediaLength,
                        width: previewChosenMediaLength,
                        fit: BoxFit.cover,
                      )
                    : CustomNetworkImage(
                        imageUrl: networkMediaUrls![index - mediaFiles.length],
                        height: previewChosenMediaLength,
                        width: previewChosenMediaLength,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => networkMediaUrls == null
                      ? onRemoveImageButtonPressed(index)
                      : onRemoveNetworkImageUrlPressed!(index),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.remove_circle,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
