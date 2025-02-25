import 'package:flutter/material.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_show_tweet_feed.dart';

class UserProfileLikesTab extends StatelessWidget {
  const UserProfileLikesTab({
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
        includeLikedTweets: true,
      ),
      mainLabelEmptyBody: isForCurrentUser
          ? "You haven't liked any tweets yet ❤️"
          : "No likes found 🤷",
      subLabelEmptyBody: isForCurrentUser
          ? "Tap the heart ❤️ on tweets to like them and see them here!"
          : "This user hasn't liked any tweets yet. 🧐",
    );
  }
}
