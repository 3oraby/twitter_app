import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/domain/entities/tweet_entity.dart';

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
}
