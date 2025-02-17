import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_entity.dart';

class TweetDetailsEntity {
  final String tweetId;
  final TweetEntity tweet;
  final UserEntity user;
  bool isLiked;
  bool isRetweeted;
  bool isBookmarked;

  TweetDetailsEntity({
    required this.tweetId,
    required this.tweet,
    required this.user,
    this.isLiked = false,
    this.isRetweeted = false,
    this.isBookmarked = false,
  });

  void addLike() {
    isLiked = true;
    tweet.likesCount++;
  }

  void removeLike() {
    isLiked = false;
    tweet.likesCount--;
  }

  void makeRetweet() {
    isRetweeted = true;
    tweet.retweetsCount++;
  }

  void removeRetweet() {
    isRetweeted = false;
    tweet.retweetsCount--;
  }

  void addToBookmarks() {
    isBookmarked = true;
  }

  void removeFromBookmarks() {
    isBookmarked = false;
  }

  void makeComment() {
    tweet.commentsCount++;
  }

  void deleteComment() {
    tweet.commentsCount--;
  }
}
