import 'package:dartz/dartz.dart' as dartz;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/get_time_ago.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/widgets/custom_comment_like_button.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';

class CustomCommentInteractionsRow extends StatelessWidget {
  const CustomCommentInteractionsRow({
    super.key,
    required this.currentUser,
    required this.commentDetailsEntity,
    required this.onReplyButtonPressed,
  });

  final UserEntity currentUser;
  final CommentDetailsEntity commentDetailsEntity;
  final ValueChanged<dartz.Either<CommentDetailsEntity, ReplyDetailsEntity>>
      onReplyButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          getTimeAgo(commentDetailsEntity.comment.createdAt, context: context),
          style: AppTextStyles.uberMoveBold16.copyWith(
            color: AppColors.thirdColor,
          ),
        ),
        const HorizontalGap(6),
        TextButton(
          onPressed: () {
            onReplyButtonPressed(dartz.Left(commentDetailsEntity));
          },
          child: Text(
            context.tr("Reply"),
            style: AppTextStyles.uberMoveExtraBold18.copyWith(
              color: AppColors.thirdColor,
            ),
          ),
        ),
        Spacer(),
        CustomCommentLikeButton(
          commentDetailsEntity: commentDetailsEntity,
          currentUser: currentUser,
          isActive: commentDetailsEntity.isLiked,
        ),
      ],
    );
  }
}
