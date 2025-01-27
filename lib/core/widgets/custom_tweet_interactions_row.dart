
import 'package:flutter/material.dart';
import 'package:twitter_app/core/widgets/custom_bookmark_button.dart';
import 'package:twitter_app/core/widgets/custom_comment_button.dart';
import 'package:twitter_app/core/widgets/custom_like_button.dart';
import 'package:twitter_app/core/widgets/custom_retweet_button.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class CustomTweetInteractionsRow extends StatelessWidget {
  const CustomTweetInteractionsRow({
    super.key,
    required this.tweetDetailsEntity,
  });

  final TweetDetailsEntity tweetDetailsEntity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomCommentButton(
          commentsCount: tweetDetailsEntity.tweet.commentsCount,
          tweetDetailsEntity: tweetDetailsEntity,
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
        CustomBookmarkButton(
          tweetId: tweetDetailsEntity.tweetId,
          originalAuthorId: tweetDetailsEntity.tweet.userId,
          isActive: tweetDetailsEntity.isBookmarked,
        ),
      ],
    );
  }
}
