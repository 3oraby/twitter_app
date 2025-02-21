import 'package:flutter/material.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_show_tweet_feed.dart';

class UserProfileLikesTab extends StatelessWidget {
  const UserProfileLikesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomShowTweetFeed(
      tweetFilterOption: GetTweetsFilterOptionModel(
        includeLikedTweets: true,
      ),
    );
  }
}
