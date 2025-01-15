import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

class UserWithFollowStatusEntity {
  final UserEntity user;
  final bool isFollowingCurrentUser;
  final bool isFollowedByCurrentUser;

  const UserWithFollowStatusEntity({
    required this.user,
    required this.isFollowingCurrentUser,
    required this.isFollowedByCurrentUser,
  });
}
