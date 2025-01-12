import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/features/suggestion_followers/domain/entities/following_relationship_entity.dart';

class FollowingRelationshipModel extends FollowingRelationshipEntity {
  FollowingRelationshipModel({
    required super.followedId,
    required super.followingId,
    required super.followedAt,
  });

  factory FollowingRelationshipModel.fromJson(Map<String, dynamic> json) {
    return FollowingRelationshipModel(
      followedId: json['followedId'] as String,
      followingId: json['followingId'] as String,
      followedAt: json['followedAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'followedId': followedId,
      'followingId': followingId,
      'followedAt': followedAt,
    };
  }

  factory FollowingRelationshipModel.fromEntity(
      FollowingRelationshipEntity entity) {
    return FollowingRelationshipModel(
      followedId: entity.followedId,
      followingId: entity.followingId,
      followedAt: entity.followedAt,
    );
  }

  FollowingRelationshipEntity toEntity() {
    return FollowingRelationshipEntity(
      followedId: followedId,
      followingId: followingId,
      followedAt: followedAt,
    );
  }
}
