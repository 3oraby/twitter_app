import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_show_tweet_media.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/widgets/custom_comment_interactions_row.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/presentation/widgets/show_comment_replies_part.dart';

class CustomCommentInfoCard extends StatelessWidget {
  const CustomCommentInfoCard({
    super.key,
    required this.commentDetailsEntity,
    this.showInteractionsRow = true,
    this.mediaHeight = 300,
    this.mediaWidth = 250,
    required this.onReplyButtonPressed,
  });
  final CommentDetailsEntity commentDetailsEntity;
  final bool showInteractionsRow;
  final double mediaHeight;
  final double mediaWidth;
  final ValueChanged<dartz.Either<CommentDetailsEntity, ReplyDetailsEntity>>
      onReplyButtonPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildUserCircleAvatarImage(
              profilePicUrl:
                  commentDetailsEntity.comment.commentAuthorData.profilePicUrl,
              circleAvatarRadius: 20,
            ),
            const HorizontalGap(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${commentDetailsEntity.comment.commentAuthorData.firstName} ${commentDetailsEntity.comment.commentAuthorData.lastName}",
                        style: AppTextStyles.uberMoveBold18,
                      ),
                      const HorizontalGap(8),
                      Text(
                        commentDetailsEntity.comment.commentAuthorData.email,
                        style: AppTextStyles.uberMoveMedium16
                            .copyWith(color: AppColors.secondaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  if (commentDetailsEntity.comment.content != null)
                    Column(
                      children: [
                        const VerticalGap(4),
                        Text(
                          commentDetailsEntity.comment.content!,
                          style: AppTextStyles.uberMoveRegular16,
                        ),
                      ],
                    ),
                  if (commentDetailsEntity.comment.mediaUrl?.isNotEmpty ??
                      false)
                    Column(
                      children: [
                        const VerticalGap(8),
                        CustomShowTweetsMedia(
                          mediaUrl: commentDetailsEntity.comment.mediaUrl!,
                          mediaHeight: mediaHeight,
                          mediaWidth: mediaWidth,
                        ),
                      ],
                    ),
                  const VerticalGap(8),
                  Visibility(
                    visible: showInteractionsRow,
                    child: CustomCommentInteractionsRow(
                      commentDetailsEntity: commentDetailsEntity,
                      onReplyButtonPressed: onReplyButtonPressed,
                    ),
                  ),
                  ShowCommentRepliesPart(
                    commentDetailsEntity: commentDetailsEntity,
                    onReplyButtonPressed: onReplyButtonPressed,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
