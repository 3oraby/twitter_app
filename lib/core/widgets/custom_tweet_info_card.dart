
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_like_button.dart';
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
              if (tweetDetailsEntity.tweet.mediaUrl != null)
                CustomShowTweetsMedia(
                  mediaUrl: tweetDetailsEntity.tweet.mediaUrl!,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomCommentButton(),
                  const CustomRetweetButton(),
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

class CustomRetweetButton extends StatelessWidget {
  const CustomRetweetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.share),
    );
  }
}

class CustomCommentButton extends StatelessWidget {
  const CustomCommentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.add_comment_outlined),
    );
  }
}

class CustomShowTweetsMedia extends StatelessWidget {
  const CustomShowTweetsMedia({
    super.key,
    required this.mediaUrl,
  });

  final List<String> mediaUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mediaUrl.length,
        separatorBuilder: (context, index) => const HorizontalGap(12),
        itemBuilder: (context, index) => Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              child: Image.network(
                mediaUrl[index],
                height: 300,
                width: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}