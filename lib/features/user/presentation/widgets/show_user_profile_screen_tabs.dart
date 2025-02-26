import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/widgets/keep_alive_tab.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/user/presentation/widgets/user_profile_likes_tab.dart';
import 'package:twitter_app/features/user/presentation/widgets/user_profile_media_tab.dart';
import 'package:twitter_app/features/user/presentation/widgets/user_profile_posts_tab.dart';
import 'package:twitter_app/features/user/presentation/widgets/user_profile_retweets_tab.dart';

class ShowUserProfileScreenTabs extends StatefulWidget {
  const ShowUserProfileScreenTabs({
    super.key,
    this.targetUserId,
  });

  final String? targetUserId;

  @override
  State<ShowUserProfileScreenTabs> createState() =>
      _ShowUserProfileScreenTabsState();
}

class _ShowUserProfileScreenTabsState extends State<ShowUserProfileScreenTabs> {
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        KeepAliveTab(
          child: UserProfilePostsTab(
            targetUserId: widget.targetUserId,
            currentUserId: currentUser.userId,
          ),
        ),
        KeepAliveTab(
          child: UserProfileMediaTab(
            targetUserId: widget.targetUserId,
            currentUserId: currentUser.userId,
          ),
        ),
        KeepAliveTab(
          child: UserProfileLikesTab(
            targetUserId: widget.targetUserId,
            currentUserId: currentUser.userId,
          ),
        ),
        KeepAliveTab(
          child: UserProfileRetweetsTab(
            targetUserId: widget.targetUserId,
            currentUserId: currentUser.userId,
          ),
        ),
      ],
    );
  }
}
