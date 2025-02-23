import 'package:flutter/material.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/follow_relationships/domain/entities/user_with_follow_status_entity.dart';
import 'package:twitter_app/features/follow_relationships/presentation/widgets/user_info_card.dart';

class CustomShowUsersList extends StatelessWidget {
  const CustomShowUsersList({
    super.key,
    required this.userConnections,
    required this.currentUser,
  });

  final List<UserWithFollowStatusEntity> userConnections;
  final UserEntity currentUser;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: userConnections.length,
      separatorBuilder: (context, index) => const VerticalGap(24),
      itemBuilder: (context, index) => UserInfoCard(
        user: userConnections[index].user,
        currentUserId: currentUser.userId,
        showFollowsYouLabel: userConnections[index].isFollowingCurrentUser,
        isActiveFollowButton: userConnections[index].isFollowedByCurrentUser,
      ),
    );
  }
}
