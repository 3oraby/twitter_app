import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/get_time_ago.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/widgets/custom_comment_like_button.dart';

class CustomCommentInteractionsRow extends StatelessWidget {
  const CustomCommentInteractionsRow({
    super.key,
    required this.commentDetailsEntity,
  });

  final CommentDetailsEntity commentDetailsEntity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          getTimeAgo(commentDetailsEntity.comment.createdAt),
          style: AppTextStyles.uberMoveBold16.copyWith(
            color: AppColors.thirdColor,
          ),
        ),
        const HorizontalGap(6),
        TextButton(
          onPressed: () {},
          child: Text(
            "Reply",
            style: AppTextStyles.uberMoveExtraBold18.copyWith(
              color: AppColors.thirdColor,
            ),
          ),
        ),
        Spacer(),
        CustomCommentLikeButton(
          commentId: commentDetailsEntity.commentId,
          originalAuthorId:
              commentDetailsEntity.comment.commentAuthorData.userId,
          likesCount: commentDetailsEntity.comment.likes?.length ?? 0,
          isActive: commentDetailsEntity.isLiked,
        ),
      ],
    );
  }
}
