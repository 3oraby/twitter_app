
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class CustomLikeButtonBody extends StatelessWidget {
  const CustomLikeButtonBody({
    super.key,
    required this.isActive,
    required this.likesCount,
    required this.onToggleLikeButtonPressed,
  });

  final bool isActive;
  final int likesCount;
  final Future<bool?> Function(bool) onToggleLikeButtonPressed;

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      isLiked: isActive,
      onTap: onToggleLikeButtonPressed,
      likeCount: likesCount,
      countBuilder: (likeCount, isLiked, text) => Text(
        likeCount.toString(),
        style: AppTextStyles.uberMoveMedium18.copyWith(
          color: isLiked ? Colors.red : AppColors.thirdColor,
        ),
      ),
      likeBuilder: (isLiked) {
        return Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? Colors.red : AppColors.thirdColor,
        );
      },
    );
  }
}
