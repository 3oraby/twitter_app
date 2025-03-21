import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/format_date_from_timestamp.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_show_tweet_media.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_tweet_interactions_row.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/user/presentation/screens/user_profile_screen.dart';

class CustomMainDetailsTweetCard extends StatelessWidget {
  const CustomMainDetailsTweetCard({
    super.key,
    required this.tweetDetailsEntity,
    required this.currentUser,
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
  final UserEntity currentUser;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTweetTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  UserProfileScreen.routeId,
                  arguments: tweetDetailsEntity.user,
                );
              },
              child: Row(
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
                        style: AppTextStyles.uberMoveBold(context,18),
                      ),
                      const HorizontalGap(8),
                      Text(
                        tweetDetailsEntity.user.email,
                        style: AppTextStyles.uberMoveMedium(context,16)
                            .copyWith(color: AppColors.secondaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const VerticalGap(12),
            Text(
              tweetDetailsEntity.tweet.content ?? '',
              style: AppTextStyles.uberMoveRegular(context,16),
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
              formatDateFromTimestamp(
                context: context,
                timestamp: tweetDetailsEntity.tweet.createdAt,
              ),
              style: AppTextStyles.uberMoveBold(context,18)
                  .copyWith(color: AppColors.thirdColor),
            ),
            const VerticalGap(12),
            Visibility(
              visible: showInteractionsRow,
              child: CustomTweetInteractionsRow(
                tweetDetailsEntity: tweetDetailsEntity,
                currentUser: currentUser,
              ),
            )
          ],
        ),
      ),
    );
  }
}
