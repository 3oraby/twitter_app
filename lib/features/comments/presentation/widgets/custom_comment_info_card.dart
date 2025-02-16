import 'dart:developer';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_show_tweet_media.dart';
import 'package:twitter_app/core/widgets/custom_tweets_menu.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/widgets/custom_comment_interactions_row.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/presentation/widgets/show_comment_replies_part.dart';
import 'package:twitter_app/features/user/presentation/screens/user_profile_screen.dart';

class CustomCommentInfoCard extends StatefulWidget {
  const CustomCommentInfoCard({
    super.key,
    required this.commentDetailsEntity,
    required this.currentUser,
    required this.onReplyButtonPressed,
    this.showInteractionsRow = true,
    this.mediaHeight = 300,
    this.mediaWidth = 250,
    this.onDeleteCommentTap,
    this.onEditCommentTap,
  });
  final CommentDetailsEntity commentDetailsEntity;
  final UserEntity currentUser;
  final bool showInteractionsRow;
  final double mediaHeight;
  final double mediaWidth;
  final ValueChanged<dartz.Either<CommentDetailsEntity, ReplyDetailsEntity>>
      onReplyButtonPressed;
  final VoidCallback? onDeleteCommentTap;
  final VoidCallback? onEditCommentTap;

  @override
  State<CustomCommentInfoCard> createState() => _CustomCommentInfoCardState();
}

class _CustomCommentInfoCardState extends State<CustomCommentInfoCard> {
  void _onUserProfileCommentTap() {
    log('User selected: user profile');
    Navigator.pushNamed(
      context,
      UserProfileScreen.routeId,
      arguments: widget.commentDetailsEntity.comment.commentAuthorData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _onUserProfileCommentTap,
              child: BuildUserCircleAvatarImage(
                profilePicUrl: widget.commentDetailsEntity.comment
                    .commentAuthorData.profilePicUrl,
                circleAvatarRadius: 20,
              ),
            ),
            const HorizontalGap(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _onUserProfileCommentTap,
                    child: Row(
                      children: [
                        Text(
                          "${widget.commentDetailsEntity.comment.commentAuthorData.firstName} ${widget.commentDetailsEntity.comment.commentAuthorData.lastName}",
                          style: AppTextStyles.uberMoveBold18,
                        ),
                        const HorizontalGap(8),
                        Flexible(
                          child: Text(
                            widget.commentDetailsEntity.comment
                                .commentAuthorData.email,
                            style: AppTextStyles.uberMoveMedium16
                                .copyWith(color: AppColors.secondaryColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        CustomTweetsMenu(
                          currentUserId: widget.currentUser.userId,
                          autherEntity: widget
                              .commentDetailsEntity.comment.commentAuthorData,
                          onDeleteTweetTap: widget.onDeleteCommentTap,
                          onEditTweetTap: widget.onEditCommentTap,
                        )
                      ],
                    ),
                  ),
                  if (widget.commentDetailsEntity.comment.content != null)
                    Column(
                      children: [
                        const VerticalGap(4),
                        Text(
                          widget.commentDetailsEntity.comment.content!,
                          style: AppTextStyles.uberMoveRegular16,
                        ),
                      ],
                    ),
                  if (widget
                          .commentDetailsEntity.comment.mediaUrl?.isNotEmpty ??
                      false)
                    Column(
                      children: [
                        const VerticalGap(8),
                        CustomShowTweetsMedia(
                          mediaUrl:
                              widget.commentDetailsEntity.comment.mediaUrl!,
                          mediaHeight: widget.mediaHeight,
                          mediaWidth: widget.mediaWidth,
                        ),
                      ],
                    ),
                  const VerticalGap(8),
                  Visibility(
                    visible: widget.showInteractionsRow,
                    child: CustomCommentInteractionsRow(
                      currentUser: widget.currentUser,
                      commentDetailsEntity: widget.commentDetailsEntity,
                      onReplyButtonPressed: widget.onReplyButtonPressed,
                    ),
                  ),
                  ShowCommentRepliesPart(
                    currentUser: widget.currentUser,
                    commentDetailsEntity: widget.commentDetailsEntity,
                    onReplyButtonPressed: widget.onReplyButtonPressed,
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
