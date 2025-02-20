import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_show_tweet_media.dart';
import 'package:twitter_app/core/widgets/custom_tweets_menu.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/presentation/widgets/custom_reply_interactions_row.dart';
import 'package:twitter_app/features/user/presentation/screens/user_profile_screen.dart';

class CustomReplyInfoCard extends StatelessWidget {
  const CustomReplyInfoCard({
    super.key,
    required this.replyDetailsEntity,
    required this.currentUser,
    required this.onReplyButtonPressed,
    this.showInteractionsRow = true,
    this.mediaHeight = 150,
    this.mediaWidth = 100,
    this.onDeleteReplyTap,
    this.onEditReplyTap,
  });
  final ReplyDetailsEntity replyDetailsEntity;
  final UserEntity currentUser;
  final bool showInteractionsRow;
  final double mediaHeight;
  final double mediaWidth;
  final ValueChanged<dartz.Either<CommentDetailsEntity, ReplyDetailsEntity>>
      onReplyButtonPressed;

  final VoidCallback? onDeleteReplyTap;
  final VoidCallback? onEditReplyTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  UserProfileScreen.routeId,
                  arguments: replyDetailsEntity.replyAuthorData,
                );
              },
              child: BuildUserCircleAvatarImage(
                profilePicUrl: replyDetailsEntity.replyAuthorData.profilePicUrl,
                circleAvatarRadius: 20,
              ),
            ),
            const HorizontalGap(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Row(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth * 0.6,
                                  ),
                                  child: Text(
                                    "${replyDetailsEntity.replyAuthorData.firstName} ${replyDetailsEntity.replyAuthorData.lastName}",
                                    style: AppTextStyles.uberMoveBold16,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const HorizontalGap(4),
                                Transform(
                                  transform: Directionality.of(context) ==
                                          TextDirection.rtl
                                      ? Matrix4.rotationY(3.1416)
                                      : Matrix4.identity(),
                                  alignment: Alignment.center,
                                  child: const Icon(FontAwesomeIcons.play, size: 18),
                                ),
                                const HorizontalGap(6),
                                Flexible(
                                  child: Text(
                                    "${replyDetailsEntity.commentAuthorData.firstName} ${replyDetailsEntity.commentAuthorData.lastName}",
                                    style:
                                        AppTextStyles.uberMoveMedium14.copyWith(
                                      color: AppColors.secondaryColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      CustomTweetsMenu(
                        key: ValueKey(replyDetailsEntity.replyId),
                        currentUserId: currentUser.userId,
                        autherEntity: replyDetailsEntity.replyAuthorData,
                        onDeleteTweetTap: onDeleteReplyTap,
                        onEditTweetTap: onEditReplyTap,
                      ),
                    ],
                  ),
                  if (replyDetailsEntity.reply.content != null)
                    Column(
                      children: [
                        const VerticalGap(4),
                        Text(
                          replyDetailsEntity.reply.content!,
                          style: AppTextStyles.uberMoveRegular16,
                        ),
                      ],
                    ),
                  if (replyDetailsEntity.reply.mediaUrl?.isNotEmpty ?? false)
                    Column(
                      children: [
                        const VerticalGap(8),
                        CustomShowTweetsMedia(
                          mediaUrl: replyDetailsEntity.reply.mediaUrl!,
                          mediaHeight: mediaHeight,
                          mediaWidth: mediaWidth,
                        ),
                      ],
                    ),
                  const VerticalGap(8),
                  Visibility(
                    visible: showInteractionsRow,
                    child: CustomReplyInteractionsRow(
                      replyDetailsEntity: replyDetailsEntity,
                      onReplyButtonPressed: onReplyButtonPressed,
                    ),
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
