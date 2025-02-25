import 'package:flutter/material.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_show_tweet_feed.dart';

class UserProfileRetweetsTab extends StatelessWidget {
  const UserProfileRetweetsTab({
    super.key,
    required this.currentUserId,
    this.targetUserId,
  });

  final String? targetUserId;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    bool isForCurrentUser = targetUserId == currentUserId;
    return CustomShowTweetFeed(
      targetUserId: targetUserId,
      tweetFilterOption: const GetTweetsFilterOptionModel(
        includeRetweetedTweets: true,
      ),
      mainLabelEmptyBody:
          isForCurrentUser ? "No retweets yet 🔁" : "No retweets found 🔄",
      subLabelEmptyBody: isForCurrentUser
          ? "You haven't retweeted any posts yet. Give it a try! 💬"
          : "This user hasn't retweeted anything yet. 🤷‍♂️",
    );
  }
}
