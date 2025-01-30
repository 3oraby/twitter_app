import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/format_date_from_timestamp.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_show_tweet_media.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_tweet_interactions_row.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class CustomMainDetailsTweetCard extends StatelessWidget {
  const CustomMainDetailsTweetCard({
    super.key,
    required this.tweetDetailsEntity,
    this.showInteractionsRow = true,
    this.mediaHeight = 300,
    this.mediaWidth = 250,
    this.onTweetTap,
  });
  final TweetDetailsEntity tweetDetailsEntity;
  final bool showInteractionsRow;
  final double mediaHeight;
  final double mediaWidth;
  final VoidCallback? onTweetTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTweetTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BuildUserCircleAvatarImage(
                  profilePicUrl: tweetDetailsEntity.user.profilePicUrl,
                ),
                const HorizontalGap(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${tweetDetailsEntity.user.firstName} ${tweetDetailsEntity.user.lastName}",
                      style: AppTextStyles.uberMoveBold18,
                    ),
                    const HorizontalGap(8),
                    Text(
                      tweetDetailsEntity.user.email,
                      style: AppTextStyles.uberMoveMedium16
                          .copyWith(color: AppColors.secondaryColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            const VerticalGap(12),
            Text(
              tweetDetailsEntity.tweet.content ?? '',
              style: AppTextStyles.uberMoveRegular16,
            ),
            const VerticalGap(12),
            if (tweetDetailsEntity.tweet.mediaUrl?.isNotEmpty ?? false)
              CustomShowTweetsMedia(
                mediaUrl: tweetDetailsEntity.tweet.mediaUrl!,
                mediaHeight: mediaHeight,
                mediaWidth: mediaWidth,
              ),
            const VerticalGap(12),
            Text(
              formatDateFromTimestamp(tweetDetailsEntity.tweet.createdAt),
              style: AppTextStyles.uberMoveBold18
                  .copyWith(color: AppColors.thirdColor),
            ),
            const VerticalGap(12),
            Visibility(
              visible: showInteractionsRow,
              child: CustomTweetInteractionsRow(
                tweetDetailsEntity: tweetDetailsEntity,
              ),
            )
          ],
        ),
      ),
    );
  }
}
