import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_tweet_info_card.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class ForYouTabBarBody extends StatelessWidget {
  const ForYouTabBarBody({
    super.key,
    required this.tweets,
  });
  final List<TweetDetailsEntity> tweets;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const VerticalGap(24),
          for (int index = 0; index < tweets.length; index++) ...[
            CustomTweetInfoCard(
              tweetDetailsEntity: tweets[index],
            ),
            if (index !=
                tweets.length - 1)
              const Divider(
                color: AppColors.dividerColor,
                height: 24,
              ),
          ],
        ],
      ),
    );
  }
}
