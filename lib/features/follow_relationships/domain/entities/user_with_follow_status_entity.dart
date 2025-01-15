import 'package:twitter_app/features/auth/data/models/user_model.dart';

class UserWithFollowStatusEntity {
  final UserModel user;
  final bool followsYou;
  final bool isFollowed;

  const UserWithFollowStatusEntity({
    required this.user,
    required this.followsYou,
    required this.isFollowed,
  });
}
