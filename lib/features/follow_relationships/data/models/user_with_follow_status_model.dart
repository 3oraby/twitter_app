import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/follow_relationships/domain/entities/user_with_follow_status_entity.dart';

class UserWithFollowStatusModel extends UserWithFollowStatusEntity {
  UserWithFollowStatusModel({
    required super.user,
    required super.isFollowingCurrentUser,
    required super.isFollowedByCurrentUser,
  });

  factory UserWithFollowStatusModel.fromJson(Map<String, dynamic> json) {
    return UserWithFollowStatusModel(
      user: UserModel.fromJson(json['user']),
      isFollowingCurrentUser: json['isFollowingCurrentUser'] ?? false,
      isFollowedByCurrentUser: json['isFollowedByCurrentUser'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': UserModel.fromEntity(user).toJson(),
      'isFollowingCurrentUser': isFollowingCurrentUser,
      'isFollowedByCurrentUser': isFollowedByCurrentUser,
    };
  }

  UserWithFollowStatusEntity toEntity() {
    return UserWithFollowStatusEntity(
      user: user,
      isFollowingCurrentUser: isFollowingCurrentUser,
      isFollowedByCurrentUser: isFollowedByCurrentUser,
    );
  }

  factory UserWithFollowStatusModel.fromEntity(
      UserWithFollowStatusEntity entity) {
    return UserWithFollowStatusModel(
      user: entity.user,
      isFollowingCurrentUser: entity.isFollowingCurrentUser,
      isFollowedByCurrentUser: entity.isFollowedByCurrentUser,
    );
  }
}
