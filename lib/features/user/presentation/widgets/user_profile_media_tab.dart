import 'package:flutter/material.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_show_tweet_feed.dart';

class UserProfileMediaTab extends StatelessWidget {
  const UserProfileMediaTab({
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
        includeTweetsWithImages: true,
      ),
      mainLabelEmptyBody:
          isForCurrentUser ? "No media found 📷" : "No media available 🎥",
      subLabelEmptyBody: isForCurrentUser
          ? "Share images and videos in your tweets to see them here! 🌟"
          : "This user hasn't shared any media yet. 🤔",
    );
  }
}
