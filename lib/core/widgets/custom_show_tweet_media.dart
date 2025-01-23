
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/widgets/custom_network_image.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';

class CustomShowTweetsMedia extends StatelessWidget {
  const CustomShowTweetsMedia({
    super.key,
    required this.mediaUrl,
  });

  final List<String> mediaUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mediaUrl.length,
        separatorBuilder: (context, index) => const HorizontalGap(12),
        itemBuilder: (context, index) => Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              child: CustomNetworkImage(
                imageUrl: mediaUrl[index],
                height: 300,
                width: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
