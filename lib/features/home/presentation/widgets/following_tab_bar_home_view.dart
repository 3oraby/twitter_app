import 'package:flutter/material.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_show_tweet_feed.dart';

class FollowingTabBarHomeView extends StatelessWidget {
  const FollowingTabBarHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomShowTweetFeed(
      tweetFilterOption: GetTweetsFilterOptionModel(
        isForFollowingOnly: true,
      ),
      mainLabelEmptyBody: "No tweets available",
      subLabelEmptyBody: "Follow more users to see tweets here",
    );
  }
}
