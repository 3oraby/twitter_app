import 'package:twitter_app/features/bookmark/domain/entities/bookmark_entity.dart';

class BookmarkModel extends BookmarkEntity {
  BookmarkModel({
    required super.userId,
    required super.originalAuthorId,
    required super.tweetId,
    required super.bookmarkedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'originalAuthorId': originalAuthorId,
      'tweetId': tweetId,
      'bookmarkedAt': bookmarkedAt,
    };
  }

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      userId: json['userId'],
      originalAuthorId: json['originalAuthorId'],
      tweetId: json['tweetId'],
      bookmarkedAt: json['bookmarkedAt'],
    );
  }

  BookmarkEntity toEntity() {
    return BookmarkEntity(
      userId: userId,
      originalAuthorId: originalAuthorId,
      tweetId: tweetId,
      bookmarkedAt: bookmarkedAt,
    );
  }

  factory BookmarkModel.fromEntity(BookmarkEntity entity) {
    return BookmarkModel(
      userId: entity.userId,
      originalAuthorId: entity.originalAuthorId,
      tweetId: entity.tweetId,
      bookmarkedAt: entity.bookmarkedAt,
    );
  }
}
