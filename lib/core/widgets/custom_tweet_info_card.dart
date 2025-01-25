import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_comment_button.dart';
import 'package:twitter_app/core/widgets/custom_like_button.dart';
import 'package:twitter_app/core/widgets/custom_retweet_button.dart';
import 'package:twitter_app/core/widgets/custom_show_tweet_media.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class CustomTweetInfoCard extends StatelessWidget {
  const CustomTweetInfoCard({
    super.key,
    required this.tweetDetailsEntity,
  });
  final TweetDetailsEntity tweetDetailsEntity;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildUserCircleAvatarImage(
          profilePicUrl: tweetDetailsEntity.user.profilePicUrl,
        ),
        const HorizontalGap(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              const VerticalGap(4),
              Text(
                tweetDetailsEntity.tweet.content ?? '',
                style: AppTextStyles.uberMoveRegular16,
              ),
              const VerticalGap(4),
              if (tweetDetailsEntity.tweet.mediaUrl?.isNotEmpty ?? false)
                CustomShowTweetsMedia(
                  mediaUrl: tweetDetailsEntity.tweet.mediaUrl!,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCommentButton(
                    commentsCount: tweetDetailsEntity.tweet.commentsCount,
                  ),
                  CustomRetweetButton(
                    tweetId: tweetDetailsEntity.tweetId,
                    originalAuthorId: tweetDetailsEntity.tweet.userId,
                    retweetsCount: tweetDetailsEntity.tweet.retweetsCount,
                    isActive: tweetDetailsEntity.isRetweeted,
                  ),
                  CustomLikeButton(
                    tweetId: tweetDetailsEntity.tweetId,
                    originalAuthorId: tweetDetailsEntity.tweet.userId,
                    likesCount: tweetDetailsEntity.tweet.likesCount,
                    isActive: tweetDetailsEntity.isLiked,
                  ),
                  const CustomBookMarkButton(),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class CustomBookMarkButton extends StatelessWidget {
  const CustomBookMarkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.bookmark_border_outlined),
    );
  }
}
