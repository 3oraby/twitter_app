import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/follow_relationships/domain/entities/user_with_follow_status_entity.dart';

class UserWithFollowStatusModel extends UserWithFollowStatusEntity {
  UserWithFollowStatusModel({
    required super.user,
    required super.followsYou,
    required super.isFollowed,
  });

  factory UserWithFollowStatusModel.fromJson(Map<String, dynamic> json) {
    return UserWithFollowStatusModel(
      user: UserModel.fromJson(json['user']),
      followsYou: json['followsYou'] ?? false,
      isFollowed: json['isFollowed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'followsYou': followsYou,
      'isFollowed': isFollowed,
    };
  }

  UserWithFollowStatusEntity toEntity() {
    return UserWithFollowStatusEntity(
      user: user, 
      followsYou: followsYou,
      isFollowed: isFollowed,
    );
  }

  factory UserWithFollowStatusModel.fromEntity(
      UserWithFollowStatusEntity entity) {
    return UserWithFollowStatusModel(
      user: entity.user,
      followsYou: entity.followsYou,
      isFollowed: entity.isFollowed,
    );
  }
}
