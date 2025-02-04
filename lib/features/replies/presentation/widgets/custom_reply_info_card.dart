import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_show_tweet_media.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/presentation/widgets/custom_reply_interactions_row.dart';

class CustomReplyInfoCard extends StatelessWidget {
  const CustomReplyInfoCard({
    super.key,
    required this.replyDetailsEntity,
    this.showInteractionsRow = true,
    this.mediaHeight = 150,
    this.mediaWidth = 100,
    // this.onTweetTap,
    // required this.onReplyButtonPressed,
  });
  final ReplyDetailsEntity replyDetailsEntity;
  final bool showInteractionsRow;
  final double mediaHeight;
  final double mediaWidth;
  // final VoidCallback? onTweetTap;
  // final ValueChanged<replyDetailsEntity> onReplyButtonPressed;

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
                  replyDetailsEntity.reply.replyAuthorData.profilePicUrl,
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
                        "${replyDetailsEntity.reply.replyAuthorData.firstName} ${replyDetailsEntity.reply.replyAuthorData.lastName}",
                        style: AppTextStyles.uberMoveBold18,
                      ),
                      const HorizontalGap(8),
                      Icon(
                        FontAwesomeIcons.play,
                        size: 18,
                      ),
                      const HorizontalGap(8),
                      Text(
                        "${replyDetailsEntity.reply.commentAuthorData.firstName} ${replyDetailsEntity.reply.commentAuthorData.lastName}",
                        style: AppTextStyles.uberMoveMedium16
                            .copyWith(color: AppColors.secondaryColor),
                        overflow: TextOverflow.ellipsis,
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
                      // onReplyButtonPressed: onReplyButtonPressed,
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
