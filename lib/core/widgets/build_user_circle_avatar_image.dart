import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';

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
      backgroundColor: AppColors.highlightBackgroundColor,
      child: ClipOval(
        child: profilePicUrl != null
            ? Image.network(
                profilePicUrl!,
                fit: BoxFit.cover,
                width: circleAvatarRadius * 2,
                height: circleAvatarRadius * 2,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person_2,
                    color: AppColors.thirdColor,
                    size: circleAvatarRadius * 1.5,
                  );
                },
              )
            : Icon(
                Icons.person_2,
                color: AppColors.thirdColor,
                size: circleAvatarRadius * 1.5,
              ),
      ),
    );
  }
}
