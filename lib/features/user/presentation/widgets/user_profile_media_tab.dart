import 'package:flutter/material.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_show_tweet_feed.dart';

class UserProfileMediaTab extends StatelessWidget {
  const UserProfileMediaTab({
    super.key,
    this.targetUserId,
  });

  final String? targetUserId;

  @override
  Widget build(BuildContext context) {
    return CustomShowTweetFeed(
      targetUserId: targetUserId,
      tweetFilterOption: const GetTweetsFilterOptionModel(
        includeTweetsWithImages: true,
      ),
    );
  }
}
