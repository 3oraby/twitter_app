import 'package:flutter/material.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_show_tweet_feed.dart';

class UserProfilePostsTab extends StatelessWidget {
  const UserProfilePostsTab({
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
        includeUserTweets: true,
      ),
      mainLabelEmptyBody:
          isForCurrentUser ? "No posts yet 📝" : "No posts found 📭",
      subLabelEmptyBody: isForCurrentUser
          ? "You haven't posted anything yet. Share your thoughts! ✨"
          : "This user hasn't posted anything yet. 🤷‍♂️",
    );
  }
}
