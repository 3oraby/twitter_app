import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
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
    return SizedBox(
      height: mediaHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: mediaUrl.map((url) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                child: CustomNetworkImage(
                  imageUrl: url,
                  height: mediaHeight,
                  width: mediaWidth,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
