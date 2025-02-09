import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_show_tweet_media.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/presentation/widgets/custom_reply_interactions_row.dart';
import 'package:twitter_app/features/user/presentation/screens/user_profile_screen.dart';

class CustomReplyInfoCard extends StatelessWidget {
  const CustomReplyInfoCard({
    super.key,
    required this.replyDetailsEntity,
    this.showInteractionsRow = true,
    this.mediaHeight = 150,
    this.mediaWidth = 100,
    required this.onReplyButtonPressed,
  });
  final ReplyDetailsEntity replyDetailsEntity;
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  UserProfileScreen.routeId,
                  arguments: replyDetailsEntity.reply.replyAuthorData,
                );
              },
              child: BuildUserCircleAvatarImage(
                profilePicUrl:
                    replyDetailsEntity.reply.replyAuthorData.profilePicUrl,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            UserProfileScreen.routeId,
                            arguments: replyDetailsEntity.reply.replyAuthorData,
                          );
                        },
                        child: Text(
                          "${replyDetailsEntity.reply.replyAuthorData.firstName} ${replyDetailsEntity.reply.replyAuthorData.lastName}",
                          style: AppTextStyles.uberMoveBold18,
                        ),
                      ),
                      const HorizontalGap(8),
                      Icon(
                        FontAwesomeIcons.play,
                        size: 18,
                      ),
                      const HorizontalGap(8),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            UserProfileScreen.routeId,
                            arguments:
                                replyDetailsEntity.reply.commentAuthorData,
                          );
                        },
                        child: Text(
                          "${replyDetailsEntity.reply.commentAuthorData.firstName} ${replyDetailsEntity.reply.commentAuthorData.lastName}",
                          style: AppTextStyles.uberMoveMedium16
                              .copyWith(color: AppColors.secondaryColor),
                          overflow: TextOverflow.ellipsis,
                        ),
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
