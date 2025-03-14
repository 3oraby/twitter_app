import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_model.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_entity.dart';

class TweetDetailsModel extends TweetDetailsEntity {
  TweetDetailsModel({
    required super.tweetId,
    required super.tweet,
    required super.user,
    super.isLiked,
    super.isRetweeted,
    super.isBookmarked,
  });

  TweetDetailsEntity toEntity() {
    return TweetDetailsEntity(
      tweetId: tweetId,
      tweet: tweet,
      user: user,
      isLiked: isLiked,
      isRetweeted: isRetweeted,
      isBookmarked: isBookmarked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tweetId': tweetId,
      'tweet': TweetModel.fromEntity(tweet).toJson(),
      'user': UserModel.fromEntity(user).toJson(),
      'isLiked': isLiked,
      'isRetweeted': isRetweeted,
      'isBookmarked': isBookmarked,
    };
  }

  factory TweetDetailsModel.fromJson(Map<String, dynamic> json) {
    return TweetDetailsModel(
      tweetId: json['tweetId'],
      tweet: TweetModel.fromMap(json['tweet']).toEntity(),
      user: UserModel.fromJson(json['user']).toEntity(),
      isLiked: json['isLiked'] ?? false,
      isRetweeted: json['isRetweeted'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }
  factory TweetDetailsModel.fromEntity(TweetDetailsEntity entity) {
    return TweetDetailsModel(
      tweetId: entity.tweetId,
      tweet: TweetModel.fromEntity(entity.tweet),
      user: UserModel.fromEntity(entity.user),
      isLiked: entity.isLiked,
      isRetweeted: entity.isRetweeted,
      isBookmarked: entity.isBookmarked,
    );
  }

  TweetDetailsModel copyWith({
    String? tweetId,
    TweetEntity? tweet,
    UserEntity? user,
    bool? isLiked,
    bool? isRetweeted,
    bool? isBookmarked,
  }) {
    return TweetDetailsModel(
      tweetId: tweetId ?? this.tweetId,
      tweet: tweet ?? this.tweet,
      user: user ?? this.user,
      isLiked: isLiked ?? this.isLiked,
      isRetweeted: isRetweeted ?? this.isRetweeted,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
