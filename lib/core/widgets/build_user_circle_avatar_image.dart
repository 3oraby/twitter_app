import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_images.dart';

class BuildUserCircleAvatarImage extends StatelessWidget {
  const BuildUserCircleAvatarImage({
    super.key,
    required this.profilePicUrl,
    this.circleAvatarRadius = 30,
  });

  final String? profilePicUrl;
  final double circleAvatarRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: circleAvatarRadius,
      backgroundColor: profilePicUrl == null
          ? Colors.white
          : AppColors.highlightBackgroundColor,
      backgroundImage: profilePicUrl != null
          ? NetworkImage(
              profilePicUrl!,
            )
          : const AssetImage(
              AppImages.imagesUnknownUser,
            ),
      onBackgroundImageError: (error, stackTrace) {
        const AssetImage(AppImages.imagesUnknownUser);
      },
    );
  }
}
