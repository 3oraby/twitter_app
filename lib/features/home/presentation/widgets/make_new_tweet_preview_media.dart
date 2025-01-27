
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';

class MakeNewTweetPreviewMedia extends StatelessWidget {
  const MakeNewTweetPreviewMedia({
    super.key,
    required this.mediaFiles,
    required this.onRemoveImageButtonPressed,
  });

  final List<File> mediaFiles;
  final void Function(int index) onRemoveImageButtonPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mediaFiles.length,
        separatorBuilder: (context, index) => const HorizontalGap(12),
        itemBuilder: (context, index) => Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              child: Image.file(
                mediaFiles[index],
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => onRemoveImageButtonPressed(index),
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
        ),
      ),
    );
  }
}
